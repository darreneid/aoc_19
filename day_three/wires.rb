wire_a, wire_b = File.readlines("input.txt").map { |el| el.chomp.split(',') }

test_wire_a = ["R75","D30","R83","U83","L12","D49","R71","U7","L72"]
test_wire_b = ["U62","R66","U55","R34","D71","R55","D58","R83"]


def parse(input)
    dir = input[0]
    len = input[1...input.length].to_i
    [dir, len]
end

def traverse(wire)
    nodes = []
    x = 0
    y = 0

    wire.each do |el|
        dir, len = parse(el)

        (1..len).each do |el|
            case dir
            when "U"
                y += 1
            when "D"
                y -= 1
            when "R"
                x += 1
            when "L"
                x -= 1
            end

            pos = [x,y]
            nodes << pos
        end
    end
    nodes
end

def intersection(a, b)
    nodes_a = traverse(a)
    nodes_b = traverse(b)

    nodes_a & nodes_b
end

def shortest_distance(a, b)
    ints = intersection(a, b)
    dist = ints.map {|el| el[0].abs + el[1].abs}.min
end

def fewest_steps(a, b)
    nodes_a = traverse(a)
    nodes_b = traverse(b)
    ints = nodes_a & nodes_b
    steps = []

    ints.each do |el|
        steps << nodes_a.index(el) + nodes_b.index(el) + 2
    end

    steps.min
end

p shortest_distance(test_wire_a, test_wire_b)

p fewest_steps(wire_a, wire_b)