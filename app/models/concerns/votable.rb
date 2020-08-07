module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:rate)
  end

  def vote(user, rate)
    return if user.author_of? self
    votes.create(user: user, rate: rate)
  end

  def unvote(user)
    votes.find_by!(user: user).destroy
  end
end
