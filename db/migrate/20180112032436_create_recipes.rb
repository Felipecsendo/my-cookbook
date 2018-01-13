class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :difficulty
      t.integer :cook_time
      t.text :method

      t.timestamps
    end
  end
end