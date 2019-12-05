require_relative '../day_four/code.rb'

 class IntcodeComp
    def self.read_from_file
        File.read("input.txt").split(",").map(&:to_i)
    end

    def initialize
        @pos = 0
        @program = IntcodeComp.read_from_file
    end

    def run
        while true
            op, mod = parse(@program[@pos])
            return @program[0] if op == 9
            execute(op, mod)
        end
    end

    def parse(instruction)
        digs = digits(instruction)
        opcode = digs[-1]
        modes = digs[0...-2]
        modes = modes.reverse if modes
        return [opcode, modes]
    end

    def execute(op, modes)
        case modes[0]
        when 1
            p1 = @program[@pos+1]
        else
            p1 = @program[@program[@pos+1]]
        end

        case modes[1]
        when 1
            p2 = @program[@pos+2]
        else
            p2 = @program[@program[@pos+2]]
        end

        case modes[2]
        when 1
            p3 = @program[@pos+3]
        else
            p3 = @program[@program[@pos+3]]
        end

        case op
        when 1
            @program[@program[@pos+3]] = p1 + p2
            @pos += 4
        when 2
            @program[@program[@pos+3]] = p1*p2
            @pos += 4
        when 3
            print "[Opcode 3] Input: "
            input = gets.chomp.to_i
        
            @program[@program[@pos+1]] = input
            @pos += 2
        when 4
            puts p1
            @pos += 2
        when 5
            @pos = (p1 == 0) ? (@pos + 3) : (p2)
        when 6
            @pos = (p1 == 0) ? (p2) : (@pos + 3)
        when 7
            @program[@program[@pos+3]] = (p1 < p2) ? (1) : (0)
            @pos += 4
        when 8
            @program[@program[@pos+3]] = (p1 == p2) ? (1) : (0)
            @pos += 4
        end
    end
 end

x = IntcodeComp.new
x.run