# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
super_admin = User.create(first_name: "Admin", last_name: "Sellist", is_super_admin: true, email: "admin@sellist.io", password: "123456", password_confirmation: "123456", active: true, confirmed_at: Time.now)

address = Spree::Address.create(firstname: "Admin", lastname: "Address", address1: "sec. 11D", address2: nil, city: "Faridabad", zipcode: "121007", phone: "23244457586", state_name: nil, alternative_phone: nil, company: nil, state_id: 1174, country_id: 105)
spree_admin = User.create(first_name: "Admin", last_name: "Spree", is_super_admin: false, email: "spree_admin@sellist.io", password: "123456", password_confirmation: "123456", active: true, confirmed_at: Time.now, bill_address: address)
user = User.find_by(email: 'spree_admin@sellist.io')
user.spree_roles << Spree::Role.where(name: 'admin').first_or_create

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

Spree::Role.where(name: 'manufacturer').first_or_create
Spree::Role.where(name: 'seller').first_or_create
Spree::Role.where(name: 'store').first_or_create
Spree::Role.where(name: 'customer').first_or_create
Spree::Role.where(name: 'user').first_or_create
