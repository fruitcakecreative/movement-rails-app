class Venue < ApplicationRecord
  has_many :events
  serialize :additional_images, Array
end
