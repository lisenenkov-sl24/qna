shared_examples 'API Show Detailable' do
  it 'contains author object' do
    expect(response_subject[:author]).to include jsonize(subject.author, %i[id email])
  end

  context 'comments' do
    it 'returns all comments' do
      expect(response_subject[:comments].size).to eq subject.comments.size
    end

    it 'returns all public fields' do
      expect(response_subject[:comments][0]).to include jsonize(subject.comments[0], %i[id text user_id created_at updated_at])
    end
  end

  context 'links' do
    it 'returns all links' do
      expect(response_subject[:links].size).to eq subject.links.size
    end

    it 'returns all public fields' do
      expect(response_subject[:links][0]).to include jsonize(subject.links[0], %i[id name url created_at updated_at])
    end
  end

  context 'files' do
    it 'returns all files' do
      expect(response_subject[:files].size).to eq subject.files.size
    end
  end
end

shared_context 'Create links and comments' do
  let!(:comments) { create_list :comment, 2, commentable: subject }
  let!(:links) { create_list :link, 2, linkable: subject }
end