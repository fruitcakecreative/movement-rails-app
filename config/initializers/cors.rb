Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000', 'https://movementparties.netlify.app', 'https://www.movementparties.com', 'https://movementparties.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options]
  end
end
