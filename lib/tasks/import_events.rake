namespace :import do
  desc "Import events from JSON file"
  task events: :environment do
    require 'json'

    file_path = Rails.root.join('events.json')
    unless File.exist?(file_path)
      puts "❌ No events.json file found!"
      exit
    end

    events = JSON.parse(File.read(file_path))

    events.each_with_index do |event_data, index|
      event_info = event_data["event"]
      next unless event_info

      begin
        ActiveRecord::Base.transaction do
          # Extract venue details
          venue_name = event_info.dig("venue", "name") || "Unknown Venue"
          venue = Venue.find_or_create_by!(name: venue_name)

          # Handle genres
          genres = if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                     event_info["genres"].map do |genre_data|
                       Genre.find_or_create_by!(name: genre_data["name"])
                     end
                   else
                     []
                   end

          ticket_info = event_data["ticket_info"] || {}
          raw_price = ticket_info["price"]&.to_s&.split("+")&.first&.strip


          event = Event.find_or_initialize_by(event_url: "https://ra.co#{event_info['contentUrl']}")
          event.assign_attributes(
            title: event_info["title"],
            date: event_info["date"],
            start_time: event_info["startTime"],
            end_time: event_info["endTime"],
            venue: venue,
            description: "No description available",
            source: "RA",
            attending_count: event_info["attending"] || 0
          )
          event.save!

          # ⛔️ Only update ticket fields if not manually managed
          unless event.manual_override
            event.update!(
              ticket_tier: ticket_info["tier"],
              ticket_price: raw_price ? raw_price.gsub("$", "").to_f : 0,
              ticket_wave: ticket_info["current_tier"]
            )
          end

          # Associate genres with the event
          event.genres = genres

          # Add Artists
          if event_info["artists"]
            event_info["artists"].each do |artist_data|
              artist = Artist.find_or_create_by!(name: artist_data["name"])
              event.artists << artist unless event.artists.include?(artist)
            end
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        puts "❌ Error importing event at index #{index}: #{e.message}"
      end
    end

    puts "✅ Finished importing events from events.json"
  end
end
