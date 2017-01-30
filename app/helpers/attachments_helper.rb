module AttachmentsHelper
  def link_to_delete_attachment(attachment)
    return unless user_signed_in? && current_user.author_of?(attachment.attachable)
    link_to 'Delete attachment', attachment_path(attachment), method: :delete, remote: true
  end
end
