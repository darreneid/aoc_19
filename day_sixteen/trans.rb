require 'byebug'
require 'matrix'

data = File.read('input.txt').chomp.split('').map(&:to_i)
super_data = data.dup * 10000
vector_data = Vector.elements(super_data)

class SuperArray
    include Enumerable

    attr_reader :length

    def initialize(len, default=nil)
        default ||= Array.new(650, nil)

        @grid = Array.new(len) {default.dup}
        @length = len*650
    end

    def each(&blk)
        @grid.each do |row|
            row.each do |el|
                blk.call(el)
            end
        end
    end

    def [](index)
        q, r = index.divmod(650)
        @grid[q][r]
    end

    def []=(index, val)
        q, r = index.divmod(650)
        @grid[q][r] = val
    end
end

def pattern(n)
    pat = []
    base = [0,1,0,-1]
    
    base.each do |el|
        (n+1).times do
            pat << el
        end
    end

    q, r = 6500000.divmod(pat.length)
    res = pat[1...pat.length] + (pat*(q-1)) + pat[0..r]
    vector_pattern = Vector.elements(res)
end

def fft(data_in)
    data_out = []

    i = 0
    while i < 6500000
        puts "Operating on index #{i}"
        pat = pattern(i)
        out = data_in.inner_product(pat)
        data_out += [out]
        i += 1
    end
    
    res = data_out.map {|el| el.abs%10}
    vector_res = Vector.elements(res)
end

def recursive_fft(data_in, n)
    i = 1
    n.times do
        puts "Iteration #: #{i}"
        data_in = fft(data_in)
        i += 1
    end

    data_in
end

# sig = SuperArray.new(10000, data)
signal = recursive_fft(vector_data, 100)
# # p signal
# offset = signal[0...7]
p signal[offset..offset+8]
