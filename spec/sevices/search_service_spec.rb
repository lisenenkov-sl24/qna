require 'rails_helper'

RSpec.describe SearchService do

  it 'returns nil if empty text' do
    expect(subject.search(:all, '')).to be_nil
  end

  it 'returns nil if short text' do
    expect(subject.search(:all, 'te')).to be_nil
  end

  it 'returns nil if incorrect area' do
    expect(subject.search(:asd, 'text')).to be_nil
  end

  it 'search with ThinkingSphinx for :all' do
    found = [create(:question)]
    expect(ThinkingSphinx).to receive(:search).with('text', classes: [Question, Answer, Comment, User]) { found }
    expect(subject.search(:all, 'text')).to eq found
  end

  it 'search with ThinkingSphinx for :questions' do
    found = [create(:question)]
    expect(ThinkingSphinx).to receive(:search).with('text', classes: [Question]) { found }
    expect(subject.search(:questions, 'text')).to eq found
  end
end
