class CreateVote < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :negative, default: 0
      t.integer :positive, default: 0
      t.integer :important, default: 0
      t.integer :article_id
    end
  end
end
