class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.create(params.require(:message).permit(
      :to,:subject,:body))
    @message.from = current_user.name
    @message.save
    redirect_to '/messages'
  end

 def my_messages
   Message.where(to: current_user.name)
end
  def show
    @messages = my_messages
    @fmessage = Message.find(params[:id])
    render  "index"
  end

  def index
    @messages = my_messages
    @fmessage = @messages.first
  end

  def delete
  end
end
