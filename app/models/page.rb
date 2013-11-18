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

  # Returns a collection of all pages connected to this page.
  def connected
    # Bredth first search
    page_ids = []
    next_page_ids = [self.id]

    while not next_page_ids.empty?
      page_ids.concat next_page_ids
      next_page_ids = Link.where(from_id: next_page_ids).pluck(:to_id).uniq.delete_if { |page_id| page_ids.include? page_id }
    end

    Page.where id: page_ids
  end
end
