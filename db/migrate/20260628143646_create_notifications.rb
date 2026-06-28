class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :notifiable, polymorphic: true, null: false, type: :uuid
      t.string :notification_type
      t.boolean :read
      t.string :message

      t.timestamps
    end
  end
end
