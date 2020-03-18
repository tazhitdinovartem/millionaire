require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    user = assign(:user, FactoryBot.create(:user, name: 'UserForTest'))
    sign_in user
    stub_template 'users/_game.html.erb' => 'Test text'
    render
  end

  it 'renders user name' do
    expect(rendered).to match 'UserForTest'
  end

  it 'renders edit-password button only for current user' do
    expect(rendered).to match 'Сменить имя и пароль'
  end

  it 'renders users games' do
    expect(rendered).to have_content 'Test text'
  end
end