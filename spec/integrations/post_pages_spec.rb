require 'rails_helper'

describe 'Post pages' do
	before :each do
		@user = FactoryGirl.create(:user_with_friends_requests_requested)
		login_as_user @user
	end

	context 'edit' do
		it 'shows fields correctly filled in' do
			post = @user.posts[0]
			visit edit_user_post_path @user, post
			expect(page).to have_selector("textarea", text: post.body)
		end		

		it 'shows upload option' do
			post = @user.posts[0]
			visit edit_user_post_path @user, post
			expect(page).to have_selector("input[type=file]")
		end		

	end

	context 'show' do


		context 'logged in and friends' do



			context 'users own post' do	
				it 'shows name and body' do
					visit user_post_path @user, @user.posts[0]
					expect(page).to have_content(@user.name)
					expect(page).to have_selector('.post-body')
				end
				it 'shows delete and edit link' do
					visit user_post_path @user, @user.posts[0]
					expect(page).to have_link("Delete Post", user_post_path(@user, @user.posts[0]))
				end
				

				it 'shows edit link' do
					post = @user.posts[0]
					visit user_post_path @user, post 
					expect(page).to have_link("Edit Post", edit_post_path(post))
				end

				it "shows picture if it exists" do
					post = FactoryGirl.create(:post_with_picture)
					visit user_post_path @user, post 
					expect(page).to have_css("img[@src*='#{post.picture_file_name}']")
				end

				context 'post\'s likes' do
					it 'shows like link if unliked' do
						visit user_post_path @user, @user.posts[0]
						expect(page).to have_link("Like", likes_path)
					end
					it 'shows unlike link if unliked' do
						post = @user.posts[0]
						like = FactoryGirl.create(:like, user_id: @user.id, likeable_id: post.id, likeable_type: post.class.to_s)					
						visit user_post_path @user, post
						expect(page).to have_link("Unlike", like_path(like))
					end


					it 'shows like count' do
						friend = FactoryGirl.create(:user_with_posts_likes)
						FactoryGirl.create(:friendship, user_id: @user.id, friend_id: friend.id, request_status: "confirmed")
						visit user_post_path friend, friend.posts[0]
						expect(page).to have_content("#{friend.posts[0].likes.count} Like")
					end
				end

				#list of likers in hover

				context "post's comments" do
					before :each do
						@post = @user.posts[0]
						@comment = FactoryGirl.create(:comment, post: @post, user: @user)						
						5.times {|n| FactoryGirl.create(:like, likeable_id: @comment.id, likeable_type: @comment.class.to_s)}
						visit user_post_path @user, @post 
					end
					it "displays the post's comments" do
						expect(page).to have_content(@comment.body)
					end
					it "displays the edit link for owned comments" do
						second_comment = FactoryGirl.create(:comment, post: @post)
						expect(page).to have_link("Edit Comment", edit_comment_path(@comment))
					end
					
					it "displays the delete link for owned comments" do
						second_comment = FactoryGirl.create(:comment, post: @post)
						expect(page).to have_link("Delete Comment", comment_path(@comment))
					end

					it "display new comment box" do						
						expect(page).to have_selector("textarea")
						expect(page).to have_selector("input[type=submit][value='Post Comment']")
					end

					it 'shows like count for comment' do
						expect(page).to have_content("#{@comment.likes.count} Likes")
					end					
	
					it 'shows like link if unliked' do
						visit user_post_path @user, @post
						expect(page).to have_link("Like", likes_path)
					end

				end

			end

			context "friend's post" do
				before :each do
					@friend = @user.friends[0]
					@friends_post = @friend.posts[0]
					visit user_post_path @friend, @friends_post					
				end

				it 'does not show delete link' do
					expect(page).to_not have_selector("input[type=submit][value='Delete Post']")
				end

				it 'does not show edit link' do
					expect(page).to_not have_link("Edit", edit_post_path(@friends_post))

				end

			end


		end
	end	
end
