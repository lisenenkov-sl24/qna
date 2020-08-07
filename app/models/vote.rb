class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: :votable, message: 'already voted'
  validates_inclusion_of :rate, in: [-1, 1]
end
