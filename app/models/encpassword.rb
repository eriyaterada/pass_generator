class Encpassword < ActiveRecord::Base
  attr_accessible :encrypted_password
  belongs_to :user
end
