class CreateCurrency < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.timestamp
      t.string    :code
      t.integer   :article_id
    end
  end
end
