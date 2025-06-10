# backend/spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  context '#validations' do
    context 'email presence' do
      context 'when email is nil' do
        let(:user) { Fabricate.build(:user, email: nil) }
        it 'is invalid' do
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include("can't be blank")
        end
      end

      context 'when email is present' do
        let(:user) { Fabricate.build(:user) }
        it 'is valid' do
          expect(user).to be_valid
        end
      end
    end

    context 'email uniqueness' do
        before { Fabricate(:user, email: 'unique@example.com') }
        context "when email exists" do
          let(:user) { Fabricate.build(:user, email: 'unique@example.com') }
          it 'is invalid' do
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include("has already been taken")
          end
        end

        context "when email does not exist" do
          let(:user) { Fabricate.build(:user) }
          it 'is valid' do
            expect(user).to be_valid
          end
        end
    end

    context 'email format' do
      context 'with invalid formats' do
        %w[
          user@example,com 
          user_at_example.org 
          user.name@example. 
          user@.com 
          @example.com
          invalid-email
        ].each do |invalid_email|
          it "rejects #{invalid_email}" do
            user = Fabricate.build(:user, email: invalid_email)
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include("is invalid")
          end
        end
      end
    
      context 'with valid formats' do
        %w[
          user@example.com
          USER@example.COM
          A_US-ER@example.org
          first.last@example.net
          user+tag@example.co.uk
        ].each do |valid_email|
          it "accepts #{valid_email}" do
            user = Fabricate.build(:user, email: valid_email)
            expect(user).to be_valid
          end
        end
      end
    end

    context 'password_digest presence' do
      context 'when provider is local' do
        context 'with password_digest' do
          let(:user) { Fabricate.build(:user) }
    
          it 'is valid' do
            expect(user).to be_valid
          end
        end
    
        context 'without password_digest' do
          let(:user) { Fabricate.build(:user_without_password_digest) }

          it 'is invalid' do
            expect(user).not_to be_valid
            expect(user.errors[:password]).to include("can't be blank")
          end
        end
      end
    
      context 'when provider is not local' do
        let(:oauth_user) { Fabricate.build(:user_with_diferent_provider) }
        it 'does not require password_digest' do
          expect(oauth_user).to be_valid
        end
      end
    end

    context 'uid presence' do
      context 'when provider is local' do
        let(:user) { Fabricate.build(:user, uid: "example_uid") }

        it 'is invalid' do
          expect(user).not_to be_valid
          expect(user.errors[:uid]).to include("must be blank")
        end
      end

      context 'when provider is not local' do
        let(:oauth_user) { Fabricate.build(:user_with_diferent_provider) }
        it 'is valid' do
          expect(oauth_user).to be_valid
        end
      end
    end

    context 'password hashing and authentication' do
      let(:user_with_password) { Fabricate.build(:user, password: 'mysecretpassword', provider: 'local', uid: nil) }
      it 'should generate a password_digest when setting password' do
        expect(user_with_password.password_digest).not_to be_nil
        expect(user_with_password.password_digest).not_to eq('mysecretpassword')
      end

      it 'should not authenticate with an incorrect password' do
        user_with_password.save!
        expect(user_with_password.authenticate('wrongpassword')).to be_falsey
      end
      context 'when user has no password (e.g., OAuth user)' do
        let(:oauth_user_without_password) { Fabricate.build(:user, provider: 'google', uid: 'google123', password_digest: nil) }
  
        it 'should not authenticate' do
          expect(oauth_user_without_password.authenticate('anypassword')).to be_falsey
        end
      end
    end

  end

  context '#find_or_create_from_oauth' do
    let(:auth_hash_new_user) do
      {
        'provider' => 'google',
        'uid' => '12345',
        'info' => {
          'email' => 'new_oauth_user@example.com',
          'name' => 'New OAuth User'
        }
      }
    end
    let(:auth_hash_existing_user) do
      {
        'provider' => 'github',
        'uid' => '98765',
        'info' => {
          'email' => 'existing_oauth_user@example.com',
          'name' => 'Existing OAuth User'
        }
      }
    end

    context 'when user does not exist' do
      it 'should create a new user with correct attributes' do
        expect {
          @created_user = User.find_or_create_from_oauth(auth_hash_new_user)
        }.to change(User, :count).by(1)

        # Verifica os atributos do usuário criado
        expect(@created_user.provider).to eq('google')
        expect(@created_user.uid).to eq('12345')
        expect(@created_user.email).to eq('new_oauth_user@example.com')
        expect(@created_user.name).to eq('New OAuth User')
        expect(@created_user.password_digest).to be_nil # Usuários OAuth não têm password_digest
      end
    end

    context 'when user already exists' do
      let!(:existing_persisted_user) do
        Fabricate(:user,
                  provider: auth_hash_existing_user['provider'],
                  uid: auth_hash_existing_user['uid'],
                  email: auth_hash_existing_user['info']['email'],
                  name: auth_hash_existing_user['info']['name'],
                  password_digest: nil,
                  password: nil)
      end

      it 'should return the existing user without creating a new one' do
        expect {
          @found_user = User.find_or_create_from_oauth(auth_hash_existing_user)
        }.to_not change(User, :count)

        expect(@found_user).to eq(existing_persisted_user)
      end
    end

    context 'provider and uid uniqueness' do
      context 'when provider and uid already exist' do
        let!(:existing_persisted_user) do
          Fabricate(:user,
                    provider: auth_hash_existing_user['provider'],
                    uid: auth_hash_existing_user['uid'],
                    email: auth_hash_existing_user['info']['email'],
                    name: auth_hash_existing_user['info']['name'],
                    password_digest: nil,
                    password: nil)
        end
  
        it 'should not allow duplicate provider and uid' do
          expect {
            User.find_or_create_from_oauth(auth_hash_existing_user)
          }.to_not change(User, :count)
        end
      end
      context 'when provider and uid do not exist' do
        let(:new_user) do
          Fabricate(:user,
                    provider: auth_hash_new_user['provider'],
                    uid: auth_hash_new_user['uid'],
                    email: auth_hash_new_user['info']['email'],
                    name: auth_hash_new_user['info']['name'],
                    password_digest: nil,
                    password: nil)
        end

        it 'should create a new user' do
          expect {
            User.find_or_create_from_oauth(auth_hash_new_user)
          }.to change(User, :count).by(1)
        end
      end
    end

  end
end