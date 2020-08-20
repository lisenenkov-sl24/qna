class SearchController < ApplicationController
  skip_authorization_check

  helper_method :search_area_list
  helper_method :item_params

  def index; end

  def create
    @items = SearchService.new.search(params[:area].to_sym, params[:text])
  end

  private

  def search_area_list
    SearchService::SEARCH_AREAS.map { |v| [v.capitalize, v] }
  end

  def item_params(item)
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
