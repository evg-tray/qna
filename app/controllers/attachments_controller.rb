class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    authorize!(:destroy, @attachment)
    @attachment.destroy
    respond_with(@attachment)
  end
end