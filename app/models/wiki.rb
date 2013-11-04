class Wiki < ActiveRecord::Base
  has_many :pages

  has_many :links, through: :pages

  validates_uniqueness_of :title
  validates_presence_of :title

  def get_pages
    dump = Dump.new(self.name, 'page')
    dump.each_record do |page_id, namespace, title, attributesattributes|
      self.pages.create( wiki: self, title: title, page_id: page_id, namespace: namespace )
    end
  end

  def get_page_links
    dump = Dump.new(self.name, 'pagelinks')
    dump.each_record do |from_id, namespace, to_title|

      from = Page.find(:page_id => from_id, wiki: self)
      to = Page.find(:title => to_title, wiki: self)

      unless to.nil? || from.nil?
        Link.create(from: from, to: to)
      end
    end
  end
end
