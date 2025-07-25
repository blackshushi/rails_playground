class MessagesController < ApplicationController
  before_action :set_room, only: %i[new create]

  def new
    @message = @room.messages.new
  end

  def create
    @message = @room.messages.create!(message_params)

    respond_to do |format|
      format.html { redirect_to @room }
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.append("messages", @message),
          turbo_stream.update(
            "new_message",
            partial: "messages/form",
            locals: {
              room: @room,
              message: @room.messages.new
            }
          )
        ]
      }
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def message_params
    p = params.require(:message).permit(:content)
    if current_user
      p.merge(user: current_user)
    else
      p.merge(guest_name: session[:guest_name])
    end
  end
end
