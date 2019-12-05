MEMORY = File.read("input.txt").split(",").map(&:to_i)

def get_output(i, j)
    input = MEMORY.dup
    input[1] = i
    input[2] = j

    i = 0
    while true
        if input[i] == 1
            input[input[i+3]] = input[input[i+1]] + input[input[i+2]]
            i += 4
        elsif input[i] == 2
            input[input[i+3]] = input[input[i+1]]*input[input[i+2]]
            i += 4
        elsif input[i] == 99
            return input[0]
        else
            raise OpcodeError
        end
        i += 4
    end
end

def solve
    (0..99).each do |i|
        (0..99).each do |j|
            return 100*i + j if get_output(i,j) == 19690720
        end
    end
end

p solve