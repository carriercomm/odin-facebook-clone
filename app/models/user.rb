class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and  :omniauthable
  #devise :omniauthable, omniauth_providers => [:facebook]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable, :omniauthable, :omniauth_providers => [:facebook]
  has_many :posts, dependent: :destroy, inverse_of: :user
  has_many :likes, dependent: :destroy, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :post_likes, -> { where :likeable_type => 'Post' }, class_name: 'Like'
  has_many :comment_likes, -> { where :likeable_type => 'Comment' }, class_name: 'Like'

  has_many :friend_requests, -> {where :request_status => 'pending'}, foreign_key: :friend_id, class_name: 'Friendship'
  has_many :friend_request_users, through: :friend_requests, source: :user

  has_many :requested_friends, -> {where :request_status => 'pending'}, foreign_key: :user_id, class_name: 'Friendship'
  has_many :requested_friend_users, through: :requested_friends, source: :friend

  has_many :requested_friendships, -> {where :request_status => 'confirmed'}, class_name: 'Friendship'
  has_many :confirmed_friendships, -> {where :request_status => 'confirmed'}, class_name: 'Friendship', foreign_key: :friend_id
  
  has_one :bio, dependent: :destroy
  accepts_nested_attributes_for :bio
  validates :name, presence: true
  has_attached_file :profile_picture, 
                      styles: {:medium => "300x300>", :thumb => "100x100>"},
                      :default_url => 'http://facebook-clone-sample-app.s3.amazonaws.com/users/profile_pictures/000/000/001/:style/missing.gif'
  validates_attachment :profile_picture, content_type:  { content_type: /\Aimage\/.*\Z/ },
                                           size: { in: 0..1.megabytes }


  

  def friends
    user_ids = self.requested_friendships.collect {|f| f.friend_id}
    user_ids.concat self.confirmed_friendships.collect {|f| f.user_id}
    User.where(id: user_ids)
  end

  def find_friendship(friend_id)
    friendship = Friendship.where("(user_id = ? AND friend_id = ?) OR (friend_id = ? AND user_id = ?)", self.id, friend_id, self.id, friend_id).take

  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      puts auth
      user.provider = auth.provider
      user.uid = auth.uid

      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.skip_confirmation!
  #   user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
