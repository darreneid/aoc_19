require_relative '../day_five/computer.rb'
require 'byebug'

class Robot
    attr_reader :moves
    attr_accessor :pos, :delta, :oxy, :grid

    def initialize
        @grid = Array.new(43) {Array.new(43, "?")}
        @pos = [22,22]
        @delta = [0,0]
        @moves = 0
        @oxy = []

        @grid[pos[1]][pos[0]] = "B"
    end

    def get_input
        options = potential_moves(pos)
        
        if options.any? {|el| el == '?'}
            dir = options.index('?') + 1
        elsif options.none? {|el| el == '.'}
            dir = options.index('O')
        else
            dir = options.index('.') + 1
        end

        case dir
        when 1
            self.delta[1] = -1
        when 2
            self.delta[1] = 1
        when 3
            self.delta[0] = -1
        when 4
            self.delta[0] = 1
        end

        dir
    end

    def receive_output(fb)
        case fb
        when 0
            @grid[pos[1]+delta[1]][pos[0]+delta[0]] = "X"
            self.delta = [0,0]
        when 1
            move
        when 2
            self.oxy = [pos[1]+delta[1], pos[0]+delta[0], moves + 1]
            move
        end
    end

    def move
        @moves += 1 if @grid[pos[1]+delta[1]][pos[0]+delta[0]] == "?"
        @grid[pos[1]+delta[1]][pos[0]+delta[0]] = "B"

        if dead_end?(pos)
            @grid[pos[1]][pos[0]] = " "
            @moves -= 1
        else
            @grid[pos[1]][pos[0]] = "."
        end

        self.pos = [pos[0]+delta[0], pos[1]+delta[1]]
        self.delta = [0,0]
    end

    def potential_moves(coord)
        res = []
        res << @grid[coord[1]-1][coord[0]]
        res << @grid[coord[1]+1][coord[0]]
        res << @grid[coord[1]][coord[0]-1]
        res << @grid[coord[1]][coord[0]+1]

        res
    end

    def dead_end?(pos)
        moves = potential_moves(pos)
        x = moves.inject(0) {|acc, el| (el == 'X') || (el == ' ') ? (acc+1) : acc}
        x == 3
    end

    def display
        system "clear"

        @grid.each do |row|
            row.each do |el|
                print el
            end
            puts
        end
    end
end

def oxygenate(ship_map)
    counter = 0
    spread = []

    loop do
        break if ship_map.flatten.none? {|el| el == ' '}
        ship_map.each_with_index do |row, y|
            row.each_with_index do |el, x|
                if el == 'O'
                    spread << [x+1,y] if ship_map[y][x+1] == ' '
                    spread << [x-1,y] if ship_map[y][x-1] == ' '
                    spread << [x,y+1] if ship_map[y+1][x] == ' '
                    spread << [x,y-1] if ship_map[y-1][x] == ' '
                end
            end
        end

        spread.each do |x, y|
            ship_map[y][x] = 'O'
        end

        spread = []
        counter += 1
    end

    counter
end

def part_one
    bot = Robot.new
    comp = IntcodeComp.new('input.txt', bot)
    comp.run
    bot.display
    
    puts "It took #{bot.oxy[2]} instructions to locate the oxygen."
end

def part_two
    bot = Robot.new
    comp = IntcodeComp.new('input.txt', bot)
    comp.run

    bot.grid[25][25] = ' '
    bot.grid[40][40] = 'O'
    res = oxygenate(bot.grid)

    puts "It took #{res} ticks for the oxygen to disperse."
end

if __FILE__ == $PROGRAM_NAME
    part_one
    puts
    part_two
end


