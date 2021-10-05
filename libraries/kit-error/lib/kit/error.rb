module Kit # rubocop:disable Style/Documentation

  # Shortcut to generate proper return values without the boilerplate.
  #
  # Note that this a method that shadows the namespace.
  #
  # Examples
  # ```ruby
  # irb> Kit::Error("Error message")
  # [:error, errors: ["Error message"]]
  # ```
  def self.Error(msg) # rubocop:disable Naming/MethodName
    [:error, ErrorCtx(msg)]
  end

  # Shortcut to generate proper ctx return values without the boilerplate.
  #
  # Examples
  # ```ruby
  # irb> Kit::ErrorCtx("Error message")
  # { errors: ["Error message"] }
  # irb> Kit::ErrorCtx(["Error message 1", "Error message 2"])
  # { errors: ["Error message 1", "Error message 2"] }
  # ```
  def self.ErrorCtx(msg) # rubocop:disable Naming/MethodName
    if !msg.is_a?(Array)
      msg = [msg]
    end

    msg = msg.map { |el| el.is_a?(String) ? { detail: el } : el }

    { errors: msg.flatten }
  end

end

# Namespace for Kit our error behaviour.
module Kit::Error

  def self.report(detail:, extra: nil)
    extra ||= {}

    raise detail
  rescue StandardError => e
    report_exception(exception: e, extra: extra)
  end

  def self.report_exception(exception:, extra: nil)
    Kit::Error::Exception.report(exception: exception, extra: extra)
  end

  def self.report_organizer_errors(errors:)
    (errors || []).each do |error|
      report(detail: error[:detail], extra: error.except(:detail))
    end

    [:ok]
  end

end

require_relative 'error/version'
require_relative 'error/log'

require_relative 'error/exception'
require_relative 'error/format'
