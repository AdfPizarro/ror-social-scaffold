class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships
  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

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

  def friends_ids
    f_ids = friends.map(&:id)
    f_ids << id
  end

  def friends_and_own_posts
    Post.where(user_id: friends_ids)
  end
end
