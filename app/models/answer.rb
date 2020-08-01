class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
  before_save :before_save_set_best

  validates :text, presence: true

  scope :best_top, -> { order(best: :desc, id: :asc) }

  private

  def before_save_set_best
    return unless best && best_changed?

    question.answers.where(best: true).each do |answer|
      answer.update!(best: false)
    end
  end
end
