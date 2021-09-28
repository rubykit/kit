# Exception related logic
module Kit::Errors::Exception

  # Report an `exception` to the `reporter`
  def self.report(exception:, reporter: nil)
    reporter ||= default_exception_reporter

    reporter.call(exception: exception)

    [:ok]
  end

  # ALlow to set a class based exception reporter.
  attr_writer :default_exception_reporter

  # Return the class based exception reporter or logs a warning.
  def self.default_exception_reporter
    @default_exception_reporter || ->(exception:) { Kit::Error::Log.log(msg: 'No exception_reporter was set! They will be lost.', flags: [:danger]) }
  end

end
