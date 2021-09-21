# Log wrapper for Kit::Organizer.
module Kit::Organizer::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_organizer])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
