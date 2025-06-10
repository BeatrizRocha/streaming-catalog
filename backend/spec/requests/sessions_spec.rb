# backend/spec/requests/sessions_spec.rb

require 'rails_helper'
require 'byebug'

RSpec.describe "Sessions", type: :request do
  before { host! 'localhost' } 
  describe "POST /login" do
    subject(:post_login) { post "/login", params: params, as: :json }

    let(:params) { { email: "user@example.com", password: "password123" } }

    context "with valid credentials" do
      let!(:user) { Fabricate(:user, email: "user@example.com", password: "password123", password_confirmation: "password123") }

      it "returns a 200 OK status and user data" do
        post_login
        expect(response).to have_http_status(:ok)
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['user']['name']).to eq(user.name)
      end
    end

    context "with invalid credentials" do
      let(:params) { { email: "user@example.com", password: "wrong_password" } }

      it "returns a 401 Unauthorized status and an error message" do
        post_login
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq("Invalid email or password")
      end
    end

    context "when user does not exist" do
      let(:params) { { email: "nonexistent@example.com", password: "anypassword" } }

      it "returns a 401 Unauthorized status" do
        post_login
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq("Invalid email or password")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end