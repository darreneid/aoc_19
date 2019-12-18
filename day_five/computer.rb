require_relative '../day_four/code.rb'
require 'byebug'

 class IntcodeComp
    def self.read_from_file(path)
        return path if path.is_a?(Array)
        input = File.read(path).split(",").map(&:to_i) + Array.new(1000000,0)
    end

    def initialize(path, robot, *input)
        @pos = 0
        @input = input
        @output = []
        @rel_base = 0
        @program = IntcodeComp.read_from_file(path)
        @robot = robot
    end

    def run(*input)
        @input += input
        while true
            op, mod = parse(@program[@pos])
            return [0, 99] if op == 99
            # return execute(op, mod) if op == 4
            # puts "Executing Code: #{op} with Modes: #{mod}"
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
        when 2
            p1 = @program[@program[@pos+1]+@rel_base]
        else
            p1 = @program[@program[@pos+1]]
        end

        case modes[1]
        when 1
            p2 = @program[@pos+2]
        when 2
            p2 = @program[@program[@pos+2]+@rel_base]
        else
            p2 = @program[@program[@pos+2]]
        end

        case op
        when 1
            adj = (modes[2] == 2) ? (@rel_base) : 0
            @program[@program[@pos+3] + adj] = p1 + p2
            @pos += 4
        when 2
            adj = (modes[2] == 2) ? (@rel_base) : 0
            @program[@program[@pos+3] + adj] = p1*p2
            @pos += 4
        when 3
            if @input.length == 0
                
            else
                num = @input.shift
            end
            
            adj = (modes[0] == 2) ? (@rel_base) : 0
            @program[@program[@pos+1] + adj] = num
            @pos += 2
        when 4
            # puts "[Opcode 4] Output: #{p1}"
            @output << p1
            if @output.length == 1
                @robot.process(@output.shift)
            end
            @pos += 2
        when 5
            @pos = (p1 == 0) ? (@pos + 3) : (p2)
        when 6
            @pos = (p1 == 0) ? (p2) : (@pos + 3)
        when 7
            adj = (modes[2] == 2) ? (@rel_base) : 0
            @program[@program[@pos+3] + adj] = (p1 < p2) ? (1) : (0)
            @pos += 4
        when 8
            adj = (modes[2] == 2) ? (@rel_base) : 0
            @program[@program[@pos+3] + adj] = (p1 == p2) ? (1) : (0)
            @pos += 4
        when 9
            @rel_base += p1
            @pos += 2
        end
    end
 end