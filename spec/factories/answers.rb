FactoryBot.define do
  factory :answer do
    question
    sequence(:text) { |n| "Answer #{n} text" }
    author { create :user }

    trait :invalid_text do
      text { '' }
    end

    trait :with_files do
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end

    trait :updated do
      text { 'NewText' }
      files { [Rack::Test::UploadedFile.new(Rails.root.join('README.md'))] }
    end
  end
end
