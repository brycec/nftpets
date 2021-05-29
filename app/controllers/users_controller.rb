class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
   @user = User.create(params.require(:user).permit(:name,
    :password))
   if @user.valid?
     session[:user_id] = @user.id

     Message.new_welcome @user

     flash.notice = "Created new user: " + @user.name
     redirect_to '/messages'
   else
     flash.notice = "Failed to create user. " +
      @user.errors.full_messages.join(". ")
     redirect_to '/users/new'
   end
  end

  def index
    @users = User.all.sort {|a,b|b.networth<=>a.networth}
  end

  def show
    @user = User.find_by(id: params[:id])
    @tokens = @user.tokens
    @token = Token.find_by(id: params[:token_id])
    if !@token.present? and @tokens.present?
      @token = @tokens.first
    end
  end

  def dead
  end
end
