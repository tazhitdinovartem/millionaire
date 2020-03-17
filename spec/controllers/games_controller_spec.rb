require 'rails_helper'
require 'support/my_spec_helper'
RSpec.describe GamesController, type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  let(:game_w_questions) { FactoryBot.create(:game_with_questions, user: user) }

  context 'kicks from #help' do
    it 'fifty_fifty help type' do
      put :help, id: game_w_questions.id, help_type: :fifty_fifty

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'friend_call help type' do
      put :help, id: game_w_questions.id, help_type: :friend_call

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end

    it 'audience_help help type' do
      put :help, id: game_w_questions.id, help_type: :audience_help

      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to be
    end
  end

  it 'kicks from #create' do
    post :create

    expect(response.status).not_to eq(200)
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to be
  end

  it 'kicks from #answer' do
    put :answer, id: game_w_questions.id

    expect(response.status).not_to eq(200)
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to be
  end

  it 'kicks from #take_money' do
    put :take_money, id: game_w_questions.id

    expect(response.status).not_to eq(200)
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to be
  end

  it 'kicks from #show' do
    get :show, id: game_w_questions.id

    expect(response.status).not_to eq(200)
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to be
  end

  context 'Usual user' do

    before(:each) { sign_in user }

    it 'uses fifty fifty help' do
      expect(game_w_questions.current_game_question.help_hash[:fifty_fifty]).not_to be
      expect(game_w_questions.fifty_fifty_used).to be(false)

      put :help, id: game_w_questions.id, help_type: :fifty_fifty
      game = assigns(:game)

      expect(game.finished?).to be(false)
      expect(game.fifty_fifty_used).to be(true)
      expect(game.current_game_question.help_hash[:fifty_fifty]).to be
      fifty_fifty_result = game.current_game_question.help_hash[:fifty_fifty]
      expect(fifty_fifty_result).to include(game.current_game_question.correct_answer_key)
      expect(fifty_fifty_result.size).to eq(2)
      expect(response).to redirect_to(game_path(game))
    end

    it 'uses audience help' do
      expect(game_w_questions.current_game_question.help_hash[:audience_help]).not_to be
      expect(game_w_questions.audience_help_used).to be_falsey
    
      put :help, id: game_w_questions.id, help_type: :audience_help
      game = assigns(:game)
    
      expect(game.finished?).to be_falsey
      expect(game.audience_help_used).to be_truthy
      expect(game.current_game_question.help_hash[:audience_help]).to be
      expect(game.current_game_question.help_hash[:audience_help].keys).to contain_exactly('a', 'b', 'c', 'd')
      expect(response).to redirect_to(game_path(game))
    end

    it 'user takes money user takes money until the end of the game' do
      game_w_questions.update_attribute(:current_level, 2)

      put :take_money, id: game_w_questions.id
      game = assigns(:game)
      expect(game.finished?).to be(true)
      expect(game.prize).to eq(200)

      user.reload
      expect(user.balance).to eq(200)

      expect(response).to redirect_to(user_path(user))
      expect(flash[:warning]).to be
    end

    it 'user cannot start two games' do
      expect(game_w_questions.finished?).to be_falsey
      expect { post :create }.to change(Game, :count).by(0)

      game = assigns(:game)
      expect(game).to be_nil

      expect(response).to redirect_to(game_path(game_w_questions))
      expect(flash[:alert]).to be
    end

    it 'user cant #show another game' do
      another_game = FactoryBot.create(:game_with_questions)

      get :show, id: another_game.id
  
      expect(response.status).not_to eq(200)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be
    end

    it 'creates game' do
      generate_questions(15)
  
      post :create
      game = assigns(:game)
  
      expect(game.finished?).to be_falsey
      expect(game.user).to eq(user)
      expect(response).to redirect_to(game_path(game))
      expect(flash[:notice]).to be
    end

    it '#show game' do
      get :show, id: game_w_questions.id
      game = assigns(:game)
      expect(game.finished?).to be_falsey
      expect(game.user).to eq(user)
    
      expect(response.status).to eq(200)
      expect(response).to render_template('show')
    end

    it 'wrong player answer' do
      wrong_letter = %w[a b c d].reject { |n| n == game_w_questions.current_game_question.correct_answer_key }.sample
      put :answer, id: game_w_questions.id, letter: wrong_letter

      game = assigns(:game)

      expect(game.finished?).to be(true)
      expect(game.status).to be(:fail)
      expect(response).to redirect_to(user_path(user))
      expect(flash[:alert]).to be
    end

    it 'answers correct' do
      put :answer, id: game_w_questions.id, letter: game_w_questions.current_game_question.correct_answer_key
      game = assigns(:game)
    
      expect(game.finished?).to be_falsey
      expect(game.current_level).to be > 0
    
      expect(response).to redirect_to(game_path(game))
      expect(flash.empty?).to be_truthy
    end
  end
end
