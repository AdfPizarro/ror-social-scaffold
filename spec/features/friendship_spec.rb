require_relative '../rails_helper.rb'

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
    @zoidberg = User.create({ name: 'Zoidberg',
                              email: 'zoid@gmail.com',
                              password: '123456',
                              password_confirmation: '123456' })
    @dr = User.create({ name: 'Fransworth',
                           email: 'dr@gmail.com',
                           password: '123456',
                           password_confirmation: '123456' })
    @friendship_to_delete = Friendship.create({ user_id: @dr.id,
                                      friend_id: @bender.id,
                                      confirmed: false })
    @friendship = Friendship.create({ user_id: @fry.id,
                                      friend_id: @bender.id,
                                      confirmed: true })
    @friendship_second_row = Friendship.create({ user_id: @bender.id,
                                      friend_id: @fry.id,
                                      confirmed: true })
    @post = Post.create!({ user_id: @bender.id, content: 'Bender post' })
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

    it 'create and view friend request' do
      visit 'users/3'
      click_link 'Send friend request'
      visit '/friendships'
      expect(page).to have_content 'Leela'
    end

    it 'reject friend request' do
      visit '/users'
      click_link 'Reject'
      expect(page).to have_content 'Friend list'
    end

    it 'create and accept friend request' do
      visit 'users/4'
      click_link 'Send friend request'
      visit '/'
      find(:xpath, '/html/body/nav/a[2]').click
      visit '/users/sign_in'
      fill_in 'Email', with: 'zoid@gmail.com'
      fill_in 'Password', with: '123456'
      click_button 'commit'
      visit '/users'
      click_link 'Accept'
      expect(page).to have_content 'Friendship confirmed'
    end
  end
end
