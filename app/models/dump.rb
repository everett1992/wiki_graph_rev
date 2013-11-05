class Dump
  def initialize(wiki, dump)
    @wiki = wiki
    @dump = dump
    @filename = Rails.root.join('lib','assets', "#{wiki}-#{dump}.sql")
  end

  # Don't judge me for using shell scripts here
  def download
    url = "http://dumps.wikimedia.org/#{@wiki}/latest/#{@wiki}-latest-#{@dump}.sql.gz"
    tmp = Rails.root.join('tmp', "#{@wiki}-#{@dump}.sql")

    %x[curl -# #{url} | gunzip -c | sed -e 's/),(/),\\n(/g' > #{tmp} && mv #{tmp} #{@filename}]
    raise "Failed to download #{url}" if $?.exitstatus != 0

    return true
  end

  def downloaded?
    File.exists?(@filename)
  end

  def each_record!(update_proc, &block)
    unless self.downloaded?
      self.download
    end
    self.each_record(update_proc, &block)
  end

  def each_record(update_proc, &block)
    raise "Dump does not exist, Download it first" unless self.downloaded?

    f = File.open(@filename)

    begin                               # read file until line starting with INSERT INTO
      line = f.gets
    end until line.match(/^INSERT INTO/)


    start = Time.now
    last = start
    update_proc_limit = 2 # call update proc every two seconds
    num_processed = 0

    # For each insert block
    begin
      line = line.match(/\(.*\)[,;]/)[0]  # ignore begining of line until (...) object

      # For each line
      begin
        yield line[1..-3].split(',').map { |e| e.match(/^['"].*['"]$/) ?  e[1..-2] : e.to_f }
        num_processed += 1
        line = f.gets.chomp

        if (Time.now - last) > update_proc_limit
          last = Time.now
          update_proc.call num_processed, (last - start)
        end

      end while(line[0] == '(')          # until next insert block, or end of file

    end while  line.match(/^INSERT INTO/) # Until line doesn't start with (...

    f.close
  end
end
