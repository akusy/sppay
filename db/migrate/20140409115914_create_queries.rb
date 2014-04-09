class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.integer :page
      t.string :pub0
      t.string :uid
      t.timestamps
    end
  end
end
