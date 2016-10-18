class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :consultant, foreign_key: true
      t.string :name
      t.string :client
    end
  end
end
