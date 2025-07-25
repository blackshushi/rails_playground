class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true

  broadcasts_to :room
  after_create_commit -> { Rails.logger.info "Broadcasting message to: #{room.to_gid_param}"}
end
