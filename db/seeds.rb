# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Balance.delete_all

User.delete_all
users = [{name: 'Andy Stabler', email: "andy_60@hotmail.co.uk", password: "password", password_confirmation: "password"},
         {name: 'Fiona Barron', email: "fionabarron@hotmail.co.uk", password: "password", password_confirmation: "password"}]
User.create!(users)

Transfer.delete_all
transfers = [{on: Date.today - 5.days, reference: 'init', amount: 3000.00, user: User.find_by_name("Fiona Barron"), outgoing: false},
             {on: Date.today - 2.days, reference: 'car insurance', amount: 30, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'mobile', amount: 24, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'gas', amount: 37, user: User.find_by_name("Fiona Barron"), outgoing: true},
             {on: Date.today, reference: 'phone', amount: 24.00, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'petrol', amount: 40, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'food', amount: 30, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'gas', amount: 80, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'electricity', amount: 35, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'water', amount: 41, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'internet', amount: 24, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'car', amount: 200.00, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today+1.month, reference: 'Council Tax', amount: 1200, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'Rent', amount: 390, user: User.find_by_name("Andy Stabler"), outgoing: true},
             {on: Date.today, reference: 'wages', amount: 1602.48, user: User.find_by_name("Andy Stabler"), outgoing: false}]

transfers_monthly = [{on: Date.current.beginning_of_month + 25.days, reference: "Wages", amount: 1671.83, user: User.find_by(:name => "Andy Stabler"), outgoing: false},
                     {on: Date.current.beginning_of_month + 7.days, reference: "Rent", amount: 300.00, user: User.find_by(:name => "Andy Stabler"), outgoing: true},
                     {on: Date.current.beginning_of_month + 29.days, reference: "Scottish Power", amount: 81.00, user: User.find_by(:name => "Andy Stabler"), outgoing: true},
                     {on: Date.current.beginning_of_month + 8.days, reference: "Virgin Media", amount: 35.00, user: User.find_by(:name => "Andy Stabler"), outgoing: true},
                     {on: Date.current.beginning_of_month + 25.days, reference: "Premium Bonds", amount: 500, user: User.find_by(:name => "Andy Stabler"), outgoing: true}]
TransferMonthly.create! transfers_monthly


transfers_weekly = [{on: Date.current.beginning_of_week, reference: "Food", amount: 25, user: User.find_by(:name => "Andy Stabler"), outgoing: true},
                    {on: Date.current.end_of_week, reference: "Misc", amount: 15, user: User.find_by(:name => "Andy Stabler"), outgoing: true}]
TransferWeekly.create! transfers_weekly


transfers_daily = [{on: Date.current, reference: "Snacks", amount: 5, user: User.find_by(:name => "Andy Stabler"), outgoing: true}]
TransferDaily.create! transfers_daily

Balance.create!([{value: 0, on: Date.today-6.weeks, user: User.find_by_name("Andy Stabler")},
                {value: 100, on: Date.today-5.weeks, user: User.find_by_name("Andy Stabler")},
                {value: 1000, on: Date.today-4.weeks, user: User.find_by_name("Andy Stabler")},
                {value: 700, on: Date.today-3.weeks, user: User.find_by_name("Andy Stabler")},
                {value: 1300, on: DateTime.current, user: User.find_by_name("Andy Stabler")},
                ])
