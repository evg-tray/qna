class AddColumntBestAnswerToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :best_answer, null: true
  end
end
