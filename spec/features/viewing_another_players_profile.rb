require 'rails_helper'

RSpec.feature 'USER viewing another players profile', type: :feature do
  
  before(:each) do
    user1 = FactoryBot.create :user, name: 'user1', id: 1
    user2 = FactoryBot.create :user, name: 'user2', id: 2
    FactoryBot.create(:game_with_questions, user: user2, current_level: 5, prize: 250, finished_at: Time.now)
    FactoryBot.create(:game_with_questions, user: user2, current_level: 3, prize: 3000, finished_at: Time.now)
    login_as user1
  end

  scenario 'successfully' do
    visit '/users/2'

    expect(page).to have_current_path '/users/2'
    expect(page).to have_content 'user2'
    expect(page).to have_content '250'
    expect(page).to have_content 'Вопрос'
    expect(page).to have_no_content 'Сменить имя и пароль'
    
    save_and_open_page
  end
end