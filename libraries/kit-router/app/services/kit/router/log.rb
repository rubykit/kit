# Library specific wrapper for Kit::Auth.
module Kit::Router::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_router])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
