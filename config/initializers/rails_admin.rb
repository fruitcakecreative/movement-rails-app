RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Event' do
  edit do
    field :title
    field :short_title
    field :even_shorter_title
    field :start_time
    field :end_time
    field :venue
    field :genres
    field :description
    field :bg_color do
      partial 'color_picker'
    end
    field :font_color do
      partial 'color_picker'
    end
    field :free_event
    field :food_available
    field :age, :enum do
      enum do
        ['All Ages', '18+', '21+']
      end
    end

    field :indoor_outdoor, :enum do
      enum do
        ['Indoor', 'Outdoor', 'Both']
      end
    end
    field :promoter
    field :notes
    field :ticket_url
    field :ticket_price
    field :ticket_tier
    field :ticket_wave
    field :manual_override  # ✅ add this line
  end
end

  config.model 'Venue' do
    edit do
      field :name
      field :image_filename
      field :subheading
      field :hex_color do
        partial 'color_picker'
      end
      field :font_color do
        partial 'color_picker'
      end
    end
  end

  config.model 'Genre' do
    edit do
      field :name
      field :short_name
      field :hex_color do
        partial 'color_picker'
      end
      field :font_color do
        partial 'color_picker'
      end
    end
  end



end
