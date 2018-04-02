class ArticleQueryService
  class << self
    def query(params)
      unless params[:start] || params[:end]
        return create_response(Article.all)
      else
        if params[:start] && params[:end]
          collection = Article.where("published_at >= ?", DateTime.parse(params[:start])).where("published_at <= ?", DateTime.parse(params[:end]))
        elsif params[:start]
          collection = Article.where("published_at >= ?", DateTime.parse(params[:start]))
        else
          collection = Article.where("published_at <= ?", DateTime.parse(params[:end]))
        end
        return create_response(collection)
      end
    end
    private
    def create_response(articles)
      return_articles = []
      articles.each do |article|
        article_response = article.as_json
        article_response[:currencies] = []
        article.currencies.each do |currency|
          article_response[:currencies] << currency.as_json
        end
        article_response[:votes] = []
        article.votes.each do |vote|
          article_response[:votes] << vote.as_json
        end
        return_articles << article_response
      end
      return return_articles
    end

  end
end
