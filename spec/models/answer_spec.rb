require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belongs_to :question }
  it { should validate_presence_of :text }
end
