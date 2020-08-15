class AnswerDetailSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :updated_at

  belongs_to :author
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
