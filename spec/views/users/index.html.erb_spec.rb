require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [
      FactoryBot.build_stubbed(:user, name: 'UserOne', balance: 5000),
      FactoryBot.build_stubbed(:user, name: 'UserTwo', balance: 3000),
    ])

    render
  end

  it 'renders player names' do
    expect(rendered).to match 'UserOne'
    expect(rendered).to match 'UserTwo'
  end

  # Этот сценарий проверяет, что шаблон выводит баланс
  it 'renders player balances' do
    expect(rendered).to match '5 000 ₽'
    expect(rendered).to match '3 000 ₽'
  end

  # Этот сценарий проверяет, что юзеры в нужном порядке
  it 'renders player names in right order' do
    expect(rendered).to match /UserOne.*UserTwo/m
  end
end