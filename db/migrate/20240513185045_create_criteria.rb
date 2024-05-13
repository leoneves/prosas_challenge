class CreateCriteria < ActiveRecord::Migration[7.1]
  def change
    create_table :criteria do |t|
      t.float :weight

      t.timestamps
    end
  end
end
