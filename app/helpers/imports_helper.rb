module ImportsHelper
  def import_badge_color(import)
    return 'bg-success' if import.finished?
    return 'bg-danger' if import.failed?
    return 'bg-warning' if import.processing?
    return 'bg-primary'
  end
end
