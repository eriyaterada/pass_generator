class AddServiceUrlToEncpassword < ActiveRecord::Migration
  def change
    add_column :encpasswords, :service_url, :string
  end
end
