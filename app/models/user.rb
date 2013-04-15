require 'digest'
class User < ActiveRecord::Base
  attr_accessible :email
  validates :email, :presence => true, :length => {:maximum => 50} #validate the presence of name and that email address is less than 50 characters long

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}

  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation
  passowrd_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[!\#\$\@\_\+\,\?\[\]])(?!.*["'])/
  validates :password, :presence => true, :confirmation => true, :length => {:within =>8...32}, :format => {:with => passowrd_regex}

  before_save :encrypted_password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  private
  def encrypted_password
     self.encrypted_password = encrypt(password)
  end

  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  


end
