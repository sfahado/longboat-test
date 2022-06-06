# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'post #login action, when user password is not correct' do
    before do
      user = FactoryBot.create(:user)
      @response = post :login, params: { user: {
        username: user.username, password: 'password'
      } }
      @response
    end

    it 'has a 200 status code' do
      expect(response.code).to eq '200'
    end

    it 'has a success status' do
      expect(response).to have_http_status(:success)
    end

    it 'has a content type => text/javascript in response' do
      expect(response.header['Content-Type']).to eq 'text/html; charset=utf-8'
    end

    it 'has success response' do
      expect(response).to be_successful
    end

    it 'check the body of the request' do
      expect(response.body).to be_empty
    end

    it 'valid User and save in database' do
      expect(assigns[:user]).to be_an_instance_of User
      expect(assigns[:user].persisted?).to eq true
    end

    it 'valid user and return success on wrong password' do
      expect(@response).to have_http_status(200)
      expect(flash[:notice]).not_to be_present
    end

    it 'Invalid password but right username' do
      user1 = assigns[:user]
      expect(user1.errors.full_messages.to_sentence).to include('Password attempt failed')
      expect(user1.errors.full_messages.to_sentence).not_to include('is invalid')
      expect(user1).to be_valid
      expect(user1.locked).to be_falsey
      expect(user1.failed).to eq 1
    end
  end

  describe 'post #login action, when user username and password is not correct' do
    before do
      @response = post :login, params: { user: {
        username: 'killMeNow', password: 'Password'
      } }
      @response
    end

    it 'renders the new view' do
      expect(response).to render_template(:new)
    end

    it 'invalid User and dont save in database' do
      expect(assigns[:user]).to be_an_instance_of User
      expect(assigns[:user].persisted?).to eq false
    end

    it 'invalid user and return success on wrong password' do
      expect(@response).to have_http_status(200)
      expect(flash[:notice]).not_to be_present
    end

    it 'Invalid password but right username' do
      user1 = assigns[:user]
      expect(user1.errors.full_messages.to_sentence).not_to include('Password attempt failed')
      expect(user1.errors.full_messages.to_sentence).to include('is invalid')
      expect(user1).not_to be_valid
      expect(user1.locked).to be_falsey
      expect(user1.failed).to eq 0
    end
  end

  describe 'post #login action, when user username and password is correct' do
    before do
      user = FactoryBot.create(:user)
      @response = post :login, params: { user: {
        username: user.username, password: user.password
      } }
      @response
    end

    it 'does not renders the new view' do
      expect(response).not_to render_template(:new)
    end

    it 'renders the welcome view' do
      expect(response).to redirect_to welcome_path
    end

    it 'valid User and saved in database' do
      expect(assigns[:user]).to be_an_instance_of User
      expect(assigns[:user].persisted?).to eq true
    end

    it 'save the session of the user' do
      expect(session[:user_id]).not_to be_nil
    end

    it 'valid password but right username, donot show any error' do
      user1 = assigns[:user]
      expect(user1.errors.full_messages.to_sentence).not_to include('Password attempt failed')
      expect(user1.errors.full_messages.to_sentence).not_to include('is invalid')
      expect(user1.locked).to be_falsey
      expect(user1.failed).to eq 0
    end
  end
  context 'when user logout' do
    before do
      user = FactoryBot.create(:user)
      @response = delete :logout, params: { id: user.id }
    end
    it 'check the body of the request' do
      expect(response.body).not_to be_empty
    end

    it 'destroys user session' do
      expect(session[:user_id]).to be_nil
    end

    it 'renders the welcome view' do
      expect(response).to redirect_to login_path
    end
  end
end
