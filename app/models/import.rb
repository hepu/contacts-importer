class Import < ApplicationRecord
  include AASM
  
  UPLOADABLE_ATTRIBUTES = %w[address birthdate credit_card_number email name phone].freeze

  has_one_attached :file
  belongs_to :user
  has_many :contacts

  before_create :initialize_columns_pair
  
  paginates_per 50
  
  aasm column: :current_status do
    state :on_hold, initial: true
    state :processing
    state :failed
    state :finished

    event :restart do
      transitions to: :on_hold
    end
    
    event :start_process do
      transitions to: :processing
    end
    
    event :fail do
      transitions from: :processing, to: :failed
    end
    
    event :finish do
      transitions from: :processing, to: :finished
    end
  end

  private

  def initialize_columns_pair
    self.columns_pair = UPLOADABLE_ATTRIBUTES.map { |attr| [attr, nil] }.to_h
  end
end

# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  columns_pair   :jsonb
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
