class Api::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    events = Event.includes(:genres, :venue, :artists)
                  .order(start_time: :asc, end_time: :asc) # 🔥 Order by start_time first, then end_time

    render json: events.as_json(
      only: [:id, :title, :short_title, :even_shorter_title, :description, :bg_color, :font_color, :ticket_url, :event_url, :ticket_price, :ticket_tier, :ticket_wave],
      methods: [:formatted_start_time, :formatted_end_time, :top_artists],
      include: { venue: { only: [:id, :name, :image_filename, :hex_color, :font_color, :subheading] },
      genres: { only: [:id, :name, :hex_color, :font_color, :short_name] }
      }
    )
  end


  def top_artists
    artists.sort_by { |a| -(a.ra_followers || 0) }.first(10).map do |artist|
      {
        id: artist.id,
        name: artist.name,
        ra_followers: artist.ra_followers
      }
    end
  end


  def formatted_start_time
    start_time&.iso8601
  end

  def formatted_end_time
    end_time&.iso8601
  end

  def show
    render json: @event.to_json(include: [:venue, :artists, :genres])
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :date, :start_time, :end_time, :venue_id, :description, :event_url, :source, genre_ids: [])
  end
end
