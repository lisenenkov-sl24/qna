FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link #{n} name" }
    sequence(:url) { |n| "https://site.com/link#{n}" }

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
