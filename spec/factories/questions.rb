FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end

  factory :question do
    title
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
        create_list :answer, v.answers_count, question: q, author: q.author
      end
    end
  end
end
