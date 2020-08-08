class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: :votable, message: 'already voted' }
  validates :rate, inclusion: { in: [-1, 1] }
end
