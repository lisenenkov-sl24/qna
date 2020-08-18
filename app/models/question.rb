class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  include Votable
  has_many_attached :files, dependent: :destroy

  before_create :before_create_subscribe_author

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :reward, allow_destroy: true, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :recent, ->(period) { where('created_at > ?', period.ago) }

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def before_create_subscribe_author
    subscribed_users.append(author)
  end
end
