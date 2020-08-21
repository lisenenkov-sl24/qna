module SearchHelper
  def search_area_list
    SearchService::SEARCH_AREAS.map { |v| [v.capitalize, v] }
  end

  def search_item_params(item)
    if item.is_a? Question
      { type: 'Question', link: question_path(item), title: item.title }
    elsif item.is_a? Answer
      { type: 'Answer', link: question_path(item.question), title: item.text.truncate(30) }
    elsif item.is_a? Comment
      { type: 'Comment', title: item.text.truncate(30) }
    elsif item.is_a? User
      { type: 'User', title: item.email.truncate(30) }
    end
  end
end