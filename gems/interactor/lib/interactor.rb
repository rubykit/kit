require "ostruct"
require "interactor/railtie"

module Interactor
  extend ActiveSupport::Concern

  def self.debug_interactors
    if !instance_variable_defined?(:@debug_interactors)
      env_value = ENV['DEBUG_INTERACTORS']
      res       = false

      if !env_value.blank?
        res = env_value.to_bool
      end

      @debug_interactors = res
    end

    @debug_interactors
  end

  # Failure Exception ----------------------------------------------------------

  class Failure < StandardError
    attr_reader :context

    def initialize(context = nil)
      @context = context
      super
    end
  end

  # Success Exception ----------------------------------------------------------

  class Success < StandardError
    attr_reader :context

    def initialize(context = nil)
      @context = context
      super
    end
  end


  # Context --------------------------------------------------------------------

  class Context < OpenStruct

    attr_reader :failure

    def self.build(context = {})
      self === context ? context : new(context)
    end

    def success?
      !failure?
    end

    def failure?
      @failure || false
    end

=begin
    # This should be achieved through Error.raise!
    def fail!(context = {})
      context.each { |key, value| modifiable[key.to_sym] = value }
      self.failure = true
      raise Failure, self
    end
=end

    def set_failure(value)
=begin
      begin
        raise 'debug'
      rescue Exception => e
        binding.pry
      end
=end
      @failure = value
    end

    def succeed!(context = {})
      context.each { |key, value| modifiable[key.to_sym] = value }
      set_failure(false)
      raise Success, self
    end

    def called!(interactor)
      _called << interactor
    end

    def rollback!
      return false if @rolled_back
      _called.reverse_each(&:rollback)
      @rolled_back = true
    end

    def _called
      @called ||= []
    end

    def cleanup(key)
      if self.respond_to?(key)
        self.delete_field(key)
      end
    end

  end


  # Class logic ----------------------------------------------------------------

  class_methods do
    def call(context = {})
      new(context).tap(&:run).context
    end

    def call!(context = {})
      new(context).tap(&:run!).context
    end

    def around(*hooks, &block)
      hooks << block if block
      hooks.each { |hook| around_hooks.push(hook) }
    end

    def before(*hooks, &block)
      hooks << block if block
      hooks.each { |hook| before_hooks.push(hook) }
    end

    def after(*hooks, &block)
      hooks << block if block
      hooks.each { |hook| after_hooks.unshift(hook) }
    end

    def around_hooks
      @around_hooks ||= []
    end

    def before_hooks
      @before_hooks ||= []
    end

    def after_hooks
      @after_hooks ||= []
    end

    def inherited(subclass)
      [:around_hooks, :before_hooks, :after_hooks].each do |hook|
        subclass.instance_variable_set("@#{hook}", send(hook))
      end
    end
  end


  # Instance logic -------------------------------------------------------------

  included do |base|
    attr_reader :context

    def ctx
      context
    end

    def initialize(context = {})
      @context = Context.build(context)
    end

    def run
      run!
    rescue
    end

    def run!
      if Interactor.debug_interactors
        puts "#{self.class.name}".colorize(:blue)
      end

      context.called!(self)
      with_hooks do
        call
      end
    rescue Success
    rescue => e
      context.exception = e

      if e.respond_to? :error
        error         = e.error
        context.error = error
        error.context = context
      end

      if Interactor.debug_interactors
        msg = "#{self.class.name} - "
        if e.respond_to?(:error)
          msg += e.error.message
        else
          msg += e.to_s
        end
        puts msg.colorize(:red)
        e.backtrace.each do |line|
          puts "    #{line.to_s.colorize(:light_red)}"
        end
      end

      context.set_failure(true)
      context.rollback!

      raise e
    end

    def organize(*interactors)
      interactors.flatten.each do |interactor|
        context.current_organizer = self.class
        if interactor.is_a?(Proc)
          interactor.call context
        else
          interactor.call! context
        end
      end
    end

    def safe_organize(*interactors, &block)
      interactors.flatten.each do |interactor|
        begin
          if interactor.is_a?(Proc)
            interactor.call context
          else
            interactor.call! context
          end
        rescue Exception => e
          if block
            block.call(e, context)
          end
          NewRelic::Agent.notice_error e
        end
      end
    end

    if !self.respond_to?(:call)
      def call
      end
    end

    if !self.respond_to?(:rollback)
      def rollback
      end
    end

    def missing_param!(name)
      Error.raise!(
        message: "Missing interactor parameter `#{name}`",
      )
    end

    def ensure_params!(*names)
      names.each { |name| missing_param! name if context[name] == nil }
    end

    def done!
      @done = true
    end


    private

    def with_hooks
      run_around_hooks do
        self.class.before_hooks.each { |hook| run_hook(hook) }

        if !@done
          yield
        end

        self.class.after_hooks.each { |hook| run_hook(hook) }
      end
    end

    def run_around_hooks(&block)
      self.class.around_hooks.reverse.inject(block) do |chain, hook|
        proc { run_hook(hook, chain) }
      end.call
    end

    def run_hook(hook, *args)
      hook.is_a?(Symbol) ? send(hook, *args) : instance_exec(*args, &hook)
    end
  end

end