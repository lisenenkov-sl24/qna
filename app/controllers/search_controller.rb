class SearchController < ApplicationController
  skip_authorization_check

  def index; end

  def create
    @items = SearchService.new.search(params[:area].to_sym, params[:text])
  end
end
