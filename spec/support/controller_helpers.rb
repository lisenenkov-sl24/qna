module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def upload_file(filename)
    Rack::Test::UploadedFile.new(Rails.root.join(filename))
  end
end