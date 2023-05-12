# == Schema Information
#
# Table name: column_pairings
#
#  id           :bigint           not null, primary key
#  csv_column   :string
#  local_column :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  import_id    :integer
#
# Indexes
#
#  index_column_pairings_on_import_id     (import_id)
#  index_column_pairings_on_local_column  (local_column)
#
FactoryBot.define do
  factory :column_pairing do
    attribute { "MyString" }
    csv_column { "MyString" }
    import_id { 1 }
  end
end
