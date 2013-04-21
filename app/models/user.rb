require 'digest'


class User < ActiveRecord::Base
  attr_accessible :email
  has_many :encpasswords, :dependent => :destroy
  
  
  #VALIDATIONS
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # regular expression for the email 
  validates :email, :presence => true, :format => {:with => email_regex}, :uniqueness => {:case_sensitive => false}, :length => {:maximum => 50} 
  
  #AUTHENTICATION
  attr_accessor :password #this creates the virtual attributes password
  attr_accessible :name, :email, :password, :password_confirmation
  passowrd_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[!\#\$\@\_\+\,\?\[\]\&])(?!.*["'])/ #regular expression for including upper and lower case letters, numbers and special characters
  validates :password, :presence => true, :confirmation => true, :length => {:within =>8...32}, :format => {:with => passowrd_regex}

  
  before_create { generate_token(:auth_token)}
  #this ensures the newly created user has a generated token
  
  before_save :encrypt_password
  #this ensures that before you save the password to the databse,
  #the method encrypt_password is called
    


private
  # this set the encrypted_password
  # :arg: salt => string
  # :arg: encrypted_password => string
  # :return: => nil
   def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
   end
public
  # this method encrypt the password
  # :arg: salt => string
  # :arg: string => string
  # :return: => string
   def encrypt(string)
      secure_hash("#{salt}--#{string}")
   end
  # this method takes the password and makes a salt to it
  # :arg: password => string
  # :return: => string
   def make_salt
      secure_hash("#Time.now.utc}--#{password}")
   end
  # this method takes a string and hashes it
  # :arg: string => string
  # :return: => string
   def secure_hash(string)
      Digest::SHA2.hexdigest(string)
   end
  # this method determines if the current user has a valid password
  # :arg: encrypted_password: => string
  # :arg: submitted_password => string
  # :return: => boolean
   def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
   end


   # this method authenticates user
   # :return: => user object or nil
   # :arg: email => String
   # :arg: submitted_password => String
   def self.authenticate(email, submitted_password)
      user = find_by_email(email)
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
   end

   # this method sends a password reset email to the user
   def send_password_reset
     generate_token(:password_reset_token)
     self.password_reset_sent_at = Time.zone.now
     save!(validate: false)
     UserMailer.password_reset(self).deliver
   end
  # this method generates a token 
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
   
end