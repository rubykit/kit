# Library specific wrapper for Kit::Auth.
module Kit::Auth::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_auth])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
