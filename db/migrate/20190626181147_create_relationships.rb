class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.belongs_to :component
      t.belongs_to :dependent, class: "Component"

      t.timestamps
    end
  end
end
