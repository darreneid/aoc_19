require 'byebug'

class Moon
    attr_accessor :pos, :vel

    def initialize(pos)
        @pos = pos
        @vel = [0,0,0]
    end

    def apply_gravity(body)
        (0..2).each do |dim|
            case self.pos[dim] <=> body.pos[dim]
            when 1
                self.vel[dim] -= 1
                body.vel[dim] += 1
            when -1
                self.vel[dim] += 1
                body.vel[dim] -= 1
            end
        end
    end

    def update_position
        x, y, z = pos
        dx, dy, dz = vel
        self.pos = [x + dx, y + dy, z + dz]
    end

    def potential_energy
        @pos.inject(0) {|acc, dim| acc + dim.abs}
    end

    def kinetic_energy
        @vel.inject(0) {|acc, dim| acc + dim.abs}
    end

    def total_energy
        potential_energy*kinetic_energy
    end 
end

class System
    attr_accessor :bodies

    def initialize(bodies)
        @bodies = bodies
    end

    def step
        bodies.each_with_index do |body, i|
            (i...bodies.length).each do |j|
                body.apply_gravity(bodies[j])
            end
        end
        
        bodies.each {|body| body.update_position}
    end

    def get_state
        state = []
        bodies.each {|body| state << (body.pos.join(',') + '-' + body.vel.join(','))}
        state.join('_')
    end

    def potential_energy
        bodies.inject(0) {|acc, body| acc + body.potential_energy}
    end

    def kinetic_energy
        bodies.inject(0) {|acc, body| acc + body.kinetic_energy}
    end

    def total_energy
        bodies.inject(0) {|acc, body| acc + body.potential_energy*body.kinetic_energy}
    end
end

def part_one
    pos1 = [1,4,4]
    pos2 = [-4,-1,19]
    pos3 = [-15,-14,12]
    pos4 = [-17,1,10]
    positions = [pos1, pos2, pos3, pos4]

    moons = positions.map {|pos| Moon.new(pos)}
    sys = System.new(moons)

    1000.times {sys.step}
    puts "Total Energy: #{sys.total_energy}"
end

counter = 0
history = Hash.new

def part_two
    pos1 = [1,4,4]
    pos2 = [-4,-1,19]
    pos3 = [-15,-14,12]
    pos4 = [-17,1,10]
    positions = [pos1, pos2, pos3, pos4]

    moons = positions.map {|pos| Moon.new(pos)}
    sys = System.new(moons)
    counter = 0
    history = Hash.new

    while true
        break if history[sys.get_state]
        history[sys.get_state] = 1
        sys.step
        counter += 1
    end

    puts "Steps: #{counter}"
end

# part_one
part_two