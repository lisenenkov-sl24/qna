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

    factory :question_with_answers do
      transient { answers_count { 5 } }

      after :create do |q, v|
        create_list :answer, v.answers_count, question: q
      end
    end
  end
end
