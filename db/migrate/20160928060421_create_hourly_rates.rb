class CreateHourlyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :hourly_rates do |t|
      t.references :consultant, foreign_key: true
      t.decimal :amount
    end
  end
end
