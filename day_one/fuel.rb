def fuel_requirement(mass)
    fuel = (mass/3).floor - 2

    return 0 if fuel <= 0
    return fuel + fuel_requirement(fuel)
end


raw_modules = File.readlines("input.txt")

modules = raw_modules.map do |el|
    el.chomp
    el.to_i
end

sum = modules.inject(0) do |acc, el|
    acc += fuel_requirement(el)
end

p sum