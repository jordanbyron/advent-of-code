require_relative '../advent'

module PasswordValidator
  LETTERS = ('a'..'z').to_a

  extend self

  def valid?(password)
    does_not_contain_confusing_letters(password) &&
    increasing_straight_of_three(password) &&
    has_two_different_letter_pairs(password)
  end

  private

  def does_not_contain_confusing_letters(password)
    !(password =~ /[iol]/)
  end

  def has_two_different_letter_pairs(password)
    password.chars.
      chunk {|c| c }.
      select { |_, instances| instances.length >= 2 }.
      map {|letter, _| letter }.
      uniq.
      count >= 2
  end

  def increasing_straight_of_three(password)
    regex = /(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)/

    !!(password =~ regex)
  end
end

IncrementPassword = ->(password) {
  password = password.next

  until(PasswordValidator.valid?(password))
    password = password.next
  end

  password
}

describe PasswordValidator do
  it 'fails passwords with confusing letters' do
    base_password = 'aabb'

    %w[i o l].each do |letter|
      PasswordValidator.valid?(base_password + letter).must_equal false
    end
  end

  it 'fails passwords without 2 letter pairs' do
    PasswordValidator.valid?('abbcegjk').must_equal false
  end

  it 'fails passwords without increasing straight values' do
    PasswordValidator.valid?('abbceffg').must_equal false
    PasswordValidator.valid?('ghjaaazz').must_equal false
  end

  it 'passes good passwords' do
    PasswordValidator.valid?('abcdffaa').must_equal true
  end
end

describe 'IncrementPassword' do
  it 'skips invalid passwords' do
    IncrementPassword['abcdefgh'].must_equal 'abcdffaa'
    IncrementPassword['ghijklmn'].must_equal 'ghjaabcc'
  end
end

puts IncrementPassword['vzbxkghb']
