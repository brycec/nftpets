class FurbabiesController < ApplicationController

  def new
    @token = Token.find(params[:token_id])
    if current_user and current_user.id==@token.user_id and !@token.furbaby_id
      strays = Furbaby.where.not(id:
        Token.where.not(furbaby_id: nil).map{|t|t.furbaby_id})
      if strays.length>0 and rand()>0.333
        @furbaby = strays.sample
        if @furbaby.egg? # stray egg gets fertilized by random stray tom cat
          tom = Furbaby.new
          tom.rand_dna
          tom.created_at = DateTime.now - rand(365)*rand*2
          tom.limit_rare_dna(3) # 3 star tom cat?!?! :O
          tom.save
          @furbaby.hatch tom
          @furbaby.save
        end
      else
        @furbaby = Furbaby.new
        @furbaby.rand_dna
        @furbaby.created_at = DateTime.now - rand(365)*rand
        @furbaby.limit_rare_dna(2)
      end
      @furbaby.ensure_symbol(params[:symbol])
      current_user.heat
    else
      redirect_to '/'
    end
  end

  def create
    furbaby = Furbaby.find_by(id: params[:furbaby_id])
    if !furbaby
      furbaby = Furbaby.create dna: params[:dna]
      furbaby.created_at = params[:created_at]
      furbaby.save
    end
    token = Token.find(params[:token_id])
    token.furbaby_id = furbaby.id
    token.save
    if furbaby.valid?
      flash.notice = 'Adopted a furbaby!'
      Event.create(user_id: current_user_id, key: "adopt", value: token.id)
      redirect_to '/tokens/'+token.id.to_s
    else
      flash.notice = furbaby.errors.full_messages.join(' ') + token.errors.full_messages.join(' ')
      redirect_to '/'
    end

  end

  def show
    @token = Token.where(furbaby_id: params[:id]).first
    if @token
      redirect_to '/tokens/'+@token.id.to_s
    else
      redirect_to '/'
    end
  end

  def token_or_redirect
    @token = Token.where(furbaby_id: params[:id]).first
    if current_user.id!=@token.user_id
      redirect_to '/tokens/'+@token.id.to_s
    end
    @furbaby = Furbaby.find(@token.furbaby_id)
  end

  def edit
    token_or_redirect
  end

  def update
    token_or_redirect
    @furbaby.name = [@furbaby.vocab.index(params[:first]),
        @furbaby.vocab.index(params[:middle]),
        @furbaby.vocab.index(params[:last])].join(',')
    @furbaby.save
    if @furbaby.invalid?
      flash.notice = @furbaby.errors.full_messages.join(' ')
    else
      flash.notice = "Nice to meet you, "+@furbaby.full_name+" 😸🤝😸"
    end
    redirect_to '/tokens/'+@token.id.to_s
  end

  def index
    @furbabies = Array.new(3) {|i|
       Furbaby.new(dna:'x'+i.to_s)
      }
  end
end
