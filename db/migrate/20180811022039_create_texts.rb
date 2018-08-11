class CreateTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :texts do |t|
      t.string :top_text
      t.string :bottom_text

      t.timestamps
    end
  end
end
