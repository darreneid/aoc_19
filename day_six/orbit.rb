DATA = File.readlines("input.txt").map(&:chomp).map { |el| el.split(")") }

class Body
    attr_accessor :name, :children, :parent

    def initialize(name)
        @name = name
        @children = []
        @parent = nil
    end
end

def map(data)
    bodies = Hash.new

    data.each do |el|
        bod, orb = el
        bodies[bod] ||= Body.new(bod)
        bodies[orb] ||= Body.new(orb)
        bodies[bod].children << bodies[orb]
        bodies[orb].parent = bodies[bod]
    end

    bodies
end

def orbits(body)
    return [] if body.parent.nil?
    return [body.parent.name] + orbits(body.parent)
end

def num_orbits(body)
    orbits(body).length
end

def distance(map, start, finish)
    s = map[start]
    f = map[finish]

    s_orbits = orbits(s)
    f_orbits = orbits(f)

    return s_orbits.index(finish) if s_orbits.include?(finish   )
    return f_orbits.index(start) if f_orbits.include?(start)

    ancestor = (s_orbits & f_orbits).first

    s_orbits.index(ancestor) + f_orbits.index(ancestor)
end

def solve_1 
    map(DATA).values.inject(0) { |acc, el| acc + num_orbits(el) }
end

def solve_2
    distance(map(DATA), "YOU", "SAN")
end

puts "Part 1: #{solve_1}"
puts "Part 2: #{solve_2}"