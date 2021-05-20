class TokensController < ApplicationController
  def create
    if logged_in?
      @token = Token.create(user_id:current_user.id)
    end
    if @token.valid?
      flash.notice='Minted a token!'
      current_user.heat
      current_user.heat
      redirect_to '/tokens/'+@token.id.to_s
    end
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
    elsif @token.furbaby_id and !@token.furbaby.egg?
      @token.vibes+=1
      @token.save
      flash.notice='You pet the Furbaby! ❤️ ❤️ ❤️'
      current_user.heat
      redirect_to '/tokens/'+@token.id.to_s+'?pet=true'
    elsif current_user.empty_token and @token.id==current_user.empty_token.id
      @mom=Furbaby.find(params[:furbaby])
      if @mom.heat?
        @egg=Furbaby.new_egg @mom
        @token.furbaby_id=@egg.id
        @token.vibes=@mom.token.vibes
        @token.save
        @mom.token.vibes=0
        @mom.token.save
        if @egg.valid? and @token.valid?
          flash.notice="Laid an egg! 🥚"
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+@egg.errors.all_messages+@token.errors.all_messages
          redirect_to '/'
        end
      end
    elsif @token.furbaby.egg?
      @stud=Furbaby.find(params[:furbaby])
      if @stud.stud? or @stud.mutant?
        if @stud.stud?
          @token.furbaby.hatch @stud
          @token.furbaby.save
          flash.notice="Hatched an egg! 🐣"
        elsif @stud.mutant?
          @token.furbaby.inject_dna_with @stud
          @token.furbaby.save
          flash.notice="Injected dna into egg! 🧬"
        end
        @token.vibes+=@stud.token.vibes
        @token.save
        @stud.token.vibes=0
        @stud.token.save
        if @token.furbaby.valid? and @token.valid?
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+@token.furbaby.errors.all_messages+@token.errors.all_messages
          redirect_to '/'
        end
      end
    end
  end

  def index
    redirect_to '/users/'+current_user.id.to_s
  end

  def destroy
    @token=Token.find(params[:id])
    if @token and @token.user_id==current_user.id
      f=@token.furbaby
      @token.furbaby_id=nil
      @token.save
      flash.notice="Goodbye, "+ f.vocab[4] +" furbaby . . . 🥺"
      redirect_to '/tokens/'+@token.id.to_s
    end
  end
end
