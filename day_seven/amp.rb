require_relative '../day_five/computer.rb'

def run(phases, input=0)
    amp_a = IntcodeComp.new('input.txt', phases[0])
    amp_b = IntcodeComp.new('input.txt', phases[1])
    amp_c = IntcodeComp.new('input.txt', phases[2])
    amp_d = IntcodeComp.new('input.txt', phases[3])
    amp_e = IntcodeComp.new('input.txt', phases[4])
    
    res = []
    while true
        res_a, op_a = amp_a.run(input)
        return res[-1] if op_a == 99
        res << res_a

        res_b, op_b = amp_b.run(res_a)
        return res[-1] if op_b == 99
        res << res_b

        res_c, op_c = amp_c.run(res_b)
        return res[-1] if op_c == 99
        res << res_c

        res_d, op_d = amp_d.run(res_c)
        return res[-1] if op_d == 99
        res << res_d

        res_e, op_e = amp_e.run(res_d)
        return res[-1] if op_e == 99
        res << res_e
        input = res_e
    end  
end

def part_one
    phases = [0,1,2,3,4].permutation.to_a

    res = phases.inject do |acc, el|
        a = run(acc)
        b = run(el)
        (b > a) ? el : acc
    end

    run(res)
end

puts "Part One: #{part_one}"

def part_2
    phases = [5,6,7,8,9].permutation.to_a

    res = phases.inject do |acc, el|
        a = run(acc)
        b = run(el)
        (b > a) ? el : acc
    end

    run(res)
end

puts "Part Two: #{part_2}"