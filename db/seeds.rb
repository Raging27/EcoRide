# db/seeds.rb

# Create Admin User
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.pseudo = "Admin User"
  user.credits = 20
  user.role = "admin"
  user.is_chauffeur = false
end

# Create Employee User
User.find_or_create_by!(email: "employee@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.pseudo = "Employee User"
  user.credits = 20
  user.role = "employee"
  user.is_chauffeur = false
end

# Optionally, add more users if needed
User.find_or_create_by!(email: "user1@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.pseudo = "User One"
  user.credits = 20
  user.role = "driver"
  user.is_chauffeur = false
end

User.find_or_create_by!(email: "user2@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.pseudo = "User Two"
  user.credits = 20
  user.role = "passenger"
  user.is_chauffeur = false
end
