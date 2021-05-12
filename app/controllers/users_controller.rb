class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
   @user = User.create(params.require(:user).permit(:name,
    :password))
   session[:user_id] = @user.id
   redirect_to '/'

  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    @path = 'users/'+@user.id.to_s

    @tokens = Token.where(user_id: params[:id])
    @token = Token.new
  end
end
