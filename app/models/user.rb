require_relative '../data_mapper_setup'
require 'dm-validations'

class User
  include DataMapper::Resource
    property :id, Serial
    property :email, String, required: true
    property :password_digest, Text
    attr_reader :password
    attr_accessor :password_confirmation

    validates_presence_of :email
    validates_format_of :email, as: :email_address
    validates_confirmation_of :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end