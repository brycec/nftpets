class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
   @user = User.create(params.require(:user).permit(:username,
    :password))
   session[:user_id] = @user.id
   redirect_to '/welcome'

  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end
end
