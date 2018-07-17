# frozen_string_literal: true

# == Schema Information
#
# Table name: users_roles
#
#  id      :bigint(8)        not null, primary key
#  role_id :bigint(8)
#  user_id :bigint(8)
#
# Indexes
#
#  index_users_roles_on_role_id              (role_id)
#  index_users_roles_on_user_id              (user_id)
#  index_users_roles_on_user_id_and_role_id  (user_id,role_id)
#

# Implementation of a 'has many through' for Rolify.
# See: https://github.com/RolifyCommunity/rolify/issues/318
class UserRole < ApplicationRecord
  self.table_name = "users_roles"

  belongs_to :user
  belongs_to :role
end
