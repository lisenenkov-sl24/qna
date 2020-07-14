FactoryBot.define do
  factory :answer do
    Question { nil }
    Text { "MyText" }
  end
end
