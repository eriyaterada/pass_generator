class Encpassword < ActiveRecord::Base
  attr_accessible :encrypted_password, :service
  belongs_to :user
end
