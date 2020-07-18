FactoryBot.define do
  factory :answer do
    question
    text { "MyText" }

    trait :invalid_text do
      text { '' }
    end

    trait :updated do
      text { 'NewText' }
    end
  end
end
