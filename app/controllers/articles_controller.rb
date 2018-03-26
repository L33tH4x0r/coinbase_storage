class ArticlesController < ApplicationController
  def index
    json_response Article.all.to_json
  end
end
