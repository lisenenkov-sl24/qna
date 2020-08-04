FactoryBot.define do
  sequence :title do |n|
    "Title #{n}"
  end
  sequence :body do |n|
    "Question #{n} body"
  end

  factory :question do
    title
    body
    author { create :user }

    trait :invalid_title do
      title { '' }
    end

    trait :updated do
      title { 'NewTitle' }
      body { 'NewBody' }
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end

    trait :with_files do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end

    factory :question_with_answers do
      transient { answers_count { 5 } }

      after :create do |q, v|
        create_list :answer, v.answers_count, question: q, author: q.author
      end
    end
  end
end
