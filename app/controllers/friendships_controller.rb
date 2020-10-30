class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = User.all
    @pending_friends = current_user.pending_friends
    @friend_requests =  current_user.friend_requests
  end
   
  def create
    request=Friendship.new
    request.user_id=current_user.id
    request.friend_id=(params[:user_id])
    p "-------------- Request data -----------"
    p request
    request.save
  end  

  def destroy
  p "------------ Cancel friendship"
  request=a=Friendship.find_by(user_id:current_user.id,friend_id:params[:id])
  request.destroy
  redirect_to(friendships_path, alert: 'Frienship request deleted')
  end

  def update
   friend=User.find(params[:id])
   current_user.confirm_friend(friend)
  end 

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end
