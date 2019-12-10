CHART = File.readlines('input.txt').map(&:chomp).map {|el| el.split('')}    
BASE = [29, 28]

def degrees_from_north(base, target)
    x1, y1 = base
    x2, y2 = target
    x_diff = (x2 - x1).to_f
    y_diff = (y2 - y1).to_f

    base = (x_diff.negative?) ? Math::PI : 0

    (Math.atan(y_diff/x_diff) + Math::PI/2) + base
end

def dist(p1, p2)
    x1, y1 = p1
    x2, y2 = p2
    x_diff = (x2 - x1).to_f
    y_diff = (y2 - y1).to_f

    (y_diff)*(y_diff) + (x_diff)*(x_diff)
end

def asteroids(input)
    asteroids = []
    input.each_with_index do |row, i|
        row.each_with_index do |el, j|
            asteroids << [j, i] if el == "#"
        end
    end
    asteroids
end

def part_one
    asteroids = asteroids(CHART)
    targets = Hash.new {|h,k| h[k] = Array.new}

    asteroids.each do |base|
        asteroids.each do |target|
            next if base == target

            dfn = degrees_from_north(base, target)

            if !targets[base].include?(dfn)
                targets[base] << dfn
            end
        end
    end

    x = targets.keys.inject do |acc, el|
        (targets[el].length > targets[acc].length) ? el : acc
    end

    p "Position: #{x}"
    p "Targets: #{targets[x].length}"
end

def part_two(nth)
    asteroids = asteroids(CHART)

    asteroids_by_angle = Hash.new {|h,k| h[k] = Array.new}

    asteroids.each do |pos|
        next if pos == BASE
        
        angle = degrees_from_north(BASE, pos)
        dist = dist(BASE, pos)
        asteroids_by_angle[angle] << [pos, dist]
    end

    sorted_angles = asteroids_by_angle.keys.sort

    (0...nth).each do |num|
        index = num % sorted_angles.length
        angle = sorted_angles[index]

        target = asteroids_by_angle[angle].inject do |acc, el|
            (el[1] < acc[1]) ? el : acc
        end

        p "Target #{num}: #{target[0]}"

        asteroids_by_angle[angle] - target
    end
end

part_two(200)
