# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def random_id(model)
	offset = rand(1..model.count)
	model.find(offset).id	
end

# Users
mao = User.new(name: "Mao", email: "mao@home.com", password: "password")
mao.skip_confirmation!
mao.save!

50.times do |n|
	name = Faker::Name.name
	email = Faker::Internet.email
	password = "password"
	user = User.new(name: name, email: email, password: password)
	user.skip_confirmation!
	user.save!
end

# Bios

User.all.each do |user| 
	user.create_bio(description: Faker::Lorem::paragraph)
end

# Posts and post likes

100.times do |n| 
	user_id = random_id(User)
	body = Faker::Lorem.paragraph
	post = Post.create!(user_id: user_id, body: body)
	# random like
	rand(0..2).times do |n|
		liker_id = random_id(User)
		existing_likers = post.likes.collect { |like| like.user_id }
		post.likes.create!(user_id: liker_id) unless existing_likers.include?(liker_id)
	end
end

# Comments and comment likes

100.times do |n|
	user_id = random_id(User)
	body = Faker::Lorem.paragraph
	post = Post.find(random_id(Post))
	comment = post.comments.create!(user_id: user_id, body: body)
	rand(0..2).times do |n|
	 	liker_id = random_id(User)
	 	existing_likers = comment.likes.collect { |like| like.user_id }
		like = comment.likes.build(user_id: liker_id) 
		if like.valid?
			like.save!
		end
	end
end

#Friend Requests
User.all.each do |user| 
	5.times do |n|
		requested = random_id(User)
		request = user.requested_friends.build(friend_id: requested)
		if request.valid?
			request.save! 
		end
	end
end

# Friendships

User.all.each do |user| 
	requests = user.friend_requests
	requests.each do |request|
		num = rand(0..2)
		if num > 1
			request.confirm
		end
	end
end




