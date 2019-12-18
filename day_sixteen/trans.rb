require 'byebug'
require 'matrix'

data = File.read('input.txt').chomp.split('').map(&:to_i)
super_data = data.dup * 10000
vector_data = Vector.elements(super_data)

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

signal = recursive_fft(vector_data, 100)
offset = signal[0...7]
p signal[offset..offset+8]
