# Display Rails flash as toasts
class Kit::Domain::Components::FlashComponent < Kit::Domain::Components::Component

  attr_reader :router_request, :flash, :delay, :position

  def initialize(*, router_request:, flash:, position: nil, delay: nil, **)
    super

    @router_request = router_request
    @flash          = flash

    @delay          = delay || 10000
    @position       = position
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
