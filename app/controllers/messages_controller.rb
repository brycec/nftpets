class MessagesController < ApplicationController
  def create
  end

  def show
  end

  def index
    @path = 'messages'
    @messages = Message.all
  end
  def delete
  end
end
