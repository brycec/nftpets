class FurbabiesController < ApplicationController

  def new
    @token = Token.find(params[:token_id])
    if current_user and current_user.id==@token.user_id and !@token.furbaby_id
      @furbaby = Furbaby.new
      @furbaby.rand_dna
      @furbaby.ensure_symbol(params[:symbol])
      @furbaby.limit_rare_dna(2)
    end
  end

  def create
    furbaby = Furbaby.create dna: params[:dna]
    if furbaby.valid?
      token = Token.find(params[:token_id])
      furbaby.save
      token.furbaby_id = furbaby.id
      token.save
      flash.notice = 'Adopted a furbaby!'
      redirect_to '/tokens/'+token.id.to_s
    else
      flash.notice = furbaby.errors.full_messages.join(' ')
      redirect_to '/users/'+current_user_id.to_s
    end

  end

  def show
  end

  def update
  end

  def index
    @furbabies = Array.new(3) {|i|
       Furbaby.new(dna:'x'+i.to_s)
      }
  end
end
