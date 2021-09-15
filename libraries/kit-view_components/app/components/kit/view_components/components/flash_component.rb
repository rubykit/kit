# Display Rails flash as toasts
class Kit::ViewComponents::Components::FlashComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :router_conn, :flash, :delay, :position

  def initialize(*, router_conn:, flash:, position: nil, delay: nil, **)
    super

    @router_conn = router_conn
    @flash       = flash

    @delay       = delay || 10000
    @position    = position
  end

  def flash_class(type)
    case type.to_sym
      when :notice  then 'bg-info'
      when :success then 'bg-success'
      when :error   then 'bg-danger'
      when :alert   then 'bg-warning'
      else               'bg-secondary'
    end
  end

end
