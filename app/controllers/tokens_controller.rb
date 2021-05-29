class TokensController < ApplicationController
  def create
    if logged_in?
      @token = Token.create(user_id:current_user.id)
    end
    if @token.valid?
      flash.notice='Minted a token!'
      2.times do current_user.heat end
      Event.create(user_id: current_user_id, key: "mint", value: @token.id)
      redirect_to '/tokens/'+@token.id.to_s
    end
  end

  def show
    @token = Token.find(params[:id])
    redirect_to '/users/'+@token.user.id.to_s+'/'+@token.id.to_s
  end

  def update
    @token = Token.find(params[:id])
    @mom = Furbaby.find_by(id: params[:furbaby])
    if @token.user_id==1
      @message=Message.find_by(token_id: @token.id)
      @message.token_id=nil
      @token.user_id = current_user.id

      payment=Token.find_by(id: params[:payment])
      if @message.vod and payment and payment.vibes >= @message.vod
        Message.create({
          to: @message.from,
          from: current_user.name,
          subject: 'V.O.D. '+payment.vibes.to_s+'N',
          token_id: payment.id,
          body: "Attached is the V.O.D. payment token."
        })
        payment.user_id=1
        payment.save
      elsif @message.vod
        flash.notice = "uh oh"
        redirect '/'
        return
      end

      @message.save
      @token.save

      flash.notice='Claimed a token!'
      redirect_to '/tokens/'+@token.id.to_s
    elsif @token.furbaby_id and !@token.furbaby.egg? and !@mom
      old = @token.vibes
      @token.pet
      flash.notice='You pet the Furbaby! ❤️ ❤️ ❤️ +'+(@token.vibes-old).to_s
      current_user.heat
      Event.create(user_id: current_user_id, key: "pet", value: @token.id)
      redirect_to '/tokens/'+@token.id.to_s+'?pet=true'
    elsif @token.user_id!=current_user.id
      flash.notice='weird...'
      redirect_to '/'
    elsif current_user.empty_token and @token.id==current_user.empty_token.id and @mom
      if @mom.heat?
        @egg=@mom.new_egg @token
        if @egg.valid? and @token.valid?
          flash.notice="Laid an egg! 🥚"
          current_user.heat
          Event.create(user_id: current_user_id, key: "egg", value: @token.id)
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+@egg.errors.full_messages.join(" ")+@token.errors.full_messages.join(" ")
          redirect_to '/'
        end
      elsif @mom.radiated?
        split = @mom.split @token
        if split.valid?
          flash.notice="Split into two furbabies via fission! 💞"
          current_user.heat
          Event.create(user_id: current_user_id, key: "fission", value: @token.id)
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+split.errors.full_messages.join(" ")
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
          current_user.heat
          Event.create(user_id: current_user_id, key: "hatch", value: @token.id)
        elsif @stud.mutant?
          @token.furbaby.inject_dna_with @stud
          @token.furbaby.save
          flash.notice="Injected dna into egg! 🧬"
          current_user.heat
          Event.create(user_id: current_user_id, key: "inject", value: @token.id)
        end
        if @token.furbaby.valid? and @token.valid?
          redirect_to '/tokens/'+@token.id.to_s
        else
          flash.notice="oops "+@token.furbaby.errors.full_messages.join(" ")+@token.errors.full_messages.join(" ")
          redirect_to '/'
        end
      end
    elsif @mom and @token.furbaby # dumper
      current_user.tokens.without(@mom.token).each do |t|
        @mom.token.split_with t
        if t.furbaby then @mom.mix t.furbaby end
      end
      @mom.rand_dna
      @mom.save
      if @mom.valid?
        flash.notice="Dumped dna! 🗑"
        current_user.heat
        Event.create(user_id: current_user_id, key: "dump", value: @mom.token.id)
        redirect_to '/tokens/'+@token.id.to_s
      else
        flash.notice="oops "+@mom.errors.all_messages
        redirect_to '/'
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
      current_user.heat
      Event.create(user_id: current_user_id, key: "release", value: @token.id)
      redirect_to '/tokens/'+@token.id.to_s
    end
  end
end
