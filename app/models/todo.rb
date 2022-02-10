# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :user
  validates :title, presence: { message: "Can't be blank" }
end
