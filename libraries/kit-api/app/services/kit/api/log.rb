# Library specific wrapper for Kit::Api.
module Kit::Api::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_api])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
