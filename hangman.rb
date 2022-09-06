require 'yaml'

class Game

    def initialize
        @solve_word = choose_word()
        @letters_guessed = []
        @guesses_remaining = 6
        @current_puzzle = Array.new(@solve_word.length, '_')
        @player = Player.new
        @game_id = get_counter()
        puts "Current puzzle is #{@current_puzzle.join}"
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
        puts "You have #{@guesses_remaining} guesses remaining"
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
            play_turn()
        when 'load'
            load()
            display()
            play_turn()
        when 'new' then new_game?()
        when 'a'..'z' 
            if letter.length === 1
                letter
            else play_turn()
            end
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
            puts "THE WORD WAS #{@solve_word}"
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
        unless Dir.exists?("saved_games")
            Dir.mkdir("saved_games")
        end
        unless File.exist?("saved_games/#{@game_id}")
            increment_counter()
        end
        File.write("./saved_games/#{@game_id}", data)
        puts "GAME PROGRESS SAVED SUCCESSFULLY AS GAME #{@game_id}"
    end

    def load()
        files = Dir.children("saved_games")
        puts "Please enter a game id to load a saved game"
        puts files
        game_to_load = gets.chomp
        if game_to_load.to_s in files
            data = YAML.load(File.read("./saved_games/#{game_to_load}"))
            @solve_word = data[:solve_word]
            @letters_guessed = data[:letters_guessed]
            @guesses_remaining = data[:guesses_remaining]
            @current_puzzle = data[:current_puzzle]
            @game_id = data[:game_id]
            puts "SUCCESSFULLY LOADED GAME #{@game_id}"
        else play_turn()
        end
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

    def get_counter
        if Dir.exists?("game_counter")
            file = File.open("./game_counter/counter")
            file.read
        else Dir.mkdir("game_counter")
            File.write("./game_counter/counter", 1)
            1
        end
    end

    def increment_counter
        file = File.open("./game_counter/counter", "r+")
        counter = file.read
        counter = counter.to_i + 1
        file.seek(0)
        file.write(counter)
        file.close
        counter
    end

end

class Player

    def guess_letter
        puts "Input a letter to guess. You may also input 'save', 'load', or 'new'."
        letter = gets.chomp.downcase
    end

end

game = Game.new
game.play_turn