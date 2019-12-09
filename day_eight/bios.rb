require_relative '../day_four/code.rb'

DATA = File.read('input.txt').split('').map(&:chomp).map(&:to_i)

def image_layers(file, width, height)
    layers = Array.new

    (0...file.length).each do |i|
        q, r = i.divmod(width*height)
        layers[q] ||= Array.new
        layers[q] << file[i]
    end

    layers
end

def layer_data(layers)
    data = Array.new

    layers.each do |layer|
        data << frequency(layer)
    end
    data
end

def part_one
    layers = image_layers(DATA, 25, 6)
    data = layer_data(layers)[0...-1]

    res = data.inject {|acc, el| (el[0] < acc[0]) ? el : acc}
    res[1]*res[2]
end

# p part_one

def print_image(file, width, height)
    image = Array.new(height) {Array.new(width)}

    layers = image_layers(file, width, height)[0...-1].reverse
    layers.each do |layer|
        layer.each_with_index do |el, index|
            next if el == 2
            pixel = (el == 0) ? "■" : "□"
            r, c = index.divmod(width)
            image[r][c] = pixel
        end
    end

    image.each do |row|
        row.each do |el|
            print el + " "
        end
        print "\n"
    end
    
    nil
end

print_image(DATA, 25, 6)