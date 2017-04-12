class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.integer :wordpress_id, null: false
      t.string :slug, null: false
      t.string :name, null: false
    end
  end
end
