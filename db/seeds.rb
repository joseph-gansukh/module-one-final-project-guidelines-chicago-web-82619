# Babies 
# Baby.drop
Baby.create(name: "Aria", birth_date: "2019-09-10", gender: "female")
Baby.create(name: "Aaron", birth_date: "2012-06-12", gender: "male")
Baby.create(name: "Joseph", birth_date: "2011-08-11", gender: "male")
Baby.create(name: "Daniel", birth_date: "2013-05-20", gender: "male")
Baby.create(name: "Christine", birth_date: "2018-01-01", gender: "female")
Baby.create(name: "David", birth_date: "2019-06-25", gender: "male")

# Activities 
Activity.destroy_all
Activity.create(name: "feeding", start_time: "2019-09-10 09:00", amount: "200ml", notes: "Baby burped.")
Activity.create(name: "feeding", start_time: "2019-09-10 11:00", amount: "150ml", notes: "Baby didn't burp.")
Activity.create(name: "diaper change", start_time: "2019-09-10 12:00", diaper_status: "wet")
Activity.create(name: "sleep", start_time: "2019-09-10 12:30", end_time: "2019-09-10 13:30", notes: "Baby cried once.")
Activity.create(name: "diaper change", start_time: "2019-09-10 13:45", diaper_status: "dry", notes: "Baby needs more milk.")
Activity.create(name: "bathing", start_time: "2019-09-10 20:00", notes: "Baby is clean now.")

# Records
# Record.destroy_all
# Record.create(activity_id: Activity.first, baby_id: Baby.first, caregiver: "nanny")
# Record.create(activity_id: 2, baby_id: Baby.first, caregiver: "nanny")
# Record.create(activity_id: 3, baby_id: Baby.first, caregiver: "nanny")
# Record.create(activity_id: 4, baby_id: Baby.first, caregiver: "nanny")
# Record.create(activity_id: 5, baby_id: Baby.first, caregiver: "nanny")
# Record.create(activity_id: 6, baby_id: Baby.first, caregiver: "mom")