module AttachmentsHelper
  def link_to_delete_attachment(attachment)
    return unless can?(:destroy, attachment)
    link_to 'Delete attachment', attachment_path(attachment), method: :delete, remote: true
  end
end
