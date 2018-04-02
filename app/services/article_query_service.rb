class ArticleQueryService
  class << self
    def query(params)
      @page_count = params[:page_count] || 100
      @page_count = @page_count.to_i

      @page       = params[:page] || 1
      @page       = @page.to_i

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
      # Get all articles
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
      # paginate
      pagination = paginate_articles(return_articles)
      return {total: return_articles.count,
              page: @page,
              page_count: @page_count,
              total_pages: pagination[:total_pages],
              articles: pagination[:articles]}
    end

    def paginate_articles(articles)
      total_pages = (articles.count / @page_count).floor
      pagination = {total_pages: total_pages}

      start_index = (@page-1)*@page_count
      end_index   = @page*(@page_count)-1
      if end_index > articles.count
        end_index = -1
      end
      pagination[:articles] = articles[start_index .. end_index]
      return pagination
    end
  end
end
