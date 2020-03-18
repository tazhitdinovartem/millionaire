require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    user = assign(:user, FactoryBot.create(:user, name: 'UserForTest'))
    game = assign(:games, [FactoryBot.create(:game_with_questions)])
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