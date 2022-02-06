module Kit # rubocop:disable Style/Documentation
end

module Kit::Log # rubocop:disable Style/Documentation

  # TODO: add ways to enable / disable based on Env / external conf?
  def self.log(msg:, flags: [])
    return if ENV['KIT_LOG'] == 'false'
    return if ENV['KIT_LOG'] != 'true' && !((ENV['KIT_LOG_ONLY'] || '').size > 0) && !((ENV['KIT_LOG_EXCEPT'] || '').size > 0)

    flags = extend_flags(flags: flags)
    flags_values = flags
      .values
      .reduce([]) { |res, el| el.is_a?(Array) ? res.concat(el) : res.push(el) }

    list_only   = (ENV['KIT_LOG_ONLY']   || '').split(',').map(&:to_sym)
    list_except = (ENV['KIT_LOG_EXCEPT'] || '').split(',').map(&:to_sym)

    display = true

    if list_only.size > 0 && list_only.intersection(flags_values).size == 0
      display = false
    end

    if list_except.size > 0 && list_except.intersection(flags_values).size > 0
      display = false
    end

    if display
      msg = msg.call if msg.respond_to?(:call)
      Kit::Log::Backends::Shell.log(msg: msg, flags: flags)
    end
  end

  def self.extend_flags(flags:)
    flags = flags
      .map do |el|
        if el.is_a?(Array)
          [el[0], [el[1]].flatten]
        elsif [:debug, :info, :warning, :danger].include?(el)
          [:level, [el].flatten]
        else
          [:various, [el].flatten]
        end
      end
      .group_by { |type, _vals| type }

    flags.each do |key, val|
      if [:level, :gem].include?(key)
        flags[key] = val[0][1][0]
      elsif val.is_a?(::Array)
        flags[key] = val.map { |v2| v2[1][0] }
      end
    end

    flags
  end

end

require_relative 'log/backends'
require_relative 'log/backends/shell'
