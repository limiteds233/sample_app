ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
#require "minitest/reporters"
#Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  class ActiveSupport::TestCase
    fixtures :all
# Возвращает true, если тестовый пользователь вошел.
    def is_logged_in?
    !session[:user_id].nil?
    end

    # Выполняет вход тестового пользователя.
    def log_in_as(user, options = {})
        password = options[:password] || 'password'
        remember_me = options[:remember_me] || '1'

        if integration_test?
        post login_path, session: { email: user.email,
        password: password,
        remember_me: remember_me }
        else
    session[:user_id] = user.id
        end
    end

    private
# Возвращает true внутри интеграционного теста.
    def integration_test?
    defined?(post_via_redirect)
    end
end
end

  # Add more helper methods to be used by all tests here...

