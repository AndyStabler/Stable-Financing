# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
users = [{name: 'Andy Stabler'}, {name: 'Fiona Barron'}]
User.create!(users)

Transfer.delete_all
transfers = [{on: Date.today, reference: 'car', amount: '50.25', recurrence: 1, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'mobile', amount: '24.50', recurrence: 2, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'mobile', amount: '30', recurrence: 0, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'rent', amount: '390', recurrence: 2, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'rent', amount: '390', recurrence: 1, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'FreeAgent', amount: '1200', recurrence: 2, user: User.find_by_name("Andy Stabler"), outgoing: false},
             {on: Date.today, reference: 'Parents', amount: '400', recurrence: 0, user: User.find_by_name("Fiona Barron"), outgoing: false}]
Transfer.create!(transfers)

Balance.delete_all
Balance.create!([{value: 100, transfer: Transfer.find_by_user_id(User.find_by_name("Andy Stabler"))}])