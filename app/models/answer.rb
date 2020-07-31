class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :text, presence: true

  scope :best_top, -> { joins(:question).order(Arel.sql('answers.id = questions.best_answer_id DESC, answers.id ASC')) }
end
