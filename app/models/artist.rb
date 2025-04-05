class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  validates :name, presence: true
  # genre validation removed or made optional
end
