class AddNameToSkills < ActiveRecord::Migration[7.1]
  def change
    add_column :skills, :name, :string, null: false, default: ""
 
    # Índice único case-insensitive: impede "Ruby" e "ruby" como registros
    # diferentes. Funciona em Postgres (mais comum em apps Rails modernos)
    # usando uma expressão sobre LOWER(name) em vez de depender da extensão
    # citext, que precisaria ser habilitada separadamente.
    add_index :skills, "LOWER(name)", unique: true, name: "index_skills_on_lower_name"
  end
end
 
