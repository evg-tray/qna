class Search
  TYPES = %w(question answer comment user)

  def self.types
    TYPES
  end

  def self.results(query, scopes, page)
    classes = []
    scopes.each do |scope|
      next unless TYPES.include?(scope)
      classes << scope.capitalize.constantize
    end
    if classes.any?
      ThinkingSphinx.search(ThinkingSphinx::Query.escape(query), classes: classes, page: page, per_page: 5)
    end
  end
end