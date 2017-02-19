class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
    respond_with(@attachment)
  end
end