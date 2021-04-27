class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/'
    else
      # TODO bad login
      redirect_to '/login'
    end

  end

  # "Delete" a login, aka "log the user out"
  def destroy
    # Remove the user id from the session
    session.delete(:user_id)
    # Clear the memoized current user
    @_current_user = nil
    redirect_to '/'
  end
end
