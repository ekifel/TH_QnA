class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :user, default: nil, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
