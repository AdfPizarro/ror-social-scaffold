class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @request = request_available(params[:id].to_i)
    @posts = @user.posts.ordered_by_most_recent
  end

  def request_available(user)
    uid = current_user.id.to_i
    url = user
    sent_request = Friendship.exists?(user_id: uid, friend_id: url)
    receive_request = Friendship.exists?(friend_id: uid, user_id: url)

    if (uid == url) || sent_request || receive_request
      false
    else
      true
    end
  end
end
