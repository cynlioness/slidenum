require 'gosu'
$WIDTH = 4
$HEIGHT = 4
$TILE = 48

class Block
	attr_accessor :height, :width, :x, :y
	def initialize (window, x, y, value)
		@window = window
		@x = x
		@y = y
		@value = value
		@color = Gosu::Color::GREEN
	end
	def update
		#(0..length-1).to_a.each do |square|
		#	if @isvertical then
		#		@window.grid[x+square][y] = self
		#	end
		#end
	end
	def draw
		xmin = @x * $TILE
		xmax = (@x + 1) * $TILE
		ymin = @y * $TILE
		ymax = (@y + 1) * $TILE
		@window.draw_quad(xmin,ymin,Gosu::Color::BLACK,xmin,ymax,@color,xmax,ymax,@color,xmax,ymin,@color,1)
		@window.font.draw(@value.to_s, xmin+$TILE/12, ymin+$TILE/4, 1.0, 1.0, 1.0, 0xffffffff)
	end
end

class Minigamewindow < Gosu::Window
	attr_accessor :blocks, :grid, :font
	def initialize()
		super($WIDTH*$TILE, $HEIGHT*$TILE, false)
		self.caption = "Camera Hacking"
		@grid = Array.new(4, Array.new(4))
		@blocks = []
		@blocks << Block.new(self, 1, 2, 1)
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end
	def needs_cursor?
		true
	end
	def draw
		@blocks.each do |block|
			block.draw
		end
#		@background_image.draw(0,0,0)
	end
	def button_down(id)
	end
	def button_up(id)
	end
	def update	
	end
end

Minigamewindow.new().show