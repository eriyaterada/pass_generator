class Encpassword < ActiveRecord::Base
  attr_accessible :encrypted_password, :service
  belongs_to :user
  
  
    #VALIDATIONS
  validates :service, :presence => true, :length => {:maximum => 50} 
end
