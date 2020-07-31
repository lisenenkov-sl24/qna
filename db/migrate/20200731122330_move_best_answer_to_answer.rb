class MoveBestAnswerToAnswer < ActiveRecord::Migration[6.0]
  def change
    remove_reference :questions, :best_answer, null: true, foreign_key: { to_table: :answers }
    add_column :answers, :best, :boolean, null: false, default: false
  end
end
