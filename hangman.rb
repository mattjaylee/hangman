require 'yaml'

class Game

    attr_accessor :solve_word, :letters_guessed, :guesses_remaining, :current_puzzle

    def initialize
        @solve_word = choose_word()
        @letters_guessed = []
        @guesses_remaining = 6
        @current_puzzle = Array.new(@solve_word.length, '_')
    end

    def load_dictionary
        dictionary = File.read("dictionary.txt").split
        solve_word = dictionary[rand(dictionary.length)]
    end

    def choose_word
        solve_word = load_dictionary()
        if solve_word.length > 4 && solve_word.length < 13
            solve_word
        else
            choose_word()
        end
    end

    def display
        puts "The current puzzle is #{@current_puzzle.join}. You have guessed #{@letters_guessed}. You have #{@guesses_remaining} guesses remaining #{solve_word}"
    end

    def check_guess(solve_word, guess_letter)
        solve_word.each_char.with_index do |letter, index|
            if letter == guess_letter
                @current_puzzle[index] = guess_letter
            end
        end
        @letters_guessed.push(guess_letter)
        @guesses_remaining -= 1
        display()
    end

end

class Player

    def guess_letter
        puts "Please input a letter to guess. You may also input 'save' or 'load'"
        letter = gets.chomp.downcase
    end

end

game = Game.new
player = Player.new
game.check_guess(game.solve_word, player.guess_letter)