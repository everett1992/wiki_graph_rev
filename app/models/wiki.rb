
class Wiki < ActiveRecord::Base
  has_many :pages, dependent: :destroy

  has_many :links, through: :pages

  validates_uniqueness_of :title
  validates_presence_of :title

  def to_param
    title
  end

  def get_pages
    dump = Dump.new(self.title, 'page')
    dump.each_record!(update_proc 'pages') do |page_ident, namespace, title, attributesattributes|
      if namespace == 0
        self.pages.create(title: title, page_ident: page_ident)
      end
    end
    puts
    puts "Created #{pages.count} page"
  end

  def get_page_links
    dump = Dump.new(self.title, 'pagelinks')
    dump.each_record!(update_proc 'page links') do |from_id, namespace, to_title|
      if namespace == 0

        from = Page.where(:page_ident => from_id, wiki: self).first
        to = Page.where(:title => to_title, wiki: self).first

        unless to.nil? || from.nil?
          Link.create(from: from, to: to)
        end
      end
    end

    puts
    puts "Created #{links.count} page links"
  end

  def short_title
    return title.match(/.*(?=wiki)/).to_s
  end

  # Returns a page with at leasat min_links links
  def random_page(min_links=0)
    c = pages.count
    begin
      page = pages.find(:first, offset: rand(c))
    end while page.links.count <= min_links
    return page
  end

  private

  def update_proc(name)
    Proc.new do |t, t_time, d, d_time|
      print "\rCreated %i #{name} in %.2f seconds. %.2f r/s\033[K" % [t, t_time, d / d_time.to_f]
    end
  end
end
