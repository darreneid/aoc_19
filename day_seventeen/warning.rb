require_relative '../day_five/computer.rb'

class Ascii
    attr_accessor :view, :current_row

    def initialize(input = [])
        @view = Array.new(1) {Array.new}
        @current_row = 0
        @input = input
    end

    def get_input
        @input.shift
    end

    def receive_output(input)
        case input
    
        when 10
            @view << Array.new
            @current_row += 1
        else
            begin
            @view[@current_row] << input.chr
            rescue
                @view[@current_row] << input
            end
        end
    end

    def display
        @view.each do |row|
            row.each do |el|
                print el
            end
            puts
        end
    end
end

def intersections(map)
    res = []
    map.each_with_index do |row, y|
        row.each_with_index do |el, x|
            if el == "#"
                neighbors = [map[y+1][x], map[y-1][x], map[y][x+1], map[y][x-1]]
                res << [x,y] if neighbors.all? {|el| el == "#"}
            end
        end
    end
    res
end

def asciify(input)
    res = []
    input.each do |el|
        res << el.ord
        res << 44
    end
    res[-1] = 10
    res
end


main = asciify(["A", "B", "B", "A", "C", "A", "C", "A", "C", "B"])
func_a = asciify(["L", "6", "R", "4", "8", "R", "8"])
func_b = asciify(["R", "8", "R", "4", "8", "L", "4", "8"])
func_c = asciify(["R", "4", "8", "L", "4", "8", "L", "4", "L", "4"])
options = asciify(["n"])

input = main + func_a + func_b + func_c + options
bot = Ascii.new(input)
comp = IntcodeComp.new('input.txt', bot)

comp.run
bot.display