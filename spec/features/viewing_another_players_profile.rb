require 'rails_helper'

RSpec.feature 'USER viewing another players profile', type: :feature do
  let(:user_first) { FactoryBot.create(:user, name: 'user_first') } 
  let(:user_second) { FactoryBot.create(:user, name: 'user_second') } 

  let!(:game_one) { FactoryBot.create(:game_with_questions,
    id: 13,
    user: user_second, 
    current_level: 1, 
    prize: 250,
    created_at: Time.parse('2020-01-01 8:00')
  )}
  let!(:game_two) { FactoryBot.create(:game_with_questions,
    id: 14,
    user: user_second, 
    current_level: 6, 
    prize: 3000, 
    created_at: Time.parse('2020-03-17 13:00'), 
    finished_at: Time.parse('2020-03-17 13:20'),
    is_failed: true
  )}

  before(:each) do
    login_as user_first
  end

  scenario 'successfully' do
    visit '/'
    click_link 'user_second'

    expect(page).to have_current_path "/users/#{user_second.id}"
    expect(page).to have_content 'user_second'
    expect(page).to have_no_content 'Сменить имя и пароль'

    expect(page).to have_content '13'
    expect(page).to have_content 'в процессе'
    expect(page).to have_content '01 янв., 08:00'
    expect(page).to have_content '1'
    expect(page).to have_content '250'

    expect(page).to have_content '14'
    expect(page).to have_content 'проигрыш'
    expect(page).to have_content '17 марта, 13:00'
    expect(page).to have_content '6'
    expect(page).to have_content '3 000'
  end
end