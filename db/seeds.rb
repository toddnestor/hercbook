# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DEFAULT_INSECURE_PASSWORD = 'hotstuff1'

User.create({
  first_name: "Todd",
  last_name: "Nestor",
  profile_name: "toddnestor",
  email: "todd.nestor@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD,
})

User.create({
  first_name: "Ziqin",
  last_name: "Nestor",
  profile_name: "ziqinhu",
  email: "dwan2007@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Matt",
  last_name: "Nestor",
  profile_name: "mjnestor",
  email: "mjnestor@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Mike",
  last_name: "Nestor",
  profile_name: "mikenestor",
  email: "michaelfnestor@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Sherri",
  last_name: "Nestor",
  profile_name: "sherrinestor",
  email: "sherrin8816@gmail.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

todd = User.find_by_email('todd.nestor@gmail.com')
ziqin = User.find_by_email('dwan2007@gmail.com')
matt = User.find_by_email('mjnestor@gmail.com')
mike = User.find_by_email('michaelfnestor@gmail.com')
sherri = User.find_by_email('sherrin8816@gmail.com')

seed_user = todd

seed_user.statuses.create(content: "Hello world")
ziqin.statuses.create(content: "I'm ziqin")
matt.statuses.create(content: "I don't respond to e-mail")
mike.statuses.create(content: "I like finance")
sherri.statuses.create(content: "I like HGTV")

UserFriendship.request(seed_user, ziqin).accept!
UserFriendship.request(seed_user, matt).block!
UserFriendship.request(seed_user, mike)