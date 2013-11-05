def update_proc(name)
  Proc.new do |n, run_time|
    print "Created #{n} #{name} in %.2f seconds. %.2f r/s             \r" % [run_time, n / run_time]
  end
end

class Wiki < ActiveRecord::Base
  has_many :pages

  has_many :links, through: :pages

  validates_uniqueness_of :title
  validates_presence_of :title

  def get_pages
    dump = Dump.new(self.title, 'page')
    dump.each_record!(update_proc 'pages') do |page_ident, namespace, title, attributesattributes|
      self.pages.create( wiki: self, title: title, page_ident: page_ident, namespace: namespace )
    end
  end

  def get_page_links
    dump = Dump.new(self.title, 'pagelinks')
    dump.each_record!(update_proc 'page links') do |from_id, namespace, to_title|

      from = Page.where(:page_ident => from_id, wiki: self).first
      to = Page.where(:title => to_title, wiki: self).first

      unless to.nil? || from.nil?
        Link.create(from: from, to: to)
      end
    end
  end
end
