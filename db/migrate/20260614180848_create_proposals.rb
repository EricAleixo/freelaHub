class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.references :job, null: false, foreign_key: true, type: :uuid
      t.text :message
      t.decimal :value
      t.string :status
      t.timestamps
    end
  end
end
