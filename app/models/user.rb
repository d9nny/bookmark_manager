require_relative '../data_mapper_setup'
require 'dm-validations'

class User
  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation
  

  property :id, Serial
  
  property :email, String, required: true, unique: true,
    format: :email_address

  property :password_digest, Text
    validates_confirmation_of :password
    validates_presence_of :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end