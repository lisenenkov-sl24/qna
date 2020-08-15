class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :updated_at

  belongs_to :author
end
