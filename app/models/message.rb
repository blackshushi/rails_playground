class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true

  broadcasts_to :room
end
