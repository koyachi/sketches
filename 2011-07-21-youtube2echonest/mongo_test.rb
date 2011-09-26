# mongoid, mongomatic, mongo_odm, mongomodel
require 'mongoid'
require 'pp'

module HelloMongoid
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps

    field :first_name, type: String
    field :middle_name, type: String
    field :last_name, type: String
    field :blood_alochol_level, type: Float, default: 0.40
    field :last_drink, type: Time, default: -> { 10.minutes.ago }
  end

  class << self
    def main
      Mongoid.configure do |config|
        name = "hello_mongo"
        host = "localhost"
        config.master = Mongo::Connection.new.db(name)
      end

      person = Person.new(fisrt_name: "abc", middle_name: "def")
      pp person

      puts('# Get vavlue')
      p person.fisrt_name
      p person[:first_name]
      p person.read_attribute(:first_name)

      puts('# Set Value')
      person.first_name = "Jean"
      person[:first_name] = "Jean"
      person.write_attribute(:first_name, "Jean")
      pp person


      puts('# Get the field values as a hash.')
      pp person.attributes

      puts('# Set the field values in the document.')
      person = Person.new(fisrt_name: "Jean-Baptiste", middle_name: "Emmanual")
      person.attributes = { first_name: "Jean-Baptiste", middle_name: "Emmanual" }
      pp person
      person.write_attributes(
        first_name: "Jean-Baptiste",
        middle_name: "Emmanuel"
        )
      pp person
      if person.save
        puts "done."
      else
        puts 'save failed...'
      end
    end
  end
end

HelloMongoid.main
