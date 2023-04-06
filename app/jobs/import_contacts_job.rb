class ImportContactsJob < ApplicationJob
  queue_as :imports
  
  rescue_from(StandardError) do
    retry_job wait: 3.minutes, queue: :default
  end

  def perform(import_id, user_id)
    @user = User.find_by!(id: user_id)
    @import = @user.imports.find_by!(id: import_id)
    ImportContactsService.new(@import).call
  end
end
