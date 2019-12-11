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

def dist(base, target)
    x1, y1 = base
    x2, y2 = target
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
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    asteroids = asteroids(CHART)
    targets = Hash.new {|h,k| h[k] = Array.new}

    asteroids.each do |base|
        asteroids.each do |target|
            next if base == target

            dfn = degrees_from_north(base, target)
            targets[base] << dfn if !targets[base].include?(dfn)
        end
    end

    x = targets.keys.inject do |acc, el|
        (targets[el].length > targets[acc].length) ? el : acc
    end

    puts "Base Position: #{x}"
    puts "Visible Asteroids: #{targets[x].length}"

    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Time Elapsed: #{elapsed}"
end

def part_two(nth)
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    asteroids = asteroids(CHART)
    asteroids_by_angle = Hash.new {|h,k| h[k] = Array.new}

    asteroids.each do |pos|
        next if pos == BASE
        
        angle = degrees_from_north(BASE, pos)
        dist = dist(BASE, pos)
        asteroids_by_angle[angle] << [pos, dist]
    end

    sorted_angles = asteroids_by_angle.keys.sort
    target = nil

    (0...nth).each do |num|
        index = num % sorted_angles.length
        angle = sorted_angles[index]

        target = asteroids_by_angle[angle].inject do |acc, el|
            (el[1] < acc[1]) ? el : acc
        end

        asteroids_by_angle[angle] - target
    end

    puts "Target ##{nth}: #{target[0]}"
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Time Elapsed: #{elapsed}"
end

part_one
puts
part_two(200)
