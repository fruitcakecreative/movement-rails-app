class Artist < ApplicationRecord
  belongs_to :genre
  validates :name, presence: true
  validates :genre, presence: true
end
