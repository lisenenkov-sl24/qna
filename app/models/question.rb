class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable
  has_many :rewards, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :rewards, allow_destroy: true, reject_if: :all_blank

  validates :title, :body, presence: true
end
