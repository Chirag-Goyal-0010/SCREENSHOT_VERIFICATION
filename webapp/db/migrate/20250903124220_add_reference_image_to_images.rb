class AddReferenceImageToImages < ActiveRecord::Migration[8.0]
  def change
    add_reference :images, :reference_image, null: true, foreign_key: true
  end
end
