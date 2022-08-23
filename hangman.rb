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

    end

end
