require 'gosu'
$WIDTH = 4
$HEIGHT = 4
$TILE = 48

def getcolor(value)
	case value
	when 1 then Gosu::Color::GREEN
	when 2 then Gosu::Color::BLUE
	when 4 then Gosu::Color::RED
	when 8 then Gosu::Color::YELLOW
	when 16 then Gosu::Color::AQUA
	else Gosu::Color::BLACK
	end
end

class Block
	attr_reader :value
	def initialize (window, value)
		@window = window
		@value = value
		@color = getcolor(value)
	end
	def draw(row,col)
		xmin = col * $TILE
		xmax = (col + 1) * $TILE
		ymin = row * $TILE
		ymax = (row + 1) * $TILE
		@window.draw_quad(xmin,ymin,Gosu::Color::BLACK,xmin,ymax,@color,xmax,ymax,@color,xmax,ymin,@color,1)
		@window.font.draw(@value.to_s, xmin+$TILE/12, ymin+$TILE/4, 1.0, 1.0, 1.0, 0xffffffff)
	end
end

class Minigamewindow < Gosu::Window
	attr_accessor :blocks, :grid, :font
	def initialize()
		super($WIDTH*$TILE, $HEIGHT*$TILE, false)
		self.caption = "Camera Hacking"
		@grid = []
		$HEIGHT.times do |row|
			@grid[row] = []
			$WIDTH.times do |col|
				@grid[row][col] = nil
			end
		end
		@grid[1][2] = Block.new(self, 1)
		@grid[1][3] = Block.new(self, 1)
		@grid[1][1] = Block.new(self, 2)
		@grid[1][0] = Block.new(self, 4)
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
	end
	def needs_cursor?
		true
	end
	def draw
		$HEIGHT.times do |row|
			$WIDTH.times do |col|
				unless @grid[row][col].nil?
					@grid[row][col].draw(row,col)
				end
			end
		end
#		@background_image.draw(0,0,0)
	end
	def button_down(id)
		case id
		when Gosu::KbLeft
			$HEIGHT.times do |row|
				$WIDTH.times do |pos|
					unless @grid[row][pos].nil?
						newpos = pos
						while @grid[row][newpos-1].nil? && newpos > 0
							newpos-=1
						end
						@grid[row][newpos] = @grid[row][pos]
						@grid[row][pos] = nil
					end
				end
				$WIDTH.times do |pos|
					if not(@grid[row][pos].nil?) && not(@grid[row][pos+1].nil?)
						if @grid[row][pos].value == @grid[row][pos+1].value
							newval = 2*@grid[row][pos].value
							@grid[row].delete_at(pos)
							@grid[row].delete_at(pos)
							@grid[row].insert(pos, Block.new(self, newval))
						end
					end
				end
			end
		when Gosu::KbRight
			$HEIGHT.times do |row|
				($WIDTH-1).downto(0) do |pos|
					unless @grid[row][pos].nil?
						newpos = pos
						while @grid[row][newpos+1].nil? && newpos < $WIDTH-1
							newpos+=1
						end
						@grid[row][newpos] = @grid[row][pos]
						@grid[row][pos] = nil
					end
				end
				($WIDTH-1).downto(1) do |pos|
					if not(@grid[row][pos].nil?) && not(@grid[row][pos-1].nil?)
						if @grid[row][pos].value == @grid[row][pos-1].value
							newval = 2*@grid[row][pos].value
							@grid[row].delete_at(pos-1)
							@grid[row].delete_at(pos-1)
							@grid[row].insert(0, nil)
							@grid[row].insert(pos, Block.new(self, newval))
						end
					end
				end
			end
		when Gosu::KbUp
			$WIDTH.times do |col|
				$HEIGHT.times do |row|
					unless @grid[row][col].nil?
						newrow = row
						while (newrow > 0) && @grid[newrow-1][col].nil?
							newrow-=1
						end
						@grid[newrow][col] = @grid[row][col]
						@grid[row][col] = nil
					end
				end
			end
		when Gosu::KbDown
			$WIDTH.times do |col|
				($HEIGHT-1).downto(0) do |row|
					unless @grid[row][col].nil?
						newrow = row
						while (newrow < $HEIGHT-1) && @grid[newrow+1][col].nil?
							newrow+=1
						end
						@grid[newrow][col] = @grid[row][col]
						@grid[row][col] = nil
					end
				end
			end
		end
	end
	def button_up(id)
	end
	def update	
	end
end

Minigamewindow.new().show