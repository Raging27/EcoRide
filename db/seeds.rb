# db/seeds.rb
# Idempotent: safe to run multiple times without duplicating records.

puts "== Seeding users =="

admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo = "Admin User"
  user.credits = 20
  user.role = "admin"
  user.is_chauffeur = false
end

User.find_or_create_by!(email: "employee@example.com") do |user|
  user.password = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo = "Employee User"
  user.credits = 20
  user.role = "employee"
  user.is_chauffeur = false
end

driver = User.find_or_create_by!(email: "user1@example.com") do |user|
  user.password = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo = "User One"
  user.credits = 20
  user.role = "driver"
  user.is_chauffeur = false
end

passenger = User.find_or_create_by!(email: "user2@example.com") do |user|
  user.password = "Password123@"
  user.password_confirmation = "Password123@"
  user.pseudo = "User Two"
  user.credits = 20
  user.role = "passenger"
  user.is_chauffeur = false
end

puts "   Users: #{User.count}"

# =============================================================================
# Vehicles — guarded by unique plate_number
# =============================================================================
puts "== Seeding vehicles =="

v_electric = Vehicle.find_or_create_by!(plate_number: "EV-001-ECO") do |v|
  v.user                   = driver
  v.brand                  = "Tesla"
  v.model                  = "Model 3"
  v.color                  = "Blanc"
  v.date_first_registration = Date.new(2022, 3, 15)
  v.electric               = true
end

v_thermal = Vehicle.find_or_create_by!(plate_number: "AB-456-CD") do |v|
  v.user                   = driver
  v.brand                  = "Renault"
  v.model                  = "Clio"
  v.color                  = "Gris"
  v.date_first_registration = Date.new(2019, 7, 1)
  v.electric               = false
end

puts "   Vehicles: #{Vehicle.count}"

# =============================================================================
# Trips — destroy the driver's existing trips for a clean reseed each run.
# Trips have no natural unique key, so destroy-and-recreate is the safest guard.
# =============================================================================
puts "== Seeding trips =="
Trip.where(driver_id: driver.id).destroy_all

now = Time.current

trips = Trip.create!([
  # -- Planned (future) --
  {
    driver: driver, vehicle: v_electric,
    start_city: "Paris",      end_city: "Lyon",
    start_time: now + 2.days, end_time: now + 2.days + 4.hours,
    price: 25, seats_available: 3, status: "planned"
  },
  {
    driver: driver, vehicle: v_electric,
    start_city: "Lyon",       end_city: "Marseille",
    start_time: now + 5.days, end_time: now + 5.days + 3.hours,
    price: 20, seats_available: 2, status: "planned"
  },
  {
    driver: driver, vehicle: v_thermal,
    start_city: "Paris",      end_city: "Bordeaux",
    start_time: now + 7.days, end_time: now + 7.days + 5.hours,
    price: 35, seats_available: 4, status: "planned"
  },
  # -- In progress (started, not yet finished) --
  {
    driver: driver, vehicle: v_electric,
    start_city: "Nantes",     end_city: "Paris",
    start_time: now - 1.hour, end_time: now + 3.hours,
    price: 30, seats_available: 1, status: "in_progress"
  },
  # -- Finished (past) — these two have reviews + bookings attached --
  {
    driver: driver, vehicle: v_thermal,
    start_city: "Toulouse",   end_city: "Montpellier",
    start_time: now - 3.days, end_time: now - 3.days + 2.hours,
    price: 15, seats_available: 2, status: "finished"
  },
  {
    driver: driver, vehicle: v_electric,
    start_city: "Strasbourg", end_city: "Paris",
    start_time: now - 7.days, end_time: now - 7.days + 4.hours,
    price: 28, seats_available: 3, status: "finished"
  }
])

puts "   Trips: #{Trip.count}"

# =============================================================================
# PassengerBookings — link user2 (passenger) to the two finished trips
# =============================================================================
puts "== Seeding passenger bookings =="
PassengerBooking.where(passenger_id: passenger.id).destroy_all

PassengerBooking.create!([
  { trip: trips[4], passenger: passenger, status: "confirmed" },
  { trip: trips[5], passenger: passenger, status: "confirmed" }
])

puts "   Bookings: #{PassengerBooking.count}"

# =============================================================================
# MongoDB Reviews — delete by (trip_id, passenger_id) then recreate
# =============================================================================
puts "== Seeding MongoDB reviews =="

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
  # Remove any existing review for this (trip, passenger) pair before recreating
  Review.where(trip_id: attrs[:trip_id], passenger_id: attrs[:passenger_id]).delete_all
  Review.create!(attrs)
end

puts "   Reviews: #{Review.count}"
puts "== Seed complete =="
