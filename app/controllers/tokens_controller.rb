class TokensController < ApplicationController
  def create
    if logged_in?
      @token = Token.create(user_id:current_user.id)
    end
    flash.notice='Minted a token!'
    redirect_to '/tokens/'+@token.id.to_s
  end

  def show
    @token = Token.find(params[:id])
    if @token.furbaby_id
      @furbaby = Furbaby.find(@token.furbaby_id)
      if @furbaby.egg?
        @egg=@furbaby
        @furbaby=nil
      end
    end
  end

  def update
    @token = Token.find(params[:id])
    if @token.user_id==1
      @message=Message.where(token_id: @token.id).first
      @message.token_id=nil
      @token.user_id = current_user.id

      @message.save
      @token.save

      flash.notice='Claimed a token!'
      redirect_to '/tokens/'+@token.id.to_s
    elsif @token.furbaby_id
      @token.vibes+=1
      @token.save
      flash.notice='You pet the Furbaby! ❤️ ❤️ ❤️'
      redirect_to '/tokens/'+@token.id.to_s+'?pet=true'
    elsif @token.id==current_user.empty_token.id
      @furbaby=Furbaby.find(params[:furbaby])
      if @furbaby.heat?
        @egg=Furbaby.new_egg @furbaby.dna
        @token.furbaby_id=@egg.id
        @token.save
        if @egg.valid? and @token.valid?
          flash.notice="Laid an egg! 🥚"
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+@egg.errors.all_messages+@token.errors.all_messages
          redirect_to '/'
        end
      end
    end
  end

  def index
    redirect_to '/users/'+current_user.id.to_s
  end

end
