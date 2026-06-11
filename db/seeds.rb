# db/seeds.rb
# Idempotent: safe to run multiple times without duplicating records.

puts "== Seeding users =="

admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "Admin User"
  user.credits               = 20
  user.role                  = "admin"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

User.find_or_create_by!(email: "employee@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "Employee User"
  user.credits               = 20
  user.role                  = "employee"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

driver = User.find_or_create_by!(email: "user1@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "User One"
  user.credits               = 20
  user.role                  = "driver"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

passenger = User.find_or_create_by!(email: "user2@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "User Two"
  user.credits               = 20
  user.role                  = "passenger"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

driver2 = User.find_or_create_by!(email: "camille.laurent@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "Camille L."
  user.credits               = 20
  user.role                  = "driver"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

driver3 = User.find_or_create_by!(email: "julien.moreau@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "Julien M."
  user.credits               = 20
  user.role                  = "driver"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

passenger2 = User.find_or_create_by!(email: "sophie.dubois@example.com") do |user|
  user.password              = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo                = "Sophie D."
  user.credits               = 20
  user.role                  = "passenger"
  user.is_chauffeur          = false
  user.terms_accepted        = true
end

puts "   Users: #{User.count}"

# =============================================================================
# Vehicles — guarded by unique plate_number
# =============================================================================
puts "== Seeding vehicles =="

v_electric = Vehicle.find_or_create_by!(plate_number: "EV-001-ECO") do |v|
  v.user                    = driver
  v.brand                   = "Tesla"
  v.model                   = "Model 3"
  v.color                   = "Blanc"
  v.date_first_registration = Date.new(2022, 3, 15)
  v.electric                = true
end

v_thermal = Vehicle.find_or_create_by!(plate_number: "AB-456-CD") do |v|
  v.user                    = driver
  v.brand                   = "Renault"
  v.model                   = "Clio"
  v.color                   = "Gris"
  v.date_first_registration = Date.new(2019, 7, 1)
  v.electric                = false
end

v_driver2 = Vehicle.find_or_create_by!(plate_number: "CD-789-EF") do |v|
  v.user                    = driver2
  v.brand                   = "Peugeot"
  v.model                   = "e-208"
  v.color                   = "Bleu"
  v.date_first_registration = Date.new(2023, 1, 10)
  v.electric                = true
end

v_driver3 = Vehicle.find_or_create_by!(plate_number: "GH-012-IJ") do |v|
  v.user                    = driver3
  v.brand                   = "Citroën"
  v.model                   = "C3"
  v.color                   = "Rouge"
  v.date_first_registration = Date.new(2020, 5, 20)
  v.electric                = false
end

puts "   Vehicles: #{Vehicle.count}"

# =============================================================================
# Trips — destroy all seed drivers' trips for a clean reseed each run.
# =============================================================================
puts "== Seeding trips =="
Trip.where(driver_id: [driver.id, driver2.id, driver3.id]).destroy_all

now = Time.current

trips = Trip.create!([
  # ------------------------------------------------------------------ #
  # trips[0..5] — original 6, preserved in exact order so reviews and  #
  # bookings referencing trips[4] and trips[5] remain correct.         #
  # ------------------------------------------------------------------ #

  # trips[0] — planned
  {
    driver: driver, vehicle: v_electric,
    start_city: "Paris",      end_city: "Lyon",
    start_time: now + 2.days, end_time: now + 2.days + 4.hours,
    price: 25, seats_available: 3, status: "planned",
    created_at: 29.days.ago
  },
  # trips[1] — planned
  {
    driver: driver, vehicle: v_electric,
    start_city: "Lyon",       end_city: "Marseille",
    start_time: now + 5.days, end_time: now + 5.days + 3.hours,
    price: 20, seats_available: 2, status: "planned",
    created_at: 27.days.ago
  },
  # trips[2] — planned
  {
    driver: driver, vehicle: v_thermal,
    start_city: "Paris",      end_city: "Bordeaux",
    start_time: now + 7.days, end_time: now + 7.days + 5.hours,
    price: 35, seats_available: 4, status: "planned",
    created_at: 27.days.ago
  },
  # trips[3] — in_progress
  {
    driver: driver, vehicle: v_electric,
    start_city: "Nantes",     end_city: "Paris",
    start_time: now - 1.hour, end_time: now + 3.hours,
    price: 30, seats_available: 1, status: "in_progress",
    created_at: 24.days.ago
  },
  # trips[4] — finished (bookings + reviews attached)
  {
    driver: driver, vehicle: v_thermal,
    start_city: "Toulouse",   end_city: "Montpellier",
    start_time: now - 3.days, end_time: now - 3.days + 2.hours,
    price: 15, seats_available: 2, status: "finished",
    created_at: 21.days.ago
  },
  # trips[5] — finished (bookings + reviews attached)
  {
    driver: driver, vehicle: v_electric,
    start_city: "Strasbourg", end_city: "Paris",
    start_time: now - 7.days, end_time: now - 7.days + 4.hours,
    price: 28, seats_available: 3, status: "finished",
    created_at: 21.days.ago
  },

  # ------------------------------------------------------------------ #
  # trips[6..24] — new trips across driver2 and driver3                #
  # ------------------------------------------------------------------ #

  # trips[6]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Paris",      end_city: "Lille",
    start_time: now - 28.days, end_time: now - 28.days + 2.hours,
    price: 18, seats_available: 3, status: "finished",
    created_at: 21.days.ago
  },
  # trips[7]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Lille",      end_city: "Paris",
    start_time: now - 26.days, end_time: now - 26.days + 2.hours,
    price: 18, seats_available: 2, status: "finished",
    created_at: 18.days.ago
  },
  # trips[8]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Lyon",       end_city: "Grenoble",
    start_time: now - 24.days, end_time: now - 24.days + 1.hour,
    price: 15, seats_available: 2, status: "finished",
    created_at: 16.days.ago
  },
  # trips[9]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Marseille",  end_city: "Nice",
    start_time: now - 22.days, end_time: now - 22.days + 2.hours,
    price: 22, seats_available: 3, status: "finished",
    created_at: 16.days.ago
  },
  # trips[10]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Bordeaux",   end_city: "Toulouse",
    start_time: now - 20.days, end_time: now - 20.days + 2.hours,
    price: 20, seats_available: 4, status: "finished",
    created_at: 13.days.ago
  },
  # trips[11]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Nantes",     end_city: "Rennes",
    start_time: now - 18.days, end_time: now - 18.days + 1.hour,
    price: 16, seats_available: 2, status: "finished",
    created_at: 13.days.ago
  },
  # trips[12]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Paris",      end_city: "Strasbourg",
    start_time: now - 16.days, end_time: now - 16.days + 4.hours,
    price: 35, seats_available: 3, status: "finished",
    created_at: 13.days.ago
  },
  # trips[13]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Lyon",       end_city: "Toulouse",
    start_time: now - 14.days, end_time: now - 14.days + 3.hours,
    price: 30, seats_available: 2, status: "finished",
    created_at: 10.days.ago
  },
  # trips[14]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Nice",       end_city: "Marseille",
    start_time: now - 12.days, end_time: now - 12.days + 2.hours,
    price: 25, seats_available: 1, status: "finished",
    created_at: 9.days.ago
  },
  # trips[15]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Rennes",     end_city: "Nantes",
    start_time: now - 10.days, end_time: now - 10.days + 1.hour,
    price: 15, seats_available: 3, status: "finished",
    created_at: 7.days.ago
  },
  # trips[16]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Grenoble",   end_city: "Lyon",
    start_time: now - 8.days, end_time: now - 8.days + 1.hour,
    price: 17, seats_available: 2, status: "finished",
    created_at: 7.days.ago
  },
  # trips[17]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Paris",      end_city: "Bordeaux",
    start_time: now - 6.days, end_time: now - 6.days + 5.hours,
    price: 38, seats_available: 2, status: "finished",
    created_at: 5.days.ago
  },
  # trips[18]
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Toulouse",   end_city: "Bordeaux",
    start_time: now - 4.days, end_time: now - 4.days + 2.hours,
    price: 22, seats_available: 3, status: "finished",
    created_at: 5.days.ago
  },
  # trips[19]
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Lille",      end_city: "Strasbourg",
    start_time: now - 2.days, end_time: now - 2.days + 4.hours,
    price: 33, seats_available: 2, status: "finished",
    created_at: 5.days.ago
  },
  # trips[20] — in_progress
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Montpellier", end_city: "Nice",
    start_time: now - 2.hours, end_time: now + 2.hours,
    price: 20, seats_available: 1, status: "in_progress",
    created_at: 3.days.ago
  },
  # trips[21] — planned
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Paris",      end_city: "Rennes",
    start_time: now + 3.days, end_time: now + 3.days + 3.hours,
    price: 28, seats_available: 3, status: "planned",
    created_at: 3.days.ago
  },
  # trips[22] — planned
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Lyon",       end_city: "Paris",
    start_time: now + 4.days, end_time: now + 4.days + 4.hours,
    price: 32, seats_available: 2, status: "planned",
    created_at: 2.days.ago
  },
  # trips[23] — planned
  {
    driver: driver2, vehicle: v_driver2,
    start_city: "Marseille",  end_city: "Montpellier",
    start_time: now + 6.days, end_time: now + 6.days + 2.hours,
    price: 19, seats_available: 4, status: "planned",
    created_at: 1.day.ago
  },
  # trips[24] — planned
  {
    driver: driver3, vehicle: v_driver3,
    start_city: "Bordeaux",   end_city: "Paris",
    start_time: now + 9.days, end_time: now + 9.days + 5.hours,
    price: 40, seats_available: 2, status: "planned",
    created_at: 1.day.ago
  }
])

