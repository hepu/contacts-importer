module ImportsHelper
  def import_badge_color(import)
    return 'bg-success' if import.finished?
    return 'bg-danger' if import.failed?
    return 'bg-warning' if import.processing?
    return 'bg-primary'
  end
  
  def import_badge(import)
    content_tag(:span, class: "badge #{import_badge_color(import)}") do
      t("statuses.#{import.current_status}")
    end
  end
end
