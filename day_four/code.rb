lower = 240298
upper = 784956

def digits(num)
    q, r = num.divmod(10)
    q == 0 ? [r] : digits(q) + [r]
end

def frequency(arr)
    freqs = Hash.new { |h,k| h[k] = 0 }
    arr.each {|el| freqs[el] += 1}
    freqs
end

def adjacent?(num)
    dig = digits(num)
    res = false

    dig.each_with_index do |el, i|
        dig.each_with_index do |ell, j|
            return true if el == ell && (i-j).abs == 1 && frequency(dig)[el] == 2
        end
    end

    false
end

def increasing?(num)
    dig = digits(num)

    dig.inject do |acc, el|
        return false if el < acc
        acc = el
    end

    true
end

def solve
    res = []

    (lower..upper).each do |el|
        res << el if adjacent?(el) && increasing?(el)
    end

    res.length
end

