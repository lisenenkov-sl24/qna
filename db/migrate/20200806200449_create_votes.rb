class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true, index: false
      t.references :user, foreign_key: true
      t.integer :rate, limit: 1, null: false

      t.timestamps

      t.index [:votable_type, :votable_id, :user_id], unique: true
    end
  end
end
