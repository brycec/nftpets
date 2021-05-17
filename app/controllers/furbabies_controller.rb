class FurbabiesController < ApplicationController

  def new
    @token = Token.find(params[:token_id])
    if current_user and current_user.id==@token.user_id and !@token.furbaby_id
      @furbaby = Furbaby.new
      @furbaby.rand_dna
      @furbaby.ensure_symbol(params[:symbol])
      @furbaby.created_at = DateTime.now - rand(365)*rand
      @furbaby.limit_rare_dna(2)
    else
      redirect_to '/'
    end
  end

  def create
    furbaby = Furbaby.create dna: params[:dna]
    token = Token.find(params[:token_id])
    furbaby.created_at -= rand(365)
    furbaby.save
    token.furbaby_id = furbaby.id
    token.save
    if furbaby.valid?
      flash.notice = 'Adopted a furbaby!'
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
    @furbaby.name = [@furbaby.vocab.index(params[:first].downcase),
        @furbaby.vocab.index(params[:middle].downcase),
        @furbaby.vocab.index(params[:last].downcase)].join(',')
    @furbaby.save
    if @furbaby.invalid?
      flash.notice = @furbaby.errors.all_messages.join(' ')
    end
    redirect_to '/tokens/'+@token.id.to_s
  end

  def index
    @furbabies = Array.new(3) {|i|
       Furbaby.new(dna:'x'+i.to_s)
      }
  end
end
