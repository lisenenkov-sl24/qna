class RenameQuestionSubscriptionsToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    rename_table :question_subscriptions, :subscriptions
  end
end
