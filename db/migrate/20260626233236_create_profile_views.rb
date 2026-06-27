class CreateProfileViews < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_views, id: :uuid do |t|
      t.references :viewer, null: false, foreign_key: { to_table: :profiles }, type: :uuid
      t.references :viewed, null: false, foreign_key: { to_table: :profiles }, type: :uuid
      t.datetime :viewed_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    add_index :profile_views, [:viewer_id, :viewed_id], unique: true
  end
end