FactoryBot.define do
  factory :comment do
    sequence(:text) { |n| "Comment #{n} text" }
    user
    commentable { create :question }

    trait :invalid_text do
      text { '' }
    end
  end
end
