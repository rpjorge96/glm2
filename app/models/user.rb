# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#  role_id                :bigint
#
# Indexes
#
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#  index_users_on_username              (username) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :trackable, authentication_keys: [:username]

  belongs_to :role
  has_many :permissions, through: :role

  has_and_belongs_to_many :projects

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :role, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[username role_id name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[role]
  end

  def admin?
    role.name.downcase == "admin" || role.name.downcase == "vendedor"
  end

  def role_name
    role.name.downcase
  end

  def vendedor?
    role_name == "vendedor"
  end

  private

  def email_required?
    false
  end
end
