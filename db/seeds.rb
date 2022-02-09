# frozen_string_literal: true

User.destroy_all

User.create(
  email: 'john@doe.com',
  name: 'John Doe',
  password: '123123'
)
