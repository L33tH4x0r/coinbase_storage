class Article < ApplicationRecord
  has_many :currencies
  has_many :votes
end
