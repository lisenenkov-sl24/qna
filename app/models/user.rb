class User < ApplicationRecord
  has_many :answers, foreign_key: :author_id, dependent: :restrict_with_error
  has_many :questions, foreign_key: :author_id, dependent: :restrict_with_error
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(obj)
    obj.author_id == id
  end

  def get_vote(obj)
    votes.find_by(votable: obj)&.rate
  end
end
