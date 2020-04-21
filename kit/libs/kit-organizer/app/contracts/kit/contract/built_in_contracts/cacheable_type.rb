=begin
module Kit::Contract::BuiltInContracts

  # NOTE: maybe use `Concurrent::ThreadLocalVar` for the caches?

  module CacheableType

    def self.cache
      @cache ||= {}
    end

    def call(*all)
      res = Cache.cache[all]
      if !res
        res = Cache.cache[all] = super
      end

      res
    end

  end

end
=end