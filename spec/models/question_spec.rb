require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :answers }
  it { should have_title }
  it { should have_body }
end
