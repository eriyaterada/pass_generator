class ChangeStringFormatInEncpassword < ActiveRecord::Migration
  def up
    change_column :Encpasswords, :encrypted_password, :Symbol
  end

  def down
        change_column :Encpasswords, :encrypted_password, :String
  end
end
