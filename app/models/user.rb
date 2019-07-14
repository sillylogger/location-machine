class User < ApplicationRecord

  ROLES = {
    admin: 'Admin',
    partner: 'Partner'
  }

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_paper_trail

  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :registerable, :lockable,  # TODO: :confirmable once email is setup
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :locations
  has_many :identities

  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s), allow_blank: true }

  validates_presence_of :name

  # From an old article about multiple identities:
  # https://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
  # *cough* yagni *cough*
  def self.find_for_oauth auth, signed_in_resource = nil

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided then we don't lookup by email and we don't skip confirmation.
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email.present? &&
                         (auth.info.verified || auth.info.verified_email)

      # TODO: confirmation should be turned back on at some point
      # at which point then you can have 2 places to store an email (email & unconfirmed_email)...
      # then what to do when you have a verified email for ABC and an unverified email for ABC that then confirms?!
      # let's deal with that in the future, for now trust Facebook / Google's email

      # if email_is_verified
        user = User.where(email: auth.info.email).first
      # end

      # Create the user if none was found
      if user.nil?
        user = User.new(
          name: auth.info.name,
          email: auth.info.email || "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          avatar_url: auth.info.image
        )

        # TODO: confirmation should be turned back on at some point
        # We can trust the provider's verification
        # user.skip_confirmation! unless email_is_verified

        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end

  def prompt_additional_information?
    return true if name.blank? ||
                  (email.blank? && unconfirmed_email.blank?) ||
                   phone.blank?
    false
  end

  def admin?
    role? && role == ROLES.fetch(:admin)
  end

  def partner?
    role? && role == ROLES.fetch(:partner)
  end

  def can_view_admin?
    admin? || partner?
  end

  def facebook_identity
    identities.facebook.first
  end

  def is_facebook_user?
    facebook_identity.present?
  end
end
