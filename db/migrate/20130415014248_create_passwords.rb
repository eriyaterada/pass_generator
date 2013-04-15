class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.string :encrypted_password

      t.timestamps
    end
  end
end
