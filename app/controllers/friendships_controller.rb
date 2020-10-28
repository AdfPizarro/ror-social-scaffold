class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = User.all
    @pending_friends = current_user.pending_friends
    @friend_requests =  current_user.friend_requests
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end
