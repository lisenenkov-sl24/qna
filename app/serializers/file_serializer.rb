class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :url do
    rails_blob_path(object, only_path: true )
  end
end
