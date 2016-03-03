# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
users = [{name: 'Andy Stabler', email: "andy_60@hotmail.co.uk", password: "password"},
         {name: 'Fiona Barron', email: "fionabarron@hotmail.co.uk", password: "password"}]
User.create!(users)

Transfer.delete_all
transfers = [{on: Date.today - 5.days, reference: 'init', amount: 3000.00, recurrence: 0, user: User.find_by_name("Fiona Barron"), outgoing: false},
             {on: Date.today - 2.days, reference: 'car insurance', amount: 30, recurrence: 1, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'mobile', amount: 24, recurrence: 2, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'gas', amount: 37, recurrence: 3, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'phone', amount: 24.00, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'petrol', amount: 40, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'food', amount: 30, recurrence: 2, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'gas', amount: 80, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'electricity', amount: 35, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'water', amount: 41, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'internet', amount: 24, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'car', amount: 200.00, recurrence: :monthly, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today+1.month, reference: 'Council Tax', amount: 1200, recurrence: :no, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'Rent', amount: 390, recurrence: :monthly, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'wages', amount: 1602.48, recurrence: 3, user: User.find_by_name("Andy Stabler"), outgoing: false}]

Transfer.create!(transfers)

Balance.delete_all
Balance.create!([{id: 1, value: 500, on: Date.today-5.weeks, user: User.find_by_name("Andy Stabler")},
                 {id: 2, value: 30, on: Date.today-3.weeks, user: User.find_by_name("Andy Stabler")},
                 {id: 3, value: 100, on: Date.today-2.weeks, user: User.find_by_name("Andy Stabler")},
                 {id: 4, value: 50, on: Date.today-5, user: User.find_by_name("Andy Stabler")},
                 {id: 5, value: 300, on: Date.today-3, user: User.find_by_name("Andy Stabler")},
                 {id: 6, value: 1000, on: Date.today-2, user: User.find_by_name("Andy Stabler")},
                 {id: 7, value: 3000, on: Date.today-10.days, user: User.find_by_name("Fiona Barron")},
                 {id: 8, value: 2900, on: Date.today-5.days, user: User.find_by_name("Fiona Barron")}])
