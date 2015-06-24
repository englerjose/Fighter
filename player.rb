require_relative 'animation.rb'

module Fighter
  class Player

    SCALE = 3
    STEP_SIZE = 2
    TURN_OFFSET = 100
    SEPERATION = 1.0  # Scale of a characters width to distance from other player

    def initialize player_name, window, x, y, side
      @tileset = TileSet.new player_name, window
      @window = window
      @x, @y = x, y
      @side = side
      @seperation = SEPERATION * width
    end

    def move_left other_player
      return if @side == :left && outer_x - STEP_SIZE <= 0
      return if @side == :right && inner_x - STEP_SIZE <= other_player.inner_x
      @x -= STEP_SIZE
    end

    def move_right other_player
      return if @side == :right && outer_x + STEP_SIZE >= @window.width
      return if @side == :left && inner_x + STEP_SIZE >= other_player.inner_x
      @x += STEP_SIZE
    end

    def idle
      @busy = false
      set_animation :idle
    end

    def kick
      @busy = true
      set_animation(:kick) {  idle  }
    end

    def punch
      @busy = true
      set_animation(:punch) {  idle  }
    end

    def walking
      set_animation :walking
    end

    def block
      @busy = true
      set_animation(:block) {  idle  }
    end

    def draw
      @tileset.animation.draw @x, @y, 0, scale_x, SCALE
    end

    def width
      @tileset.width*SCALE
    end

    def busy?
      return @busy
    end

    # Returns the x value of the players bounding box closest to the
    # opposing player
    def inner_x
      @side == :left ? @x+width : @x-width
    end

    def outer_x
      @x #Note when flipping @x remains the same hence @x is always the outer value
    end

    private
      def set_animation animation, &block
        @tileset.animation = @tileset[animation]
        @tileset.animation.play_once &block unless block.nil?
      end

      def scale_x
        return SCALE if @side == :left
        -SCALE if @side == :right
      end
  end

  class TileSet <  Hash
    def initialize player_name, window
      self[:idle] = Fighter::Animation.new("#{player_name}/idle", window)
      self[:kick] = Fighter::Animation.new("#{player_name}/kick", window)
      self[:punch] = Fighter::Animation.new("#{player_name}/punch", window)
      self[:walking] = Fighter::Animation.new("#{player_name}/walking", window)
      self[:block] = Fighter::Animation.new("#{player_name}/block", window)
      @animation = self[:walking]
      @width, @height = @animation.width, @animation.height
    end

    attr_accessor :animation
    attr_reader :width, :height

  end
end
