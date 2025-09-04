class AddVgg16ToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :vgg16_similarity, :float
    add_column :images, :vgg16_decision, :string
  end
end
