class TokensController < ApplicationController
  def create
    if logged_in?
      @token = Token.create(user_id:current_user.id, vibes:0)
    end
  end

  def show
  end

  def update
  end

  def index
  end
end
