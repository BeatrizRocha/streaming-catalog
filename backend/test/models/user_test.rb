require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new # Tenta criar um novo usuário sem nenhum atributo
    assert_not user.save, "Saved the user without an email" # Espera que ele não salve
    assert user.errors[:email].any?, "No email error message" # Espera que haja um erro específico no campo email
  end

  test "should not save user with duplicate email" do
    User.create(name: "Test User 1", email: "test@example.com", password_digest: "some_password")

    # Tenta criar outro usuário com o mesmo email
    duplicate_user = User.new(name: "Test User 2", email: "test@example.com", password_digest: "another_password")

    assert_not duplicate_user.save, "Saved the user with a duplicate email"
    assert duplicate_user.errors[:email].any?, "No email error message for duplicate"
  end

  test "should not save local user without password digest" do
    user = User.new(name: "Test User", email: "test@example.com", provider: "local")
    assert_not user.save, "Saved the user without a password digest"
    assert user.errors[:password_digest].any?, "No password digest error message"
  end

  test "should not save user with invalid email format" do
    valid_user = User.create(name: "Valid User", email: "valid@example.com", password_digest: "password123", provider: "local")
    assert valid_user.persisted?, "Could not save valid user for format test"

    # Testes com formatos inválidos
    invalid_emails = %w[user@example,com user_at_example.org user.name@example. user@.com @example.com]
    invalid_emails.each do |email|
      user = User.new(name: "Invalid User", email: email, password_digest: "password123", provider: "local")
      assert_not user.save, "Saved user with invalid email format: #{email}"
      assert user.errors[:email].any?, "No email error message for invalid format: #{email}"
    end

    # Teste com email válido para garantir que não falha por engano
    valid_email_user = User.new(name: "Another Valid", email: "another@example.com", password_digest: "password123", provider: "local")
    assert valid_email_user.valid?, "Valid email user is invalid: #{valid_email_user.errors.full_messages.join(', ')}"
    assert valid_email_user.save, "Could not save user with valid email: #{valid_email_user.errors.full_messages.join(', ')}"

  end
end
