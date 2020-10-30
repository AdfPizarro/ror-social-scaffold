class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @friend_requests = current_user.friend_requests
  end

  def create
    request = Friendship.new
    request.user_id = current_user.id
    request.friend_id = params[:user_id]
    request.confirmed = false
    request.save
  end

  def destroy
    request = Friendship.find(params[:id])
    request.destroy
    redirect_to(friendships_path, alert: 'Frienship request deleted')
  end

  def update
    request = Friendship.find(params[:id])
    request.confirmed = true
    request.save
    redirect_to(friendships_path, alert: 'Friendship confirmed')
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end
