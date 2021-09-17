# Library specific wrapper for Kit::Router.
module Kit::Router::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_router])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
