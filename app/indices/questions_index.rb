ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title, sortable: true
  indexes body
  indexes author.email, as: :author, sortable: true

  has created_at, updated_at
end
