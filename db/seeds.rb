# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.delete_all

user1 = User.create(username: "sambit.dutta", email: 'sambit.dutta@outlook.com', password: 'test123', password_confirmation: 'test123')
user2 = User.create(username: "debanjan.paul", email: 'd.paul@outlook.com', password: 'test123', password_confirmation: 'test123')
user2.follow(user1)
user3 = User.create(username: "debjani.ghosh", email: 'd.ghosh@outlook.com', password: 'test123', password_confirmation: 'test123')
user3.follow(user1)
user4 = User.create(username: "nitu.hazra", email: 'n.hazra@outlook.com', password: 'test123', password_confirmation: 'test123')
user4.follow(user1)

user5 = User.create(username: "aakash.sinha", email: 'a.sinha@outlook.com', password: 'test123', password_confirmation: 'test123')
user5.follow(user1)
user6 = User.create(username: "souvik.das", email: 's.das@outlook.com', password: 'test123', password_confirmation: 'test123')
user6.follow(user5)
user7 = User.create(username: "arnab.biswas", email: 'a.biswas@outlook.com', password: 'test123', password_confirmation: 'test123')
user7.follow(user5)

user1.follow(user6)

