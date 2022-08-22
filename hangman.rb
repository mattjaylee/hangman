class Game

    def load_dictionary
        dictionary = File.read("dictionary.txt").split
        solve_word = dictionary[rand(dictionary.length)]
        puts solve_word
    end

end
