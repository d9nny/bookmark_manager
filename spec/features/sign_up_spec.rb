require 'spec_helper'

feature 'User sign up with matching password' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, me@me.com')
    expect(User.first.email).to eq('me@me.com')
  end

  scenario 'User signup with non matching password' do
    expect {sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end
end

feature 'User Signup' do
  scenario 'User cannot signup with blank email address' do
    expect { sign_up(email: nil) }.not_to change(User, :count)
  end

  scenario 'User cannot signup with invalid email address' do
    expect { sign_up(email: "invalid@email")}.not_to change(User, :count)
  end

  scenario 'User cannot sign up with an already registered email' do
    sign_up
    expect {sign_up}.not_to change(User, :count)
  end
end