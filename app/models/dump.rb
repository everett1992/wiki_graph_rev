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

    start = Time.now       # When processing was started
    last = start           # Last time time update was run
    update_proc_limit = 2  # How long between running update proc
    n = 0      # Total number of rows added
    d = 0 # Number of rows added in this time chunk

    while line = f.gets
      if line.match(/(?<=VALUES |^)\((.*)\)(?=[,;])/)
        yield $1.split(',').take(3).map { |e| e.match(/(?<=^['"]).*(?=['"]$)/) ? $& : e.to_i }

        n += 1
        d += 1

        now = Time.now
        if (now - last) >= update_proc_limit
          update_proc.call n, (now - start), d, (now - last)
          last = Time.now
          d = 0
        end
      end
    end

    f.close
  end
end
