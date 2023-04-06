# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  columns_pair   :jsonb
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
require "test_helper"

class ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end