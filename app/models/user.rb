# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :books, dependent: :destroy

  SOME_VAR = 'test'

  def some_test
    a = 12
    b = 7
  end
end
