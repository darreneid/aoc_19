require_relative '../day_five/computer.rb'

class Game
    attr_accessor :board, :score, :input

    def initialize
        @board = Array.new(25) {Array.new(30, nil)}
        @score = 0
        @input = []
    end

    def receive_output(num)
        self.input += [num]
        return if input.length != 3

        if input[0] == -1 && input[1] == 0
            self.score = input[2]
        else
            x, y, tile_id = input

            case tile_id
            when 0
                tile = nil
            when 1
                tile = 'wall'
            when 2
                tile = 'block'
            when 3
                tile = 'paddle'
            when 4
                tile = 'ball'
            end

            self.board[y][x] = tile
        end

        self.input = []
    end

    def get_input
        display
        res = locate_ball <=> locate_paddle
    end

    def locate_ball
        board.each_with_index do |row, y|
            row.each_with_index do |el, x|
                return x if el == 'ball'
            end
        end
        nil
    end

    def locate_paddle
        board.each_with_index do |row, y|
            row.each_with_index do |el, x|
                return x if el == 'paddle'
            end
        end
        nil
    end

    def display
        system "clear"

        board.each do |row|
            row.each do |el|
                case el
                when 'wall'
                    sym = 'X'
                when 'block'
                    sym = 'm'
                when 'paddle'
                    sym = '_'
                when 'ball'
                    sym = 'o'
                else
                    sym = ' '
                end

                print sym
            end
            puts
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    game = Game.new
    comp = IntcodeComp.new('input.txt', game)
    comp.run
    puts "Final Score: #{game.score}"
end