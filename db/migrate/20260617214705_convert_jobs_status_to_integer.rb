class ConvertJobsStatusToInteger < ActiveRecord::Migration[7.1]
  def up
    # 1. Cria uma coluna temporária integer
    add_column :jobs, :status_int, :integer, default: 0, null: false

    # 2. Copia os valores antigos (string) convertendo para o número certo.
    #    Qualquer status string desconhecido cai em "draft" (0) por segurança.
    execute <<~SQL
      UPDATE jobs SET status_int = CASE status
        WHEN 'draft'  THEN 0
        WHEN 'open'   THEN 1
        WHEN 'paused' THEN 2
        WHEN 'closed' THEN 3
        ELSE 0
      END
    SQL

    # 3. Remove a coluna antiga e renomeia a nova para "status"
    remove_column :jobs, :status
    rename_column :jobs, :status_int, :status

    add_index :jobs, :status
  end

  def down
    add_column :jobs, :status_str, :string, default: "draft"

    execute <<~SQL
      UPDATE jobs SET status_str = CASE status
        WHEN 0 THEN 'draft'
        WHEN 1 THEN 'open'
        WHEN 2 THEN 'paused'
        WHEN 3 THEN 'closed'
        ELSE 'draft'
      END
    SQL

    remove_column :jobs, :status
    rename_column :jobs, :status_str, :status
  end
end