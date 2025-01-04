require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:regular_admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password', role: :regular) }
  let(:super_admin) { FactoryBot.create(:admin, :super_admin, email: 'superadmin@example.com', password: 'password') }
  let(:artisan) { FactoryBot.create(:artisan, email: 'artisan@example.com', password: 'password') }

  describe 'GET #new' do
    it 'renders the login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid super_admin credentials' do
      it 'logs in the super_admin and redirects to their dashboard' do
        post :create, params: { email: super_admin.email, password: 'password' }
        expect(session[:user_email]).to eq(super_admin.email)
        expect(session[:role]).to eq('super_admin')
        expect(response).to redirect_to(dashboard_admin_path(super_admin.id))
      end
    end

    context 'with valid regular admin credentials' do
      it 'logs in the regular admin and redirects to their dashboard' do
        post :create, params: { email: regular_admin.email, password: 'password' }
        expect(session[:user_email]).to eq(regular_admin.email)
        expect(session[:role]).to eq('admin')
        expect(response).to redirect_to(dashboard_admin_path(regular_admin.id))
      end
    end

    context 'with valid artisan credentials' do
      it 'logs in the artisan and redirects to their dashboard' do
        post :create, params: { email: artisan.email, password: 'password' }
        expect(session[:user_email]).to eq(artisan.email)
        expect(session[:role]).to eq('artisan')
        expect(response).to redirect_to(dashboard_artisan_path(artisan.id))
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user and renders the login form with an error' do
        post :create, params: { email: 'wrong@example.com', password: 'wrongpassword' }
        expect(session[:user_email]).to be_nil
        expect(session[:role]).to be_nil
        expect(flash[:alert]).to eq('Invalid email or password. Please try again.')
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_email] = super_admin.email
      session[:role] = 'super_admin'
    end

    it 'logs out the super_admin and redirects to the root path' do
      delete :destroy
      expect(session[:user_email]).to be_nil
      expect(session[:role]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('You have logged out successfully.')
    end
  end
end
