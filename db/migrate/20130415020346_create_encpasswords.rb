class CreateEncpasswords < ActiveRecord::Migration
  def change
    create_table :encpasswords do |t|
      t.string :encrypted_password

      t.timestamps
    end
  end
end
