require 'rails_helper.rb'

describe 'Testing friendship funcctionalities', type: :feature do
  before :each do
    @bender = User.create({ name: 'Bender',
                            email: 'bender@gmail.com',
                            password: '123456',
                            password_confirmation: '123456' })
    @fry = User.create({ name: 'Fry',
                            email: 'fry@gmail.com',
                            password: '123456',
                            password_confirmation: '123456' })
    @leela = User.create({ name: 'Leela',
                            email: 'leela@gmail.com',
                            password: '123456',
                            password_confirmation: '123456' })
    @friendship = Friendship.create!({ user_id: @bender.id,
                                       friend_id: @fry.id,
                                       confirmed: false })

    @post = Post.create!({ user_id: @bender.id,
                           content: 'Bender post' })
  end

  describe 'Create friend request' do
    before :each do
      visit 'users/sign_in'
      fill_in 'Email', with: 'bender@gmail.com'
      fill_in 'Password', with: '123456'
      click_button 'commit'
    end

    it 'only display button if the request was not sent' do 
      visit 'users/2'
      expect(page).not_to have_content 'Send friend request'
    end

    it 'display button if there is no previous invitation' do
      visit 'users/3'
      expect(page).to have_content 'Send friend request'
    end

    it 'view friends' do
      visit 'friendships'
      expect(page).to have_content 'Fry'
    end
  end
end
