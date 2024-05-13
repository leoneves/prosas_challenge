class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.float :weighted_mean
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
