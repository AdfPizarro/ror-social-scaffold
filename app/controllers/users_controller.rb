class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @nRequesT=Friendship.new
  end

  def show
    @user = User.find(params[:id])
    if current_user.id==params[:id].to_i
    @amI=true
    else
    @amI=false
    end    
    

    @posts = @user.posts.ordered_by_most_recent
  end
end
