class AddUserIdToEncpassword < ActiveRecord::Migration
  def change
    add_column :encpasswords, :user_id, :integer
  end
end
