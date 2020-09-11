class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.belongs_to :user
      t.belongs_to :rateable, polymorphic: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
