# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all

ActiveRecord::Base.connection.execute 'ALTER SEQUENCE categories_id_seq RESTART WITH 1;'

Category.create({name: 'Kinder', description: 'Insituto de Educacion Preescolar Andres Osuna'})
Category.create({name: 'Primaria', description: 'Insituto de Educacion Integral Andres Osuna'})
Category.create({name: 'Secundaria', description: 'Secundaria Plan Abierto'})
Category.create({name: 'Preparatoria', description: 'Centro de Asesoria Andres Osuna'})
Category.create({name: 'CENAAC', description: 'Centro de Atencion a las Alteraciones del Aprendizaje y la Comunicacion S.C.'})

p Category.all
puts 'Categories created successfully'

User.destroy_all
ActiveRecord::Base.connection.execute 'ALTER SEQUENCE users_id_seq RESTART WITH 1;'

User.create({name: 'Administrador', login: 'admin', password: '4dm1n', password_confirmation: '4dm1n'})

p User.all
puts 'Users created successfully'