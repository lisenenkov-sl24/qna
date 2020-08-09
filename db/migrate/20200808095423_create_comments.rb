class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :text
      t.references :user, null: false, foreign_key: true
      t.belongs_to :commentable, polymorphic: true, null: false, index: false

      t.timestamps
    end
  end
end
