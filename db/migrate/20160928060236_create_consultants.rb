class CreateConsultants < ActiveRecord::Migration[5.0]
  def change
    create_table :consultants do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
