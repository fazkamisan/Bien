class ChangePriceType < ActiveRecord::Migration[5.1]
  def change
    change_column :reviews, :price, :string
  end
end
