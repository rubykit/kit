# TODO: move this to Kit::Log
# TODO: add ways to enable / disable based on Env / external conf?
module Kit::Log

  def self.log(msg:, flags: [])
    flags = extend_flags(flags: flags)

    Kit::Log::Shell.log(msg: msg, flags: flags)
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

  module Shell

    def self.log(msg:, flags:)
      output = []

      level = flags[:level] || :default
      color = shell_level_to_color(level: level)
      if flags[:gem]
        output << shell_sequence(msg: flags[:gem], mode: :bold, color: color)
      end

      output << shell_sequence(msg: msg, color: [:warning, :danger].include?(level) ? color : :default)

      if flags[:various]
        output << shell_sequence(msg: flags[:various].to_s, mode: :italic)
      end

      puts output.join(' ')
    end

    def self.shell_sequence(msg:, mode: nil, color: nil)
      mode  ||= :default
      color ||= :default

      if mode.is_a?(::Symbol)
        mode = shell_mode_codes(mode: mode)
      end
      if color.is_a?(::Symbol)
        color = shell_color_codes(color: color)
      end

      "\e[#{ mode };#{ color }m#{ msg }\e[0m"
    end

    def self.shell_level_to_color(level: :default)
      list = {
        debug:   :magenta,
        default: :default,
        warning: :yellow,
        info:    :blue,
        danger:  :red,
      }

      shell_color_codes(color: list[level] || list[:default])
    end

    def self.shell_color_codes(color: :default)
      list = {
        black:   30, light_black:   90,
        red:     31, light_red:     91,
        green:   32, light_green:   92,
        yellow:  33, light_yellow:  93,
        blue:    34, light_blue:    94,
        magenta: 35, light_magenta: 95,
        cyan:    36, light_cyan:    96,
        white:   37, light_white:   97,
        default: 39,
      }

      list[color] || list[:default]
    end

    def self.shell_mode_codes(mode: :default)
      list = {
        default:   0, # Turn off all attributes
        bold:      1, # Set bold mode
        italic:    3, # Set italic mode
        underline: 4, # Set underline mode
        blink:     5, # Set blink mode
        swap:      7, # Exchange foreground and background colors
        hide:      8, # Hide text (foreground color would be the same as background)
      }

      list[mode] || list[:default]
    end

  end

end

# Library specific wrapper for Kit::Auth.
module Kit::Auth::Log

  def self.log(msg:, flags: [])
    flags.unshift([:gem, :kit_auth])
    Kit::Log.log(msg: msg, flags: flags)
  end

end
