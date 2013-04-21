require 'openssl'
require 'base64'

class Encpassword < ActiveRecord::Base
  attr_accessor :password, :master_password #this creates the virtual attributes password and master_password
  attr_accessible :encrypted_password, :service, :service_url, :password, :master_password
  belongs_to :user

  validates :service, :presence => true, :length => {:maximum => 50}
  validates :password, :presence => true
  validates :master_password, :presence => true
  before_save :encrypt
    #this ensures that before you save the password to the databse,
    #the method encrypt_password is called
    
    #Set up the aes encryption mode for the encryption
    #set data to the virtual attribute password and set the key to
    # the virtual attribute master password
    #:return: => String
    #:arg: data => String 
    #:arg: key => String
  def encrypt()
    cipher_type = "aes-128-ecb"
    data = password;
    key = master_password;
    
    self.encrypted_password = aes_encrypt(data,key,nil,cipher_type).to_s
  end
    #class method, set up the aes encryption mode for the encryption
    #set service to the service and set the encrypted_data to
    # the attribute encrypted_password
    #:return: => String
    #:arg: service => String 
    #:arg: encrypted_data => String
  def self.decrypt(service_name,key)
    cipher_type = "aes-128-ecb"
    service = find_by_service(service_name)
    encrypted_data = service.encrypted_password
    aes_decrypt(encrypted_data,key,nil,cipher_type)
  end
  # encrypts a block of data given an encryption key and an 
  # initialization vector (iv).  Keys, iv's, and the data returned 
  # are all binary strings.  Cipher_type should be "AES-128-ECB"
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).key is the master key which is the user's password and pdkdf2_hmac_sha1 
  # function takes this password and generates the key of length equals to 
  # the OpenSSL::Cipher object's key length by using a salt
  # string and a iteration time between 1000-2000
  #:return: => String
  #:arg: data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String

 def aes_encrypt(data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.encrypt
    aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(key, "randomString", 1024, aes.key_len)
    aes.iv = iv if iv != nil
    aes.update(data.to_s) + aes.final    
  end
  # Class method, decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data 
  # returned are all binary strings.  Cipher_type should be
  # "AES-128-ECB" Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).key is the master key which is the user's password and pdkdf2_hmac_sha1 
  # function takes this password and generates the key of length equals to 
  # the OpenSSL::Cipher object's key length by using a salt
  # string and a iteration time between 1000-2000
  #:return: => String
  #:arg: encrypted_data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String
 def self.aes_decrypt(encrypted_data, key, iv, cipher_type)
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.decrypt
    key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(key, "randomString", 1024, aes.key_len)
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(encrypted_data) + aes.final  
 end
end

