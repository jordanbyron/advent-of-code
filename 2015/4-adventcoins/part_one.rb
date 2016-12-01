require_relative '../advent'
require 'digest'

Miner = ->(key) {
  answer = 0
  answer_found = false

  until(answer_found) do
    digest = Digest::MD5.hexdigest("#{key}#{answer}")

    if digest[/\A000000/]
      answer_found = true
      break
    end

    answer += 1
  end

  answer
}

binding.pry
