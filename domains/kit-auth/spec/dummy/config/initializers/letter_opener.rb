if Rails.env.development?
  Rails.application.config.action_mailer.delivery_method = :letter_opener
  Rails.application.config.action_mailer.perform_deliveries = true
end
