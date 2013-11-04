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
    File.exits(@filename)
  end

  def each_record!(&block)
    unless self.downloaded?
      self.download
    end
    parse(&block)
  end

  def each_record(&block)
    raise "Dump does not exits, Download it first" unless self.downloaded?

    f = File.open(@filename)

    begin                               # read file until line starting with INSERT INTO
      line = f.gets
    end until line.match(/^INSERT INTO/)

    begin
      line = line.match(/\(.*\)[,;]/)[0]  # ignore begining of line until (...) object
      begin
        yield line[1..-3].split(',').map { |e| e.match(/^['"].*['"]$/) ?  e[1..-2] : e.to_f }
        line = f.gets.chomp
      end while(line[0] == '(')          # until next insert block, or end of file
    end while  line.match(/^INSERT INTO/) # Until line doesn't start with (...

    f.close
  end
end
