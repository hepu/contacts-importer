puts 'Running seeds...'
ActiveRecord::Base.transaction do
  # Superadmin user
  user = User.find_or_initialize_by(email: 'admin@test.com')
  if !user.persisted?
    user.password = '123456'
    user.password_confirmation = '123456'
    user.save!
  end
rescue StandardError => e
  puts "There was an error: #{e.message}"
end
puts 'Done!'