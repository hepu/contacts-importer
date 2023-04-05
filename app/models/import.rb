class Import < ApplicationRecord
  include AASM

  has_one_attached :file
  belongs_to :user
  has_many :contacts
  
  aasm column: :current_status do
    state :on_hold, initial: true
    state :processing
    state :failed
    state :finished
  end
end

# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  current_status :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_imports_on_current_status  (current_status)
#  index_imports_on_user_id         (user_id)
#
