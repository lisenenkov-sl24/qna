class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :user_id, :created_at, :updated_at
end
