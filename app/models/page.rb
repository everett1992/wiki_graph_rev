class Page < ActiveRecord::Base
  belongs_to :wiki
  belongs_to :connected_component

  # Links and pages that lead to this page.
  has_many :backlinks, foreign_key: 'to_id', class_name: :Link, dependent: :destroy
  has_many :backlinked_pages, through: :backlinks, source: :from

  # Links and pages that are reachable from this page.
  has_many :links, foreign_key: 'from_id', dependent: :destroy
  has_many :linked_pages, through: :links, source: :to

  validates_presence_of :title
  #validates_uniqueness_of :title, scope: :wiki

  validates_presence_of :page_ident
  #validates_uniqueness_of :page_ident, scope: :wiki

  validates_presence_of :wiki

  def to_param
    self.title
  end

  def wiki_url
    return "https://#{wiki.short_title}.wikipedia.org/wiki/#{title}"
  end

  def create_link_to(page)
    self.links.create(to: page)
  end

  def connected
    pages = []
    stack = [] # stack for dfs
    stack << self

    while page = stack.pop
      # Add the page to the set of connected pages
      pages << page

      # Stack linked pages that are not already in the set
      stack.concat page.linked_pages.reject { |c| pages.include? c }
    end

    return pages
  end
end
