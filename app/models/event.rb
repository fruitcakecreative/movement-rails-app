class Event < ApplicationRecord
  belongs_to :venue
  has_and_belongs_to_many :genres
  has_many :event_attendees
  has_many :users, through: :event_attendees
  has_many :artist_events
  has_many :artists, through: :artist_events

  def top_artists
    artists.sort_by { |a| -(a.ra_followers || 0) }.first(10).map do |artist|
      {
        id: artist.id,
        name: artist.name,
        ra_followers: artist.ra_followers
      }
    end
  end

  after_commit :process_manual_artist_names, if: -> { manual_artist_names.present? }

  def process_manual_artist_names
    names = manual_artist_names.split(",").map(&:strip).reject(&:blank?)
    names.each do |name|
      artist = Artist.find_or_create_by!(name: name)
      self.artists << artist unless self.artist_ids.include?(artist.id)
    end
    update_column(:manual_artist_names, nil)
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
