class CreatePhashResults < ActiveRecord::Migration[8.0]
  def change
    create_table :phash_results do |t|
      t.references :image, null: false, foreign_key: true
      t.float :similarity
      t.string :decision

      t.timestamps
    end
  end
end
