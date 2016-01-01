require 'rails_helper'

describe User do
  include Paperclip::Shoulda::Matchers
  let (:user) {described_class.new}
  it "validates name" do
  	expect(user).to validate_presence_of :name 
  end

  it { expect(user).to_not validate_attachment_presence :profile_picture }
  it { expect(user).to validate_attachment_content_type(:profile_picture).allowing(
      'image/png', 'image/jpg', 'image/jpeg', 'image/gif'
    ).rejecting(
      'text/plain', 'text/html'
    )
  }
  it { expect(user).to validate_attachment_size(:profile_picture).less_than(1.megabytes) }
end
 