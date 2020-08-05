FactoryBot.define do
  factory :link do
    trait :invalid do
      name { 'foe' }
      url { 'foe' }
    end

    trait :thinknetica do
      name { 'thinknetica' }
      url { 'https://thinknetica.com/' }
    end

    trait :github do
      name { 'github' }
      url { 'https://github.com/' }
    end
  end
end
