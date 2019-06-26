class CreateComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :components do |t|
      t.string :name
      t.string :command
      t.boolean :had_dependency, default: false
      t.integer :dependent_id

      t.timestamps
    end
  end
end
