class AddJobIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :job_id, :uuid, null: true
    add_index :posts, :job_id
    add_foreign_key :posts, :jobs
  end
end