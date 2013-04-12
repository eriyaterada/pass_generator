class User < ActiveRecord::Base
  attr_accessible :email
  validates :email, :presence => true, :length => {:maximum => 50} #validate the presence of name and that email address is less than 50 characters long

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}

  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation
  passowrd_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[!\#\$\@\_\+\,\?\[\]])(?!.*["'])/
  valitates :password, :presence => true, :confirmation => true, :length => {:within =>8...32}, :format => {:with => passowrd_regex}
end
