class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array.compact
  end

  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  def friend_requests
    inverse_friendships.where(confirmed: false)
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friend| friend.user_id == user }
    friendship.confirmed = true
    friendship.save
    Friendship.create!(friend_id: user, user_id: id, confirmed: true)
  end

  def friend?(user)
    friends.include?(user)
  end

  def a_request(user)
    friendship = inverse_friendships.find_by(user_id: user, confirmed: false)
    !friendship.nil?
  end

  def available_request?(usr)
    friends_array = friendships.map { |friendship| friendship.friend if friendship.friend_id == usr }
    friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.user_id == usr }
    friends_array = friends_array.reject(&:blank?)
    !friends_array.empty?
  end

  def friends_and_own_posts
    Post.where(user: (self.friends << self))
  end
end
