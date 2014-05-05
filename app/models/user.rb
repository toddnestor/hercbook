class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    has_many :statuses

    validates :first_name, presence: true

    validates :last_name, presence: true

    validates :profile_name, presence: true,
                             uniqueness: true,
                             format: {
                                 with: /\A[a-zA-Z0-9_-]+\z/,
                                 message: "Must not contain any special characters besides underscore or dash."
                                 }



    def full_name
        first_name + " " + last_name
    end

    def gravatar_url
        "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
    end

end
