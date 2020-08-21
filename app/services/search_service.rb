class SearchService
  SEARCH_AREAS = [:all, :questions, :answers, :comments, :users].freeze

  SEARCH_CLASSES = {
      all: [Question, Answer, Comment, User],
      questions: [Question],
      answers: [Answer],
      comments: [Comment],
      users: [User] }.freeze

  def search(area, text)
    return nil unless SEARCH_AREAS.include? area

    return nil if text.blank? || text.size < 3

    query = ThinkingSphinx::Query.escape text
    ThinkingSphinx.search query, classes: SEARCH_CLASSES[area]
  end
end
