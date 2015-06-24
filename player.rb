require_relative 'animation.rb'

module Fighter
  class Player

    SCALE = 3
    STEP_SIZE = 2
    TURN_OFFSET = 100
    attr_reader :x

    def initialize player_name, window, x, y, flip
      @tileset = TileSet.new player_name, window
      @window = window
      @x, @y = x, y
      @scale_x = SCALE
      @flip = flip ? -1 : 1
    end

    def move_left left_x_bounds=0
      return if (@x - width) < left_x_bounds
      @x -= STEP_SIZE
    end

    def move_right right_x_bounds=@window.width
      return if (@x + width) > right_x_bounds
      @x += STEP_SIZE
    end

    def turn_left can_move
      return if @x < 0
      if @scale_x > 0
        @scale_x *= -1
        #@x += TURN_OFFSET
      end
      move unless @x - width < 0 || !can_move
    end

    def turn_right can_move
      return if @x > @window.width
      if @scale_x < 0
        @scale_x *= -1
        #@x -= TURN_OFFSET
      end
      move unless @x > @window.width - TURN_OFFSET || !can_move
    end

    def move
      @x += @scale_x < 0? -STEP_SIZE : STEP_SIZE
    end

    def idle
      set_animation :idle
    end

    def kick
      set_animation(:kick) {  idle  }
    end

    def punch
      set_animation(:punch) {  idle  }
    end

    def walking
      set_animation :walking
    end

    def block
      set_animation :block
    end

    def draw
      @tileset.animation.draw @x, @y, 0, @flip*SCALE, SCALE
    end

    def width
      @tileset.width
    end

    private
      def set_animation animation, &block
        @tileset.animation = @tileset[animation]
        @tileset.animation.play_once &block unless block.nil?
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
