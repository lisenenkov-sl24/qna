FactoryBot.define do
  sequence :text do |n|
    "Answer #{n} text"
  end

  factory :answer do
    question
    text
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
