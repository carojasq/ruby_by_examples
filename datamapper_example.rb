require 'rubygems'
require 'data_mapper'
require 'date'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'

DataMapper.setup :default, 'sqlite:///home/null3d/Dropbox/Learning/Ruby/prueba_sqlite.db'

# Define the Person model
class Persona
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :fecha_insercion,  DateTime
end
# Automatically create the tables if they don't exist
DataMapper.auto_migrate! 

p1 = Persona.create(
	:nombre => "Pedro Perez",
	:fecha_insercion => Time.now
	)

p2 = Persona.create(
	:nombre => "Ramiro Ramirez",
	:fecha_insercion => Time.now
	)
p = Persona.get(1)
r = Persona.first(:nombre => "Ramiro Ramirez")
puts "#{r.nombre}, fecha agregado: #{r.fecha_insercion}"
puts "#{p.nombre}, fecha agregado: #{p.fecha_insercion}"


