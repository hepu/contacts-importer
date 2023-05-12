# frozen_string_literal: true

class StatusBadgeComponent < ViewComponent::Base
  def initialize(color:)
    @color = color || 'bg-primary'
  end
end
