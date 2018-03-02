class CreateVote < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.boolean :negative
      t.boolean :positive
      t.boolean :important
    end
  end
end
