require_relative '../day_five/computer.rb'

class Robot
    DIRS = [:up, :right, :down, :left]

    def initialize
        @pos = [0,0]
        @dir_index = 0
        @grid = Hash.new {|h,k| h[k] = 'black'}
        @grid[@pos.join(',')] = 'white'
        @history = Hash.new {|h,k| h[k] = 0}
    end

    def detect
       input = (@grid[@pos.join(',')] == 'black') ? 0 : 1
    end

    def paint(input)
        @grid[@pos.join(',')] = (input == 0) ? 'black' : 'white'
        @history[@pos.join(',')] += 1
    end

    def process(input)
        turn(input)
        move
    end

    def turn(input)
        if input == 1
            @dir_index += 1
            @dir_index = 0 if @dir_index == 4
        else
            @dir_index -= 1
            @dir_index = 3 if @dir_index == -1
        end
    end

    def move
        case DIRS[@dir_index]
        when :up
            delta = [0,1]
        when :right
            delta = [1,0]
        when :down
            delta = [0,-1]
        when :left
            delta = [-1,0]
        end
    
        x, y = @pos
        dx, dy = delta
        @pos = [x + dx, y + dy]
    end

    def print_grid
        img = Array.new(100) {Array.new(100, " ")}

        @grid.keys.each do |el|
            i, j = el.split(',').map(&:to_i)

            if @grid[el] == 'black'
                img[i+50][j+50] = ' '
            else
                img[i+50][j+50] = 'x'
            end
        end
        
        file = File.open("output.txt", "w")
        img.each do |row|
            row.each do |el|
                file.print el
            end
            file.print "\n"
        end
        file.close
    end

end

wally = Robot.new
comp = IntcodeComp.new('input.txt', wally)
comp.run
wally.print_grid
