require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:restrict_with_error) }
  it { should have_many(:answers).dependent(:restrict_with_error) }
end
