# rake db:drop

#Users
User.destroy_all
User.create(name:"jo")
User.create(name:"mom")
User.create(name:"nanny")

# Babies 
Baby.destroy_all
Baby.create(name: "Aria", birth_date: "2019-09-10", sex: "female")
Baby.create(name: "Aaron", birth_date: "2012-06-12", sex: "male")
Baby.create(name: "Joseph", due_date: "2011-08-11", sex: "male")
Baby.create(name: "Daniel", birth_date: "2013-05-20", sex: "male")
Baby.create(name: "Christine", birth_date: "2018-01-01", sex: "female")
Baby.create(name: "David", birth_date: "2019-06-25", sex: "male")

# Activities 
Activity.destroy_all
Activity.create(name: "sleeping", start_time: "2019-09-10 09:00", amount: "200ml", notes: "Baby burped.", baby_id:Baby.first.id)
Activity.create(name: "sleeping", start_time: "2019-09-10 11:00", amount: "150ml", notes: "Baby didn't burp.", baby_id:Baby.first.id)
Activity.create(name: "diaper change", start_time: "2019-09-10 12:00", diaper_status: "wet", baby_id: Baby.first.id)
Activity.create(name: "sleep", start_time: "2019-09-10 12:30", end_time: "2019-09-10 13:30", notes: "Baby cried once.", baby_id:Baby.first.id)
Activity.create(name: "diaper change", start_time: "2019-09-10 13:45", diaper_status: "dry", notes: "Baby needs more milk.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-12 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-10 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-06 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-07 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-08 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)
Activity.create(name: "bathing", start_time: "2019-09-05 20:00", notes: "Baby is clean now.", baby_id:Baby.first.id)

BabyUser.destroy_all
BabyUser.create(user_id: 1, baby_id: 1)
BabyUser.create(user_id: 2, baby_id: 1)
