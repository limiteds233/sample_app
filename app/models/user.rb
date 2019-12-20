class User < ActiveRecord::Base
   class User < ActiveRecord::Base
    attr_accessor :remember_token, :activation_token
    before_save :downcase_email
    before_create :create_activation_digest

    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        validates :email, presence: true,
        format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }
        has_secure_password
        validates :password, length: { minimum: 6 }, allow_blank: true
        # Возвращает дайджест для указанной строки.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)

    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
       self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

 
    # Возвращает true, если указанный токен соответствует дайджесту.
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
 
    class << self
    def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    # Возвращает случайный токен.
    def new_token
        SecureRandom.urlsafe_base64
    end

    # Возвращает true, если указанный токен соответствует дайджесту.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    # Преобразует адрес электронной почты в нижний регистр.
    def downcase_email
        self.email = email.downcase
    end
    # Создает и присваивает токен активации и его дайджест.
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
end
end