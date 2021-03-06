# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    if user.nil?
      define_guest_abilities
    elsif !user.admin?
      define_user_abilities user
    else
      define_admin_abilities
    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def define_guest_abilities
    can :read, :all
  end

  def define_user_abilities(user)
    define_guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :destroy, Subscription, user_id: user.id

    can %i[edit update destroy], [Question, Answer], author_id: user.id
    can %i[vote unvote], [Question, Answer] do |resource|
      resource.author_id != user.id
    end

    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }
    can :best, Answer, question: { author_id: user.id }
  end

  def define_admin_abilities
    can :manage, :all
  end

end
