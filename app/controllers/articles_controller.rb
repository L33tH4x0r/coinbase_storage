class ArticlesController < ApplicationController
  def index
    json_response ArticleQueryService.query(params)
  end
end
