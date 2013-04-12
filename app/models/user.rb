class User < ActiveRecord::Base
  attr_accessible :email
  validates :email, :presence => true, :length => {:maximum => 50} #validate the presence of name and that email address is less than 50 characters long

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}
end
