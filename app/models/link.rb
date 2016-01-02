require_relative '../data_mapper_setup'

class Link
  include DataMapper::Resource

    property :id, Serial
    property :title, String, :length => 200
    property :url, String, :length => 200
    has n, :tags, through: Resource
end