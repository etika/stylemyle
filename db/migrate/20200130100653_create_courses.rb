class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :author
      t.string :state
      t.references :category
      t.timestamps
    end
  end
end
