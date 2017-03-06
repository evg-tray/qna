ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email, sortable: true
end