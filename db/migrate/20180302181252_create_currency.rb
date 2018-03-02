class CreateCurrency < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :code
    end
  end
end
