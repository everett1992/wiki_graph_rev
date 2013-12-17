class Link < ActiveRecord::Base
  belongs_to :from, class_name: :Page, foreign_key: 'from_id'
  belongs_to :to, class_name: :Page, foreign_key: 'to_id'

  belongs_to :connected_component

  validates_presence_of :to
  validates_presence_of :from

  validates_uniqueness_of :to, scope: :from

  # Returns a collection of all links between the collection of pages
  def self.interior_links(pages)
    page_ids = pages.map(&:id)
    Link.where to_id: page_ids, from_id: page_ids
  end
end
