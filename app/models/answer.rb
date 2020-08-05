class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files, dependent: :destroy

  before_save :before_save_set_best

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

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
