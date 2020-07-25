FactoryBot.define do
  sequence(:email) { |n| "test#{n}@nomail.address" }
  sequence(:password) { |n| "Pass#{n}#{n}" }
  factory :user do
    email
    password
    password_confirmation { password }
  end
end
