class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.float :average

      t.timestamps
      
      t.index :name
    end
  end
end
