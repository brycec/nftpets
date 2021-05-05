class FurbabiesController < ApplicationController
  def new
  end

  def create
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
