require 'rails_helper'

 
describe UsersController do

	context "not logged in" do
		before :each do 
			@user = FactoryGirl.create(:user)
			sign_in nil
			get :show, id: @user

		end

		it "requires login for show page" do
 		    expect(response).to redirect_to(new_user_session_path)
		end
	end

	context "logged in" do
		before :each do
			@user = FactoryGirl.create(:user)
			sign_in @user
			get :show, id: @user.id
		end

		it "renders the show template for the user" do
			get :show, id: @user
			expect(response).to render_template :show

		end

	end
end

