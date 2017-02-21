class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :url

  def name
    object.file.identifier
  end

  def url
    object.file.url
  end
end
