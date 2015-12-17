def login_as_user(user = nil)
	user = user.nil? ? FactoryGirl.create(:user, :with_bio) : user
	user.confirmed_at = Time.zone.now
	user.created_at = Time.zone.now
	user.save
	login_as(user, :scope => :user)	
	user
end

def try_as_user(user)
		if user.nil?
	        allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
	        allow(controller).to receive(:current_user).and_return(nil)
		else
	        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
	        allow(controller).to receive(:current_user).and_return(user)
		end
		
end

module ControllerHelpers 
	def sign_in(user)
		if user.nil?
	        allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
	        allow(controller).to receive(:current_user).and_return(nil)
		else
	        allow(request.env['warden']).to receive(:authenticate!).and_return(user)
	        allow(controller).to receive(:current_user).and_return(user)
		end
		
	end

end

