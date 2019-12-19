require 'byebug'

data = File.read('input.txt').chomp.split('').map(&:to_i)
super_data = data.dup * 10000

<<<<<<< HEAD

def calculate(data, i)
    res = 0
    n = 0

    loop do        
        lower = i + 4*(i+1)*n
        upper = lower + i + 1
        range = data[lower...upper]
        break if range.nil?

        range.each {|el| res += el}

        lower = lower + 2*(i+1)
        upper = lower + i + 1
        range = data[lower...upper]
        break if range.nil?

        range.each {|el| res -= el}

        n += 1
=======
def pattern(n)
    pat = []
    base = [0,1,0,-1]
    
    base.each do |el|
        (n+1).times do
            pat << el
        end
>>>>>>> c8ee3d909ff35f387de9cfd7aeb2e2a72ca6f7ec
    end

    res
end

def fft(data_in)
    data_out = []

    i = 0
    while i < data_in.length        
        out = calculate(data_in, i)
        data_out << out
        i += 1
    end
    
    res = data_out.map {|el| el.abs%10}
end

def recursive_fft(data_in, n)
    i = 1
    n.times do
        data_in = fft(data_in)
        i += 1
    end

    data_in
end

<<<<<<< HEAD
signal = recursive_fft(super_data, 100)
puts signal[0...7].join
=======
signal = recursive_fft(vector_data, 100)
offset = signal[0...7]
p signal[offset..offset+8]
>>>>>>> c8ee3d909ff35f387de9cfd7aeb2e2a72ca6f7ec
