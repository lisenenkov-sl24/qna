class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :text, presence: true

  scope :best_top, -> { order(best: :desc, id: :asc) }
end
