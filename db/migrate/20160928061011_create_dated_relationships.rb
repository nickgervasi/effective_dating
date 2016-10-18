class CreateDatedRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :dated_relationships do |t|
      t.string :owner_type
      t.integer :owner_id
      t.date :effect_from
      t.date :effect_to
      t.string :feature_type
      t.integer :feature_id
      t.string :key
      t.string :type
    end

    add_index :dated_relationships, %i(owner_type owner_id key)
    add_index :dated_relationships, :effect_from
    add_index :dated_relationships, :effect_to
  end
end
