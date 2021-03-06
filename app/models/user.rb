class User < ActiveRecord::Base
    class User < ActiveRecord::Base
has_many :microposts, dependent: :destroy
has_many :active_relationships, class_name: "Relationship",
foreign_key: "follower_id",
dependent: :destroy
has_many :passive_relationships, class_name: "Relationship",
foreign_key: "followed_id",
dependent: :destroy
has_many :following, through: :active_relationships, source: :followed
has_many :followers, through: :passive_relationships, source: :follower

   class User < ActiveRecord::Base
    attr_accessor :remember_token, :activation_token, :reset_token
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
    .
# Активирует учетную запись.
    def activate
        update_columns(activated: FILL_IN, activated_at: FILL_IN)
    end
    # Посылает письмо со ссылкой на страницу активации.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
        # Устанавливает атрибуты для сброса пароля.
    def create_reset_digest
       self.reset_token = User.new_token
        update_columns(reset_digest: FILL_IN,
        reset_sent_at: FILL_IN)
    end

    # Посылает письмо со ссылкой на форму ввода нового пароля.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

# Определяет прото-ленту.
# Полная реализация приводится в разделе "Следование за пользователями".
    def feed
        following_ids = "SELECT followed_id FROM relationships
WHERE follower_id = :user_id"
Micropost.where("user_id IN (#{following_ids})
OR user_id = :user_id", user_id: id)
    end
    # Выполняет подписку на сообщения пользователя.
    def follow(other_user)
        active_relationships.create(followed_id: other_user.id)
    end
    # Отменяет подписку на сообщения пользователя.
    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end
    # Возвращает true, если текущий пользователь читает
    #другого пользователя.
    def following?(other_user)
        following.include?(other_user)
    end
    
    private
end
end
end