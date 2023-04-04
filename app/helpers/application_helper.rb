module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-dismissible fade show alert-info"
      when :success then "alert alert-dismissible fade show alert-success"
      when :error then "alert alert-dismissible fade show alert-danger"
      when :alert then "alert alert-dismissible fade show alert-danger"
    end
  end
  
  def active_text(link_controller, link_action = nil)
    same_controller = params[:controller] == link_controller.to_s

    if link_action.present?
      same_action = params[:action] == link_action.to_s
      same_controller && same_action ? 'text-danger' : ''
    else
      same_controller ? 'text-danger' : ''
    end
  end
end
