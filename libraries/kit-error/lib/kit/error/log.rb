# Log wrapper for `Kit::Error`.
module Kit::Error::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_error])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
