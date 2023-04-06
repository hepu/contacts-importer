RSpec.configure do |config|
  config.before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user] if @request
  end
end