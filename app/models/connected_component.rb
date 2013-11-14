class ConnectedComponent < ActiveRecord::Base
  belongs_to :wiki
  has_many :pages

  validates_presence_of :wiki
end
