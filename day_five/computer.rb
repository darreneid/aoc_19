require_relative '../day_four/code.rb'
require 'byebug'

 class IntcodeComp
    attr_accessor :pos, :rel_base, :mem, :prog

    def self.read_from_file(path)
        return path if path.is_a?(Array)
        input = File.read(path).split(",").map(&:to_i) + Array.new(1000000,0)
    end

    def initialize(path, program)
        @mem = IntcodeComp.read_from_file(path)
        @pos = 0
        @rel_base = 0
        @prog = program
    end

    def run
        loop do
            op, mod = parse(mem[pos])
            break if op == 99
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
            p1 = mem[pos+1]
        when 2
            p1 = mem[mem[pos+1] + rel_base]
        else
            p1 = mem[mem[pos+1]]
        end

        case modes[1]
        when 1
            p2 = mem[pos+2]
        when 2
            p2 = mem[mem[pos+2] + rel_base]
        else
            p2 = mem[mem[pos+2]]
        end

        case op
        when 1
            adj = (modes[2] == 2) ? (rel_base) : 0
            self.mem[mem[pos+3] + adj] = p1 + p2
            self.pos += 4
        when 2
            adj = (modes[2] == 2) ? (rel_base) : 0
            self.mem[mem[pos+3] + adj] = p1*p2
            self.pos += 4
        when 3
            num = prog.get_input

            adj = (modes[0] == 2) ? (rel_base) : 0
            self.mem[mem[pos+1] + adj] = num
            self.pos += 2
        when 4
            prog.receive_output(p1)
            self.pos += 2
        when 5
            self.pos = (p1 == 0) ? (pos + 3) : (p2)
        when 6
            self.pos = (p1 == 0) ? (p2) : (pos + 3)
        when 7
            adj = (modes[2] == 2) ? (rel_base) : 0
            self.mem[mem[pos+3] + adj] = (p1 < p2) ? (1) : (0)
            self.pos += 4
        when 8
            adj = (modes[2] == 2) ? (rel_base) : 0
            self.mem[mem[pos+3] + adj] = (p1 == p2) ? (1) : (0)
            self.pos += 4
        when 9
            self.rel_base += p1
            self.pos += 2
        end
    end
 end
