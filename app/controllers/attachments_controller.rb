class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
  end
end