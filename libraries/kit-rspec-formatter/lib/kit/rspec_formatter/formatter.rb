require 'rspec'

RSpec::Support.require_rspec_core 'formatters/base_text_formatter'

# RSpec formatter that display spec name as they are running + spent time
#
# ### Ressources
# - https://ieftimov.com/post/how-to-write-rspec-formatters-from-scratch/
class Kit::RspecFormatter::Formatter < RSpec::Core::Formatters::BaseTextFormatter

  RSpec::Core::Formatters.register self,
    :example_started,
    :example_passed,
    :example_failed,
    :example_pending,
    :dump_summary,
    :seed

  def wrap(text, code)
    codes = {
      black:   30,
      red:     31,
      green:   32,
      yellow:  33,
      blue:    34,
      magenta: 35,
      cyan:    36,
      white:   97,
      grey:    37,
      bold:    1,
      italic:  3,
    }

    code = codes[code] || (code.is_a?(Integer) ? code : codes[:white])
    "\e[#{ code }m#{ text }\e[0m"
  end

  def example_started(notification)
    ex = notification.example

    output.print "\r⏳  #{ wrap(ex.location, :bold) }  #{ wrap(ex.description, :italic) }  #{ wrap('...', :bold) }"
  end

  def example_done(notification)
    ex       = notification.example
    exr      = ex.execution_result
    statuses = {
      passed:  '✅',
      failed:  '⛔',
      pending: '❔',
    }

    location = wrap(ex.location, :bold)
    if exr.status == :failed
      location = wrap(wrap(ex.location, :bold), :red)
    end

    output.print "\r#{ statuses[exr.status] }  #{ location }  #{ wrap(ex.description, :italic) }  #{ wrap("#{ exr.run_time }s", :bold) }\n"
  end

  alias_method :example_passed,  :example_done
  alias_method :example_failed,  :example_done
  alias_method :example_pending, :example_done

  def dump_summary(notification)
    @output << "\n"
    @output << "⏱️  Total time: #{ wrap("#{ notification.duration }s", :bold) }"
  end

  def seed(notification)
    @output << "\n"
    @output << "🌱 Seed used: #{ wrap(notification.seed, :bold) }"
  end

end
