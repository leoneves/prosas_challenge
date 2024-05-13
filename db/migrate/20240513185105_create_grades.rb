class CreateGrades < ActiveRecord::Migration[7.1]
  def change
    create_table :grades do |t|
      t.float :grade
      t.references :assessment, null: false, foreign_key: true
      t.references :criteria, null: false, foreign_key: true

      t.timestamps
    end
  end
end
