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
      :to,:subject,:body,:token_id))
    m = /\A(The [A-Z][a-z]+) sent: (.+)\z/.match @message.subject
    if m
      @message.from = m[1]
      @message.subject = m[2]
    else
      @message.from = current_user.name
      token = Token.where(id: @message.token_id).first
      if token then
        token.user_id = 1
        token.save
      end
    end
    @message.save
    redirect_to '/messages'
  end

  def show
    @fmessage = Message.find(params[:id])
    if params[:cult]
      @messages = Message.where(to: "The "+params[:cult])
    else
      @messages = my_messages
      if @fmessage.to != current_user.name
        @fmessage = @messages.first
      end
    end
    render  "index"
  end

  def index
    @messages = my_messages
    @fmessage = @messages.first
  end

  def delete
  end
end
