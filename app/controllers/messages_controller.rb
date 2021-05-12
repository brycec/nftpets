class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
  end

  def show
  end

  def index
    @messages = Message.all
  end

  def delete
  end
end
