class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :space_time
  def current_user_id
    session[:user_id]
  end
  def current_user
    @current_user ||= User.find_by(id: current_user_id)
    if @current_user and @current_user.took_damage?
      flash.alert = "🛑 SHTAHP! ✋ Your terminal overheated and took damage! 🔥📺🔥 That's cringe, you're going to loose tokens if you don't slow down."
      @current_user.cooldown?
      @current_user.save
      redirect_to '/users/'+@current_user.id.to_s
    end
    @current_user
  end
  def logged_in?
    !current_user.nil?
  end

  def space_time(t)
    (t + 365.2421875*1200).to_s :db
  end
end
