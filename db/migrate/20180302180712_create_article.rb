class CreateArticle < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.timestamps
      t.string      :domain
      t.string      :title
      t.datetime    :published_at
      t.string      :url
    end
  end
end
