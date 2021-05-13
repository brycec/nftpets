class TokensController < ApplicationController
  def create
    if logged_in?
      @token = Token.create(user_id:current_user.id)
    end
    redirect_to '/users/'+current_user.id.to_s
  end

  def show
    @token = Token.find(params[:id])
  end

  def update
    @token = Token.find(params[:id])
    if @token.user_id = 1
      @message=Message.where(token_id: @token.id).first
      @message.token_id=nil
      @token.user_id = current_user.id

      @message.save
      @token.save

      flash.notice='Claimed a token!'
      redirect_to '/users/'+current_user_id.to_s
    end
  end

  def index
  end
end
