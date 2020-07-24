FactoryBot.define do
  sequence :text do |n|
    "Question #{n} text"
  end

  factory :answer do
    question
    text

    trait :invalid_text do
      text { '' }
    end

    trait :updated do
      text { 'NewText' }
    end
  end
end
