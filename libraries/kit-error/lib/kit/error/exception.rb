# Exception related logic
module Kit::Error::Exception

  # Report an `exception` to the `reporter`
  def self.report(exception:, extra: nil, reporter: nil)
    extra    ||= {}
    reporter ||= default_exception_reporter

    if ENV['RAILS_ENV'] == 'development'
      e = exception
      puts ap exception.backtrace[0..19].reverse
      puts ap exception.message
      binding.pry # rubocop:disable Lint/Debugger
    end

    reporter.call(exception: exception)

    [:ok]
  end

  # ALlow to set a class based exception reporter.
  attr_writer :default_exception_reporter

  # Return the class based exception reporter or logs a warning.
  def self.default_exception_reporter
    @default_exception_reporter || ->(exception:) { Kit::Error::Log.log(msg: 'No exception_reporter was set! They will be lost.', flags: [:error, :danger]) }
  end

end
