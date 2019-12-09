require_relative '../day_four/code.rb'

 class IntcodeComp
    def self.read_from_file(path)
        File.read(path).split(",").map(&:to_i)
    end

    def initialize(path, phase=[])
        @pos = 0
        @input = [phase]
        @program = IntcodeComp.read_from_file(path)
    end

    def run(*input)
        @input += input
        while true
            op, mod = parse(@program[@pos])
            return [0, 99] if op == 99
            return execute(op, mod) if op == 4
            execute(op, mod)
        end
    end

    def parse(instruction)
        digs = digits(instruction)
        opcode = digs[-1]
        opcode = 10*digs[-2] + opcode if digs[-2]
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

        case op
        when 1
            @program[@program[@pos+3]] = p1 + p2
            @pos += 4
        when 2
            @program[@program[@pos+3]] = p1*p2
            @pos += 4
        when 3
            # puts "[Opcode 3] Input: #{@input[0]}"
            # input = gets.chomp
        
            @program[@program[@pos+1]] = @input[0]
            @input.shift
            @pos += 2
        when 4
            # puts "[Opcode 4] Output: #{p1}"
            @pos += 2
            return [p1, op]
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

# x = IntcodeComp.new('input.txt')
# x.run