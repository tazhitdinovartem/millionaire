require 'rails_helper'

RSpec.feature 'USER viewing another players profile', type: :feature do
  user1 = FactoryBot.create(:user, name: 'user1', id: 1) 
  user2 = FactoryBot.create(:user, name: 'user2', id: 2) 

  FactoryBot.create(:game_with_questions, 
    user: user2, 
    current_level: 5, 
    prize: 250,
    created_at: Time.parse('2020-03-18 13:00')
  )
  FactoryBot.create(:game_with_questions, 
    user: user2, 
    current_level: 6, 
    prize: 3000, 
    created_at: Time.parse('2020-03-17 13:00'), 
    finished_at: Time.parse('2020-03-17 13:20'),
    is_failed: true
  )

  before(:each) do
    login_as user1
  end

  scenario 'successfully' do
    visit '/'
    click_link 'user2'

    expect(page).to have_current_path '/users/2'
    expect(page).to have_content 'user2'
    expect(page).to have_no_content 'Сменить имя и пароль'

    expect(page).to have_content '1'
    expect(page).to have_content 'в процессе'
    expect(page).to have_content '18 марта, 13:00'
    expect(page).to have_content '5'
    expect(page).to have_content '250'

    expect(page).to have_content '2'
    expect(page).to have_content 'проигрыш'
    expect(page).to have_content '17 марта, 13:00'
    expect(page).to have_content '6'
    expect(page).to have_content '3 000'
  end
end