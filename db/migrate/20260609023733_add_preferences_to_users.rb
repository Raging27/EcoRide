class AddPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :smoker,             :boolean, default: false, null: false
    add_column :users, :animal,             :boolean, default: false, null: false
    add_column :users, :custom_preferences, :text
  end
end
