require 'yaml'

class Game

    attr_accessor :solve_word, :letters_guessed, :guesses_remaining, :current_puzzle, :game_id

    @@game_counter = 0

    def initialize
        @@game_counter += 1
        @solve_word = choose_word()
        @letters_guessed = []
        @guesses_remaining = 6
        @current_puzzle = Array.new(@solve_word.length, '_')
        @game_id = @@game_counter
        @player = Player.new
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
        puts "The current puzzle is #{@current_puzzle.join}." 
        puts "You have guessed #{@letters_guessed}."
        puts "You have #{@guesses_remaining} guesses remaining #{solve_word} game id #{@game_id}"
    end

    def play_turn
        letter = @player.guess_letter
        check_letter(letter)
        check_guess(@solve_word, letter)
        play_turn()
    end

    def check_letter(letter)
        case letter
        when 'save' 
            save()
            puts "GAME PROGRESS SAVED SUCCESSFULLY AS GAME #{game_id}"
            play_turn()
        when 'load' then load()
        when 'a'..'z' then letter
        else play_turn()
        end
    end

    def check_guess(solve_word, guess_letter)
        play_turn() if @letters_guessed.include?(guess_letter)
        solve_word.each_char.with_index do |letter, index|
            if letter == guess_letter
                @current_puzzle[index] = guess_letter
            end
        end
        @letters_guessed.push(guess_letter)
        @guesses_remaining -= 1 unless solve_word.include?(guess_letter) 
        display()
        check_win_or_lose(@current_puzzle, solve_word, @guesses_remaining)
    end

    def check_win_or_lose(current_puzzle, solve_word, guesses_remaining)
        if current_puzzle.join == solve_word
            puts "YOU CORRECTLY SOLVED THE PUZZLE"
            new_game?()
        elsif guesses_remaining === 0
            puts "YOU DID NOT SOLVE THE PUZZLE IN THE ALOTTED GUESSES"
            new_game?()
        end
    end

    def save
        data = YAML.dump ({
            :solve_word => @solve_word,
            :letters_guessed => @letters_guessed,
            :guesses_remaining => @guesses_remaining,
            :current_puzzle => @current_puzzle,
            :game_id => @game_id
        })
        if Dir.exists?("saved_games")
            File.write("./saved_games/#{game_id}", data)
        else
            Dir.mkdir("saved_games")
            File.write("./saved_games/#{game_id}", data)
        end
    end

    def load(save_file)
        data = YAML.load save_file
        @solve_word = data[:solve_word]
        @letters_guessed = data[:letters_guessed]
        @guesses_remaining = data[:guesses_remaining]
        @current_puzzle = data[:current_puzzle]
        @game_id = data[:game_id]
        p @solve_word, @letters_guessed, @guesses_remaining, @current_puzzle, @game_id
    end

    def new_game?
        puts "Would you like a play a new game? Y/N"
        letter = gets.chomp.downcase
        if letter === 'y'
            game = Game.new
            game.play_turn
        elsif letter === 'n'
            exit
        else
            new_game?()
        end
    end

end

class Player

    def guess_letter
        puts "Please input a letter to guess. You may also input 'save' or 'load'"
        letter = gets.chomp.downcase
    end

end

# game = Game.new
# game2 = Game.new
# player = Player.new
# game2.check_guess(game2.solve_word, player.guess_letter)
# save = game2.save
# game2.load(save)

game = Game.new
game.play_turn