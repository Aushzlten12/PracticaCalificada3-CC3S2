# Create my own ApplicationError hierarchy

class ApplicationError < StandardError; end

class ValidationError < ApplicationError; end
class InvalidGuessError < ValidationError; end

class ResponseError < ApplicationError; end
class FetchRandomWordError < ResponseError; end

class WordGuesserGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    if letter.nil? || letter !~ /\A[a-zA-Z]\Z/i # match single letter,ignoring case
      raise InvalidGuessError
    end
    letter = letter[0].downcase
    if  @word.include?(letter) && !@guesses.include?(letter)
      @guesses += letter
    elsif !@word.include?(letter) && !@wrong_guesses.include?(letter)
      @wrong_guesses += letter
    else
      false
    end
  end

  def word_with_guesses
    @word.gsub(/./)  { |letter| @guesses.include?(letter) ? letter : '-' }
  end

  def check_win_or_lose
    return :play if @word.blank?

    if word_with_guesses == @word
      :win
    elsif @wrong_guesses.length > 6
      :lose
    else
      :play
    end
  end

  # Get a word from remote "random word" service

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    begin
      Net::HTTP.post_form(uri ,{}).body
    rescue StandardError => e
      raise FetchRandomWordError, 'Error fetching random word'
    end
  end

end
