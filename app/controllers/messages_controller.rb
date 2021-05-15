class MessagesController < ApplicationController
  def my_messages
     Message.where(to: current_user.name).reverse
  end

  def new
    @message = Message.new
    @message.to = params[:to]
    @message.subject = params[:subject]
    @message.body = params[:body]
  end

  def create
    @message = Message.new(params.require(:message).permit(
      :to,:subject,:body))
    m = /\A(The [A-Z][a-z]+) sent: (.+)\z/.match @message.subject
    if m
      @message.from = m[1]
      @message.subject = m[2]
    else
      @message.from = current_user.name
    end
    @message.save
    redirect_to '/messages'
  end

  def show
    if params[:cult]
      @messages = Message.where(to: "The "+params[:cult])
    else
      @messages = my_messages
    end
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
