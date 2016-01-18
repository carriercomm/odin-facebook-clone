require 'rails_helper'

def valid_facebook_login_setup
  if Rails.env.test?
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      info: {
        name: "Mao",
        email: "mao@home.com"
      },
      credentials: {
        token: "123456",
        expires_at: Time.now + 1.week
      },
      extra: {
        raw_info: {
          gender: 'male'
        }
      }
    })
  end
end

describe "signing in with facebook" do
  it "can sign in user with Facebook account" do
    visit '/'
    expect(page).to have_content("Sign in with Facebook")
    valid_facebook_login_setup
    click_link "Sign in"
    expect(page).to have_content("Friends")
    expect(page).to have_content("Logout")
  end

end