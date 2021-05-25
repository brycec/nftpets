class SessionsController < ApplicationController
  def create
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/'
    else
      flash.notice='Login failed'
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

  def m
    if params[:m]!=Token.trade_data[1][:total]
      redirect_to '/'
    else
      @old_events=Event.old
      @old_anons=User.old_anon
    end
    if params[:w]
      if params[:w]=="events"
        @old_events.each do |e|e.destroy end
        redirect_to '/m/'+params[:m]
      elsif params[:w]=="anon"
        @old_anons.each do |e|e.destroy end
        redirect_to '/m/'+params[:m]
      end
    end
  end
end
