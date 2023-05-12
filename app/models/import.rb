class Import < ApplicationRecord
  include AASM
  
  UPLOADABLE_ATTRIBUTES = %w[address birthdate credit_card_number email name phone].freeze

  has_one_attached :file
  belongs_to :user
  has_many :contacts
  has_many :column_pairings, dependent: :destroy
  accepts_nested_attributes_for :column_pairings, allow_destroy: true

  after_create :initialize_column_pairings
  
  paginates_per 50
  
  aasm column: :current_status do
    state :on_hold, initial: true
    state :processing
    state :failed
    state :finished

    event :restart, after_commit: :notify_status_change do
      transitions to: :on_hold
    end
    
    event :start_process, after_commit: :notify_status_change do
      transitions to: :processing
    end
    
    event :fail, after_commit: :notify_status_change do
      transitions from: :processing, to: :failed
    end
    
    event :finish, after_commit: :notify_status_change do
      transitions from: :processing, to: :finished
    end
  end

  def notify_status_change
    broadcast_update_later_to self, target: "import_#{id}_status", partial: 'imports/status'
  end

  def notify_logs_change
    broadcast_update_later_to self, target: "import_#{id}_logs", partial: 'imports/logs'
  end

  def clear_logs
    self.log['logs'] = []
  end

  private

  def initialize_column_pairings
    return if self.column_pairings.any?

    self.column_pairings = UPLOADABLE_ATTRIBUTES.map { |attr| self.column_pairings.find_or_create_by(local_column: attr) }
  end
end

# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  current_status :string
#  log            :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_imports_on_current_status  (current_status)
#  index_imports_on_user_id         (user_id)
#
