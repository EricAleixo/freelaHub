class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills, id: :uuid do |t|
      # suas colunas aqui
      t.timestamps
    end
  end
end