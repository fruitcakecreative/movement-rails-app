class Event < ApplicationRecord
  belongs_to :venue
  has_and_belongs_to_many :genres
  has_many :event_attendees
  has_many :users, through: :event_attendees
  has_and_belongs_to_many :artists

  def top_artists
    artists.sort_by { |a| -(a.ra_followers || 0) }.first(10).map do |artist|
      {
        id: artist.id,
        name: artist.name,
        ra_followers: artist.ra_followers
      }
    end
  end

  # Convert start_time to Planby-compatible format (remove 'Z')
  def formatted_start_time
    start_time&.strftime("%Y-%m-%dT%H:%M:%S") # Removes 'Z'
  end

  # Convert end_time to Planby-compatible format (remove 'Z')
  def formatted_end_time
    end_time&.strftime("%Y-%m-%dT%H:%M:%S") # Removes 'Z'
  end
end
