# Allow for keys interpolations.

require 'i18n/backend/base'

class I18n::Backend::Simple # rubocop:disable Style/Documentation

  def translate(locale, key, options = EMPTY_HASH)
    raise I18n::ArgumentError if (key.is_a?(String) || key.is_a?(Symbol)) && key.empty?
    raise InvalidLocale.new(locale) unless locale
    return nil if key.nil? && !options.key?(:default)

    entry = lookup(locale, key, options[:scope], options) unless key.nil?

    if entry.nil? && options.key?(:default)
      entry = default(locale, key, options[:default], options)
    else
      entry = resolve(locale, key, entry, options)
    end

    count = options[:count]

    if entry.nil? && (subtrees? || !count)
      if (options.key?(:default) && !options[:default].nil?) || !options.key?(:default)
        throw(:exception, I18n::MissingTranslation.new(locale, key, options))
      end
    end

    entry = entry.dup if entry.is_a?(String)
    entry = pluralize(locale, entry, count) if count

    if entry.nil? && !subtrees?
      throw(:exception, I18n::MissingTranslation.new(locale, key, options))
    end

    # Note: only this line was added in this method.
    entry = i18n_keys_interpolate(locale, entry)

    deep_interpolation = options[:deep_interpolation]
    values = options.except(*I18n::RESERVED_KEYS)
    if values
      entry = if deep_interpolation
        deep_interpolate(locale, entry, values)
      else
        interpolate(locale, entry, values)
      end
    end
    entry
  end

  # Interpolate references to other i18n keys.
  #
  # TODO: prevent circular references.
  def i18n_keys_interpolate(locale, entry)
    if entry.is_a?(String)
      entry = entry.gsub(%r{\$\{([\w.]+)\}}) do |match|
        key = $1.to_sym

        if I18n.exists?(key)
          I18n.t(key)
        else
          match
        end
      end
    end

    entry
  end

end
