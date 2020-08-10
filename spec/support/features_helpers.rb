module FeatureHelpers

  def sign_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
  end

  def upload_file(filename)
    Rack::Test::UploadedFile.new(Rails.root.join(filename))
  end

  def setup_mock_oauth
    OmniAuth.config.add_mock :github, {
      'provider' => 'github',
      'uid' => '123',
      'info' => {
        'email' => 'mock@github.com'
      }
    }
    OmniAuth.config.add_mock :facebook, {
      'provider' => 'facebook',
      'uid' => '123',
      'info' => {
        'email' => 'mock@facebook.com'
      }
    }
  end
end
