require 'digest'
class User < ActiveRecord::Base
  # a user has many encrypted passwords, and they will be deleted along with the user
  has_many :encpasswords, :dependent => :destroy
  
  #VALIDATIONS
  attr_accessible :email
  validates :email, :presence => true, :length => {:maximum => 50} #validate the presence of name and that email address is less than 50 characters long

  #AUTHENTICATION
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}

  attr_accessor :password #this creates the virtual attributes password
  attr_accessible :email, :password, :password_confirmation
  passowrd_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[!\#\$\@\_\+\,\?\[\]])(?!.*["'])/
  validates :password, :presence => true, :confirmation => true, :length => {:within =>8...32}, :format => {:with => passowrd_regex}

  #this ensures that before you save the password to the databse,
  #the method encrypt_password is called
  before_save :encrypt_password
 
  
private
   def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
   end
public
   def encrypt(string)
      secure_hash("#{salt}--#{string}")
   end

   def make_salt
      secure_hash("#Time.now.utc}--#{password}")
   end

   def secure_hash(string)
      Digest::SHA2.hexdigest(string)
   end

   def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
   end



   def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
   end
   
end