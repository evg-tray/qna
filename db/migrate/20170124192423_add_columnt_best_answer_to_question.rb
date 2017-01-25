class AddColumntBestAnswerToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :best_answer, :integer
  end
end
