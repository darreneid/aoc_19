require 'colorize'

class Maze
    attr_reader :entrance, :keys_actual, :doors
    attr_accessor :keys_owned, :loc, :steps, :history

    DIRS = [[1,0], [-1,0], [0, 1], [0,-1]]

    def self.read_from_file(file)
        map = File.readlines(file).map(&:chomp).map {|el| el.split('')}
    end

    def self.locate(arr)
        res = Array.new(3) {Hash.new}
        arr.each_with_index do |row, y|
            row.each_with_index do |el, x|
                if el == '@'
                    res[0][el] = [x,y]
                elsif ('a'..'z').include?(el)
                    res[1][el] = [x,y]
                elsif ('A'..'Z').include?(el)
                    res[2][el] = [x,y]
                end
            end
        end

        res
    end

    def initialize(file='input.txt')
        @map = Maze.read_from_file(file)
        @entrace, @keys_actual, @doors = Maze.locate(@map)
        @keys_owned = Hash.new
        @loc = [40,40]
        @steps = 0
        @history = Hash.new
        @history[loc.join] = steps
    end

    def navigate
        cur = self[loc]
        opt1 = possible_moves.reject {|el| el[0] == '#'}
        opt2 = opt1.select {|el| history[el[1].join].nil?}

        if opt1.length == 1 && cur == '.'
            self[loc] = '#'
            mv = opt1.sample[1]
        elsif opt2.length > 0
            mv = opt2.sample[1]
        else
            mv = opt1.sample[1]
        end

        self.loc = mv
        self.steps += 1
        self.history[loc.join] = steps
        self.keys_owned[self[loc]] = loc if ('a'..'z').include?(self[loc])
    end

    def solve
        loop do
            navigate
            break if keys_owned.length == 26
        end
    end

    def possible_moves
        x, y = loc

        res = []
        DIRS.each do |(dx, dy)|
            new_pos = [x+dx,y+dy]
            res << [self[new_pos], new_pos]
        end

        res
    end

    def display
        system 'clear'

        @map.each_with_index do |row, y|
            row.each_with_index do |el, x|
                if [x,y] == loc
                    print el.red.blink
                else
                    print el
                end
            end
            puts
        end
    end

    def [](pos)
        x, y = pos
        @map[y][x]
    end

    def []=(pos, val)
        x, y = pos
        @map[y][x] = val
    end
end

m = Maze.new
m.solve
m.display