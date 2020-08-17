class CreateQuestionSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :question_subscriptions do |t|
      t.references :question, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps

      t.index [:question_id, :user_id], unique: true
    end
  end
end
