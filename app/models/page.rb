class Page < ActiveRecord::Base
  belongs_to :wiki

  # Links and pages that lead to this page.
  has_many :backlinks, foreign_key: 'to_id', class_name: :Link
  has_many :backlinked_pages, through: :backlinks, source: :from

  # Links and pages that are reachable from this page.
  has_many :links, foreign_key: 'from_id'
  has_many :linked_pages, through: :links, source: :to

  validates_uniqueness_of :title
  validates_presence_of :title

  validates_presence_of :wiki

  def create_link_to(page)
    self.links.create(to: page)
  end
end
