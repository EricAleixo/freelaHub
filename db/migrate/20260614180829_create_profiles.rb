class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :bio
      t.string :course
      t.string :institution
      t.string :github
      t.string :linkedin

      t.timestamps
    end
  end
end
