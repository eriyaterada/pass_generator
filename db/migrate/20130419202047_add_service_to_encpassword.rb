class AddServiceToEncpassword < ActiveRecord::Migration
  def change
    add_column :encpasswords, :service, :string
  end
end
