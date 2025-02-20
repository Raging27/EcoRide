require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test@example.com",
      pseudo: "TestUser",
      credits: 20,
      role: "driver"
    )
  end

  test "should save user with a complex password" do
    @user.password = "Complex#1"
    @user.password_confirmation = "Complex#1"
    assert @user.valid?, "User should be valid with a complex password"
  end

  test "should not save user with a simple password" do
    @user.password = "simple"
    @user.password_confirmation = "simple"
    assert_not @user.valid?, "User should be invalid with a simple password"
    assert_includes @user.errors[:password], "must include at least one uppercase letter, one lowercase letter, one digit, and one special character, and be at least 8 characters long"
  end

  test "should not require password validation if not changing password on existing user" do
    @user.password = "Complex#1"
    @user.password_confirmation = "Complex#1"
    @user.save!

    @user.pseudo = "UpdatedUser"
    assert @user.update(pseudo: "UpdatedUser"), "Should update user without validating password again"
  end
end
