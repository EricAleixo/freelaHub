class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.decimal :budget
      t.string :status
      t.timestamps
    end
  end
end
