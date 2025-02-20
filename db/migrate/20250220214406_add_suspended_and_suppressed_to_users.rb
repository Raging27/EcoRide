class AddSuspendedAndSuppressedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :suspended, :boolean, default: false, null: false
    add_column :users, :suppressed, :boolean, default: false, null: false
  end
end
