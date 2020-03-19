require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  context 'user watches another users profile' do
    before(:each) do
      assign(:user, FactoryBot.create(:user, name: 'UserForTest'))
      assign(:games, [FactoryBot.create(:game_with_questions)])
      
      render
    end

    it 'renders user name' do
      expect(rendered).to match 'UserForTest'
    end

    it 'does not renders edit-password button only for current user' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end

    it 'renders users games table' do
      render_template partial: 'users/_game'
    end
  end

  context 'user watches his own profile' do
    before(:each) do
      user = assign(:user, FactoryBot.create(:user, name: 'UserForTest'))
      assign(:games, [FactoryBot.create(:game_with_questions)])
      sign_in user

      render
    end

    it 'renders user name' do
      expect(rendered).to match 'UserForTest'
    end

    it 'renders edit-password button only for current user' do
      expect(rendered).to match 'Сменить имя и пароль'
    end

    it 'renders users games table' do
      render_template partial: 'users/_game'
    end
  end
end