FactoryBot.define do
  sequence :name do |n|
    "Reward name #{n}"
  end

  factory :reward do
    name
    question
  end
end
