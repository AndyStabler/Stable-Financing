# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all

User.create!([{name: 'Andy Stabler', balance: '500.40'}, {name: 'Fiona Barron', balance: '9999.999'}])

Transaction.create!([{dat: Date.today, amount: '50.25', recurring: true, daily: true, weekly: false, monthly: false},
                     {dat: Date.today, amount: '24.50', recurring: false, daily: false, weekly: false, monthly: false}]);