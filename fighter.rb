require 'gosu'
require_relative 'background.rb'
require_relative 'player.rb'
require_relative 'controls.rb'

module Fighter
  class GameWindow < Gosu::Window
    def initialize
      super 768, 480, false
      self.caption = 'Goshu Tutorial Game'
      @background_image = Background.new(self)
      @player1 = Player.new('chun-li', self, 0, height-300, false)
      @player2 = Player.new('ryu', self, width-100, height-300, true)
      @controls1 = Controls.new(self, @player1, 1)
      @controls2 = Controls.new(self, @player2, 2)
    end

    # Called 60 times a second by default
    # Should contain the main game logic: move objects, handle collisions etc.
    def update
      @controls1.update @player1.x + 150, @player2.x - 150
      @controls2.update @player1.x + 150, @player2.x - 150
    end

    # Called after update and whenever the window needs redrawing for other
    # reasons (may be skipped every other time if fps is too low). Should contain
    # the code to redraw the whole screen, but no updates to the game's state.
    def draw
      @background_image.draw
      @player1.draw
      @player2.draw
    end

    def button_down(id)
      @controls1.button_down button_id_to_char id
      @controls2.button_down button_id_to_char id
    end
  end
end

# Main program create a window and call it's show function which doesn't return
# until the window has been closed by the user or by calling close()
window = Fighter::GameWindow.new
window.show
