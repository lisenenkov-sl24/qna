class User < ApplicationRecord
  has_many :answers, foreign_key: :author_id, dependent: :restrict_with_error
  has_many :questions, foreign_key: :author_id, dependent: :restrict_with_error
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :question_subscriptions, source: :question

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github facebook]

  def author_of?(obj)
    obj.author_id == id
  end

  def get_vote(obj)
    votes.find_by(votable: obj)&.rate
  end

  def self.find_for_oauth!(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    User.transaction do
      unless user
        password = SecureRandom.alphanumeric(10)
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    end
    user
  end

end
