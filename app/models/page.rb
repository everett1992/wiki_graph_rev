class Page < ActiveRecord::Base
  belongs_to :wiki

  # Links and pages that lead to this page.
  has_many :backlinks, foreign_key: 'to_id', class_name: :Link
  has_many :backlinked_pages, through: :backlinks, source: :from

  # Links and pages that are reachable from this page.
  has_many :links, foreign_key: 'from_id'
  has_many :linked_pages, through: :links, source: :to

  validates_presence_of :title
  validates_uniqueness_of :title, scope: :wiki

  validates_presence_of :page_ident
  validates_uniqueness_of :page_ident, scope: :wiki

  validates_presence_of :wiki

  def to_param
    self.title
  end

  def create_link_to(page)
    self.links.create(to: page)
  end
end
