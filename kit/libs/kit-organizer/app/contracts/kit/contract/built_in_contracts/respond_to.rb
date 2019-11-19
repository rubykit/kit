module Kit::Contract::BuiltInContracts

  class RespondTo < InstanciableType
    def initialize(method_name)
      @method_name = method_name
    end

    def call(args)
      if args.respond_to?(@method_name)
        [:ok]
      else
        [:error, "RESPOND_TO failed: object does not respond_to `#{@method_name}`"]
      end
    end
  end

end