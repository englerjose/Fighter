require_relative 'animation.rb'

module Fighter
  class Player

    SCALE = 3
    STEP_SIZE = 2
    MAX_HEALTH = 100
    ATTACKS = {
      kick: MAX_HEALTH / 10,
      punch: MAX_HEALTH / 20
    }

    attr_reader :side, :MAX_HEALTH
    attr_accessor :health

    def initialize(player_name, window, x, y, side)
      @tileset = TileSet.new player_name, window
      @window = window
      @x, @y = x, y
      @side = side
      @health = 100
      @cooldown = rand(100..500)
      @last_attack = 0
    end

    def move_left(other_player)
      return if blocking?
      return if @side == :left && outer_x - STEP_SIZE <= 0
      return if @side == :right && inner_x - STEP_SIZE <= other_player.inner_x
      @x -= STEP_SIZE
    end

    def move_right(other_player)
      return if blocking?
      return if @side == :right && outer_x + STEP_SIZE >= @window.width
      return if @side == :left && inner_x + STEP_SIZE >= other_player.inner_x
      @x += STEP_SIZE
    end

    def idle
      @busy = false
      set_animation :idle
    end

    def kick(other_player)
      return if Gosu::milliseconds-@last_attack < @cooldown
      @busy = true
      set_animation(:kick) { attack other_player, :kick; idle  }
      @cooldown = rand(0..1500)
      @last_attack = Gosu::milliseconds
    end

    def punch(other_player)
      return if Gosu::milliseconds-@last_attack < @cooldown
      @cooldown = rand(0..1500)
      @last_attack = Gosu::milliseconds
      @busy = true
      set_animation(:punch) { attack other_player, :punch; idle  }
    end

    def walking
      set_animation :walking
    end

    def block
      set_animation :block
    end

    def hit(damage)
      return if blocking?
      @busy = true
      @health -= damage
      set_animation(:hit) {  idle  }
    end

    def draw
      @tileset.animation.draw @x, @y, 0, scale_x, SCALE
    end

    def width
      @tileset.width*SCALE
    end

    def busy?
      @busy
    end

    def in_range?(other_player)
      (inner_x - other_player.inner_x).abs <= STEP_SIZE
    end

    def blocking?
      @tileset.animation == @tileset[:block]
    end

    def attack(other_player, move)
      return unless in_range?(other_player) || other_player.blocking?
      other_player.hit ATTACKS[move]
      @window.gameover if other_player.ko?
    end

    def ko?
      @health <= 0
    end

    def freeze
      @tileset.animation.freeze!
    end

    # Returns the x value of the players bounding box closest to the
    # opposing player
    def inner_x
      @side == :left ? @x+width : @x-width
    end

    def outer_x
      @x # Note when flipping @x remains the same hence @x is always the outer value
    end

    private

    def set_animation(animation, &block)
      @tileset.animation = @tileset[animation]
      @tileset.animation.play_once(&block) unless block.nil?
    end

    def scale_x
      return SCALE if @side == :left
      -SCALE if @side == :right
    end
  end

  class TileSet < Hash
    def initialize(player_name, window)
      self[:idle] = Animation.new("#{player_name}/idle", window)
      self[:kick] = Animation.new("#{player_name}/kick", window)
      self[:punch] = Animation.new("#{player_name}/punch", window)
      self[:walking] = Animation.new("#{player_name}/walking", window)
      self[:block] = Animation.new("#{player_name}/block", window)
      self[:hit] = Animation.new("#{player_name}/hit", window)
      @animation = self[:walking]
      @width, @height = @animation.width, @animation.height
    end

    attr_accessor :animation
    attr_reader :width, :height
  end
end
