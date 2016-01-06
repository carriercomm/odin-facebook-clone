FactoryGirl.define do
  factory :friendship do
    association :friend, factory: :user
    user
  end

  factory :post do
    body Faker::Lorem::paragraph
    user
    # picture { File.open(Rails.root.join('spec', 'support', 'test.jpg')) }

    factory :post_like do
      after(:create) do |post, evaluator| 
        user = FactoryGirl.create(:user)
        create(:like, likeable_id: post.id, likeable_type: "Post", user_id: user.id)
      end 
    end

    factory :post_with_likes_and_comments do
        after(:create) do |post, evaluator| 
        user = FactoryGirl.create(:user)
        create(:like, likeable_id: post.id, likeable_type: "Post", user_id: user.id)
        create(:comment, post_id: post.id, user_id: user.id)
      end     
    end

    factory :post_with_picture do
      #after(:new) do |post, evaluator| 
        picture { File.open(Rails.root.join('spec', 'support', 'test.jpg')) }
      #end

    end

  end

  factory :comment do
    body Faker::Lorem::paragraph
    user
    post
  end

  factory :like do
    likeable_id :post
    likeable_type "Post"
    user
    sequence(:id){ |n|  n}

  end

  factory :user do
    name "Beast"
    sequence(:email){ |n|  "beast-#{n}@home.com"}
    password "password"
    sequence(:id){ |n|  n}
    confirmed_at Time.zone.now

    factory :user_with_comments do
      after(:create) do |user, evaluator|
        create(:comment, user: user)
      end
    end

    factory :user_with_posts do
       after(:create) do |user, evaluator|
         create(:post, user: user, :body => Faker::Lorem.paragraph)
       end
    end   

    factory :user_with_liked_commented_posts do
       after(:create) do |user, evaluator|
         create(:post_with_likes_and_comments, user: user, :body => Faker::Lorem.paragraph)
       end
    end       
    factory :user_with_posts_likes do
       after(:create) do |user, evaluator|
        post = create(:post, user: user, :body => Faker::Lorem.paragraph)
        create(:like, user: user, likeable_id: post.id, likeable_type: "Post")
       end
    end    

    factory :user_with_friends do

      transient do
        friends_count 10
      end

      after(:create) do |user, evaluator| 
        evaluator.friends_count.times do |num| 
          friendship = create(:friendship, user: user, request_status: "confirmed") 
                    
        end
      end
    end
    factory :user_with_friends_requests_requested do

      transient do
        request_count 3
      end

      after(:create) do |user, evaluator| 
        FactoryGirl.build :bio, :user => user
        create(:post, user: user, :body => Faker::Lorem.paragraph)

        evaluator.request_count.times do |num| 
          requested_friend = FactoryGirl.create(:user_with_posts)
          friend_requested = FactoryGirl.create(:user_with_posts)
          friend = FactoryGirl.create(:user_with_posts)
          requested_friendship = create(:friendship, friend: requested_friend, user: user)  
          friendship_requested = create(:friendship, friend: user, user: friend_requested)  
          friendship = create(:friendship, user: user, friend: friend, request_status: "confirmed") 
                    
        end

      end

    end

    factory :user_and_friends_posts_comments_likes do

      transient do
        request_count 3
      end

      after(:create) do |user, evaluator| 
        create(:post_with_likes_and_comments, user: user, :body => Faker::Lorem.paragraph)
        evaluator.request_count.times do |num| 
          friend = FactoryGirl.create(:user_with_liked_commented_posts)
          friendship = create(:friendship, user: user, friend: friend, request_status: "confirmed") 
                    
        end

      end

    end

  end


  factory :bio do
  	description Faker::Lorem::paragraph
  	user
  end



  trait :with_bio do
    after :create do |user|
      FactoryGirl.build :bio, :user => user
    end
  end    


  trait :with_post do
    after :create do |user|
      FactoryGirl.build :post, :user => user
    end
  end

 
end

