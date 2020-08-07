FactoryBot.define do
  factory :vote do
    rate { 1 }
    user
    votable { create :question }
  end
end
