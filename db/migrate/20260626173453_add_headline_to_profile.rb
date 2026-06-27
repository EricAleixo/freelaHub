class AddHeadlineToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :headline, :string
  end
end
