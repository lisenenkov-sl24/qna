FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }

    trait :invalid_title do
      title { '' }
    end

    trait :updated do
      title { 'NewTitle' }
      body { 'NewBody' }
    end
  end
end
