require 'byebug'

raw_data = File.readlines('input.txt').map(&:chomp)
raw_data.map! {|el| el.split(' => ')}
raw_data.map! {|el| el[0].split(', ') + [el[1]]}
raw_data.map! {|el| el.map! {|ele| ele.split(' ')}}
raw_data.map! {|el| el.map! {|ele| [ele[0].to_i, ele[1]]}}

REACTIONS = raw_data.inject(Hash.new) do |acc, el|
    num, prod = el.pop
    acc[prod] = [num] + el
    acc
end

def raw_materials(product, num_req, leftovers=nil, res=0)
    leftovers ||= Hash.new {|h,k| h[k] = 0}
    stock = leftovers[product]

    if stock >= num_req
        leftovers[product] -= num_req
        return 0
    elsif leftovers[product] > 0
        num_req -= leftovers[product]
        leftovers[product] = 0
    end
        
    info = REACTIONS[product]
    num_prod = info[0]
    react = info[1...info.length]
    m = (num_req.to_f/num_prod.to_f).ceil

    leftovers[product] += (m*num_prod - num_req)

    react.each do |el|
        if el[1] == 'ORE'
            res += m*el[0]
        else
            res += raw_materials(el[1], m*el[0], leftovers)
        end
    end
    
    res
end

def search(lower, upper, &prc)
    pivot = (lower + upper)/2
    res = prc.call(pivot)
    return lower if (upper - lower) < 2

    return search(lower, pivot, &prc) if res == 1
    return search(pivot, upper, &prc) if res == -1
end

def part_one
    res = raw_materials("FUEL", 1)

    puts "It will take #{res} ore to make a single unit of fuel."
end

def part_two
    res = search(1, 1000000000) do |el|
        raw_materials("FUEL", el) <=> 1000000000000
    end

    puts "We can make a maximum of #{res} fuel using one trillion ore."
end

if __FILE__ == $PROGRAM_NAME
    part_one
    puts
    part_two
end