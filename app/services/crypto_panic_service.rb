class CryptoPanicService
  def initialize
    @base_url       = "http://www.cryptopanic.com/api/posts/"
    @auth_token     = "?auth_token=e3d06307f0712ad7d0df47126a4baa446b287fb4"
    @base_filters   = "&public=true&currencies=BTC"
  end

  def call
    # prime loop
    begin
      article = HTTParty.get(@base_url+@auth_token+@base_filters).parsed_response
    rescue
      return nil
    end
    # Loop through api pages
    while article
      # Get next page
      next_page = article["next"]
      # loop through results
      article["results"].each do |result|
        # Store Article
        store_articles(result)
      end
      # Get articles from crypopanic
      begin
        sleep(1)
        article = HTTParty.get(next_page).parsed_response
      rescue
        return nil
      end
    end
    return true
  end

  def store_articles(result)
    unless Article.find_by(identifier: result["id"])
      db_article = Article.create(domain: result["domain"], title: result["title"], published_at: DateTime.iso8601(result["published_at"]), identifier: result["id"])
      db_article.votes << Vote.create(positive: result["votes"]["positive"].to_i, negative: result["votes"]["negative"], important: result["votes"]["important"])
      result["currencies"].each do |currency|
        db_article.currencies << Currency.create(code: currency["code"])
      end
    end
  end
end
