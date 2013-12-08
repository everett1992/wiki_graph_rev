
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

  def find_connected_components
    while page = pages.where(connected_component_id: nil).first
      cc = self.connected_components.new
      cc.pages = page.connected
      cc.save
    end
  end

  def connected_components
    vertexes = self.pages.pluck(:id)
    # I tried building in memory adjacancy matrixes, but exceded 8G memory.
    # TODO: Look into adjacancy matrix again (build in mysql?)
    # Returns an array of pages that link to the passed page
    adj_proc = Proc.new { |page_id| Link.where(from_id: page_id).pluck(:to_id) }
    # Returns an array of pages that link to the passed page (used for reverse graph)
    rev_adj_proc = Proc.new { |page_id| Link.where(to_id: page_id).pluck(:from_id) }

    cc = ConnectedComponents.new(vertexes, adj_proc, rev_adj_proc)
    return cc
  end

  private

  def update_proc(name)
    Proc.new do |t, t_time, d, d_time|
      print "\rCreated %i #{name} in %.2f seconds. %.2f r/s\033[K" % [t, t_time, d / d_time.to_f]
    end
  end
end
