class MessagesController < ApplicationController
  def is_to_The?
    m = /\A(The [A-Z][a-z]+)/.match params[:to]
    if m and m[0] == "The Blog"
      @blog = true
    end
    m
  end

  def my_messages
    if is_to_The?
      Message.where(to: params[:to]).order(created_at: 'desc')
    elsif logged_in? and current_user.name==params[:to]
      Message.where(to: current_user.name).order(created_at: 'desc').without current_user.messages
    elsif logged_in?
      current_user.messages.order(created_at: 'desc')
    else
      []
    end
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
        if current_user.dead?
          current_user.damage=0
          current_user.tokens.map{|t|t.destroy}
          @message.to = current_user.name
          @message.from = "The Commissioner"
          @message.subject = "Token Recovery"
          @message.body = %{Operator,

Your token and it's furbaby are safe. May Neptune watch over those that were lost.

Littering Neptune's orbit with fried terminals is the price we pay to save them but we're not proud of it. Go easy on the new cpu.}
        end
      end
    end
    if @message.to=="The Chat"
      Event.create(user_id: current_user.id, key: "chat", value: @message.id)
    end
    @message.save
    current_user.heat
    if @message.valid?
      flash.notice = 'Message sent!'
    else
      flash.notice = 'uh oh '+@message.errors.full_messages.join(", ")
    end
    redirect_to '/messages'
  end

  def show
    @fmessage = Message.find(params[:id])
    @messages = my_messages
    if current_user and
      !is_to_The? and
      @fmessage.to != current_user.name
      @fmessage = @messages.first
    else

    end
    render  "index"
  end

  def index
    @messages = my_messages
    @fmessage = @messages ? @messages.first : nil
  end

  def update
    message = Message.find(params[:id])
    if current_user.messages.include? message
      current_user.messages.delete message
    elsif current_user.name==message.to
      current_user.messages<< message
    end
    redirect_to '/messages'
  end

  def blog
    params[:to] = "The Blog"
    @messages = my_messages
    @fmessage = params[:id] ? Message.find(params[:id]) : @messages.first
    render 'index'
  end
end