puts "   Trips: #{Trip.count}"

# =============================================================================
# PassengerBookings — destroy for ALL seed passengers then recreate
# =============================================================================
puts "== Seeding passenger bookings =="
PassengerBooking.where(passenger_id: [passenger.id, passenger2.id]).destroy_all

PassengerBooking.create!([
  # original 2 (trips[4] and trips[5] — finished, reviews depend on these)
  { trip: trips[4],  passenger: passenger,  status: "confirmed", created_at: 21.days.ago },
  { trip: trips[5],  passenger: passenger,  status: "confirmed", created_at: 21.days.ago },
  # new bookings across passenger and passenger2
  { trip: trips[6],  passenger: passenger2, status: "confirmed", created_at: 18.days.ago },
  { trip: trips[7],  passenger: passenger,  status: "confirmed", created_at: 16.days.ago },
  { trip: trips[8],  passenger: passenger2, status: "confirmed", created_at: 16.days.ago },
  { trip: trips[9],  passenger: passenger,  status: "confirmed", created_at: 13.days.ago },
  { trip: trips[10], passenger: passenger2, status: "confirmed", created_at: 13.days.ago },
  { trip: trips[11], passenger: passenger,  status: "confirmed", created_at: 9.days.ago  },
  { trip: trips[13], passenger: passenger2, status: "confirmed", created_at: 7.days.ago  },
  { trip: trips[15], passenger: passenger,  status: "confirmed", created_at: 7.days.ago  },
  { trip: trips[16], passenger: passenger2, status: "confirmed", created_at: 5.days.ago  },
  { trip: trips[19], passenger: passenger,  status: "confirmed", created_at: 1.day.ago   }
])

puts "   Bookings: #{PassengerBooking.count}"

# =============================================================================
# MongoDB Reviews — delete_all then recreate (trip IDs change each reseed)
# =============================================================================
puts "== Seeding MongoDB reviews =="
Review.delete_all

[
  {
    trip_id:      trips[4].id,
    driver_id:    driver.id,
    passenger_id: passenger.id,
    rating:       5,
    content:      "Trajet excellent, conducteur très ponctuel et agréable. Je recommande !",
    status:       "approved"
  },
  {
    trip_id:      trips[5].id,
    driver_id:    driver.id,
    passenger_id: passenger.id,
    rating:       4,
    content:      "Bon voyage, voiture propre et confortable. Bonne musique aussi.",
    status:       "pending"
  },
  {
    trip_id:      trips[4].id,
    driver_id:    driver.id,
    passenger_id: admin.id,
    rating:       3,
    content:      "Correct mais quelques minutes de retard au départ.",
    status:       "approved"
  }
].each do |attrs|
  Review.create!(attrs)
end

puts "   Reviews: #{Review.count}"
puts "== Seed complete =="
