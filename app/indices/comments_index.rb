ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes text
  indexes user.email, as: :author, sortable: true

  has created_at, updated_at
end
