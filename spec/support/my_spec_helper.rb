module MySpecHelper
  # Метод нужное число раз дёрнет factory_Bot
  # и создаст новый объект вопроса в базе
  def generate_questions(number)
    number.times do
      FactoryBot.create(:question)
    end
  end
end

# Это строка для подключения метода к тестам
RSpec.configure do |c|
  c.include MySpecHelper
end

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end