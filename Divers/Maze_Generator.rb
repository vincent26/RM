#==============================================================================#
#                           MINIGAME MAZE                                      #
#==============================================================================#
#Vincent26
#
###Description :
# Ce script permet de creer un minijeu de maze dans RM
# Un maze peut-être generer aleatoirement ou on peut utiliser un seed
# Lorsqu'un maze est generer son seed est afficher dans la console de RM
# Vous pouvez alors en generer beaucoup et choisir votre préferer en nottant
# son seed puis le regenerer a n'importe quelle moment

###Utilisation :
#De base le script utilise une image carrée qu'il decoupe en 4*5 , cette image
#peut_être de n'importe quelle dimension, elle est constituer des element qui
#forme le maze :
# |01|02|03|04|
# |05|06|07|08|
# |09|10|11|12|
# |13|14|15|16|
# |17|18|19|20|
#
# 01 => Cul de sac vers le haut (U a l'envers)
# 02 => Cul de sac vers droite (C a l'envers)
# 03 => Cul de sac vers la gauche (En C)
# 04 => Cul de sac vers le bas (En U)
# 05 => ╦
# 06 =>  ╣
# 07 => ╠
# 08 =>  ╩
# 09 => ╔
# 10 => ╗
# 11 =>  ╚
# 12 => ╝
# 13 => ║
# 14 => ═
# 15 => ╬
# 16 => Personnage
# 17 => Symbole Entrer
# 18 => Symbole Sortie

# l'image doit être importer dans le dossier system

# Faire un appel de script :
# SceneManager.call(Scene_Maze)
# SceneManager.scene.prepare(SIZEX,SIZEY[,SEED])
#
#SIZEX est la taille en x de votre maze
#SIZEY est la taille en y de votre maze
#SEED est en option il permet de pouvoir generer toujours le même maze
#si il est omis un maze aléatoire serat genere

# Le maze est automatiquement adapter pour ne pas sortir de l'écran

###CONFIGURATION
module Configuration
  
  #Switches a changer lors de la fin du maze:
  ID = 1
  #Choix de la visions de creation du maze
  SHOW = false
  #Vitesse de creation lors de la vue (1 etant le plus rapide)
  TIME = 1
  
end
class Scene_Maze < Scene_MenuBase
  
  def prepare(size_x,size_y,seed = nil)
    @size_x = size_x
    @size_y = size_y
    @seed = seed
  end
  
  def start
    super
    @i = 0
  end
  
  def make_maze
    @maze = Maze.new(30,30,@seed)
    @maze.create
    @maze.create_personnage
  end
  
  def update
    super
    @i += 1
    if @i == 20
      make_maze
      puts @maze.seed
    elsif @i > 20
      @maze.move_up    if Input.repeat?(:UP)
      @maze.move_down  if Input.repeat?(:DOWN)
      @maze.move_left  if Input.repeat?(:LEFT)
      @maze.move_right if Input.repeat?(:RIGHT)
      return_scene    if Input.repeat?(:B)
      if @maze.test_end
        $game_switches[Configuration::ID] = true
        return_scene
      end
    end
  end
  
end

class Maze
  
  attr_reader :id
  attr_reader :seed
  
  #Initialize
  def initialize(size1,size2,seed = nil)
    @sizex = size1
    @sizey = size2
    @table = Table.new(size1, size2,2)
    @seed = seed || rand(9999999999999999)
    puts @seed
    @sprite = Sprite.new
    @base = Cache.system("Maze")
    @w = @base.width/4
    @h = @base.height/5
    @bitmap = Bitmap.new(size1*@w,size2*@h)
    @sprite.ox = @bitmap.width/2
    @sprite.oy = @bitmap.height/2
    @sprite.x = Graphics.width/2
    @sprite.y = Graphics.height/2
    @zoom = 1
    if @sprite.y - @sprite.oy < 0
      @zoom = Graphics.height.to_f/@bitmap.height.to_f
    end
    zoom = 1
    if @sprite.x - @sprite.ox < 0
      zoom = Graphics.width.to_f/@bitmap.width.to_f
    end
    @zoom = [@zoom,zoom].min
    @sprite.zoom_x = @zoom
    @sprite.zoom_y = @zoom
  end
  
  #Create
  def create
    make_start
    make_end
    create_maze
    create_bitmap
  end
  
  #Creation du personnage
  def create_personnage
    @sprite_perso = Sprite.new
    @sprite_perso.z = 20
    @sprite_perso.ox = @bitmap.width/2
    @sprite_perso.oy = @bitmap.height/2
    @sprite_perso.x = Graphics.width/2
    @sprite_perso.y = Graphics.height/2
    @sprite_perso.zoom_x = @zoom
    @sprite_perso.zoom_y = @zoom
    @sprite_perso.bitmap = Bitmap.new(@sizex*@w,@sizey*@h)
    @id = @y_start*@sizex
    @sprite_perso.bitmap.blt(id_x_perso*@w,id_y_perso*@h,@base,Rect.new(@w*3,@h*3,@w,@h))
  end
  
  def id_x_perso
    return @id % @sizex
  end
  def id_y_perso
    return @id / @sizex
  end
  
  def create_bitmap_perso
    @sprite_perso.bitmap.clear
    @sprite_perso.bitmap.blt(id_x_perso*@w,id_y_perso*@h,@base,Rect.new(@w*3,@h*3,@w,@h))
  end
  
  def test_end
    if @table[id_x_perso,id_y_perso,1] == 1
      return true
    end
    return false
  end
  
  def move_up
    return if id_y_perso == 0
    return if [1,2,3,5,9,10,14].include?(@table[id_x_perso,id_y_perso,0])
    @id -= @sizex
    create_bitmap_perso
  end
  def move_down
    return if id_y_perso == @sizey-1
    return if [2,3,4,8,11,12,14].include?(@table[id_x_perso,id_y_perso,0])
    @id += @sizex
    create_bitmap_perso
  end
  def move_left
    return if id_x_perso == 0
    return if [1,3,4,7,9,11,13].include?(@table[id_x_perso,id_y_perso,0])
    @id -= 1
    create_bitmap_perso
  end
  def move_right
    return if id_x_perso == @sizex-1
    return if [1,2,4,6,10,12,13].include?(@table[id_x_perso,id_y_perso,0])
    @id += 1
    create_bitmap_perso
  end
  
  #Creation du start
  def make_start
    @y = 0#@seed % @sizey
    @y_start = @y
    @table[0,@y,0] = 2
    @table[0,@y,1] = 2
  end
  
  #Creation du end
  def make_end
    @y_end = @sizey-1#(2*@seed) % @sizey
    @table[@sizex-1,@y_end,0] = 3
    @table[@sizex-1,@y_end,1] = 1
  end
  
  #Creation du maze
  def create_maze
    @x = 0
    @i = @seed/2
    array = vide
    while array.length != 0
      @i += 1
      a = get_move(@x,@y)
      if a
        case a
        when 2;
          case @table[@x,@y,0]
          when 2; @table[@x,@y,0] = 10
          when 3; @table[@x,@y,0] = 9
          when 4; @table[@x,@y,0] = 13
          when 8; @table[@x,@y,0] = 15
          when 11; @table[@x,@y,0] = 7
          when 12; @table[@x,@y,0] = 6
          when 14; @table[@x,@y,0] = 5
          end
          @y += 1
          @table[@x,@y,0] = 4
        when 3;
          case @table[@x,@y,0]
          when 2; @table[@x,@y,0] = 10
          when 3; @table[@x,@y,0] = 9
          when 4; @table[@x,@y,0] = 13
          when 8; @table[@x,@y,0] = 15
          when 11; @table[@x,@y,0] = 7
          when 12; @table[@x,@y,0] = 6
          when 14; @table[@x,@y,0] = 5
          end
          @y += 1
          @table[@x,@y,0] = 11
        when 4;
          case @table[@x,@y,0]
          when 1; @table[@x,@y,0] = 10
          when 3; @table[@x,@y,0] = 14
          when 4; @table[@x,@y,0] = 12
          when 7; @table[@x,@y,0] = 15
          when 9; @table[@x,@y,0] = 5
          when 11; @table[@x,@y,0] = 8
          when 13; @table[@x,@y,0] = 6
          end
          @x -= 1
          @table[@x,@y,0] = 3
        when 6;
          case @table[@x,@y,0]
          when 1; @table[@x,@y,0] = 9
          when 2; @table[@x,@y,0] = 14
          when 4; @table[@x,@y,0] = 11
          when 6; @table[@x,@y,0] = 15
          when 10; @table[@x,@y,0] = 5
          when 12; @table[@x,@y,0] = 8
          when 13; @table[@x,@y,0] = 7
          end
          @x += 1
          @table[@x,@y,0] = 2
        when 7;
          case @table[@x,@y,0]
          when 1; @table[@x,@y,0] = 9
          when 2; @table[@x,@y,0] = 14
          when 4; @table[@x,@y,0] = 11
          when 6; @table[@x,@y,0] = 15
          when 10; @table[@x,@y,0] = 5
          when 12; @table[@x,@y,0] = 8
          when 13; @table[@x,@y,0] = 7
          end
          @x += 1
          @table[@x,@y,0] = 14
        when 8;
          case @table[@x,@y,0]
          when 1; @table[@x,@y,0] = 13
          when 2; @table[@x,@y,0] = 12
          when 3; @table[@x,@y,0] = 11
          when 5; @table[@x,@y,0] = 15
          when 9; @table[@x,@y,0] = 7
          when 10; @table[@x,@y,0] = 6
          when 14; @table[@x,@y,0] = 8
          end
          @y -= 1
          @table[@x,@y,0] = 1
        when 9;
          case @table[@x,@y,0]
          when 1; @table[@x,@y,0] = 13
          when 2; @table[@x,@y,0] = 12
          when 3; @table[@x,@y,0] = 11
          when 5; @table[@x,@y,0] = 15
          when 9; @table[@x,@y,0] = 7
          when 10; @table[@x,@y,0] = 6
          when 14; @table[@x,@y,0] = 8
          end
          @y -= 1
          @table[@x,@y,0] = 9
        end
      else
        result = restart
        ok = result[(@seed-@x*@y) % result.length]
        @x = ok[0]
        @y = ok[1]
        case ok[2]
        when 2;
          case @table[@x,@y-1,0]
          when 2; @table[@x,@y-1,0] = 10
          when 3; @table[@x,@y-1,0] = 9
          when 4; @table[@x,@y-1,0] = 13
          when 8; @table[@x,@y-1,0] = 15
          when 11; @table[@x,@y-1,0] = 7
          when 12; @table[@x,@y-1,0] = 6
          when 14; @table[@x,@y-1,0] = 5
          end
          @table[@x,@y,0] = 4
        when 4;
          case @table[@x+1,@y,0]
          when 1; @table[@x+1,@y,0] = 10
          when 3; @table[@x+1,@y,0] = 14
          when 4; @table[@x+1,@y,0] = 12
          when 7; @table[@x+1,@y,0] = 15
          when 9; @table[@x+1,@y,0] = 5
          when 11; @table[@x+1,@y,0] = 8
          when 13; @table[@x+1,@y,0] = 6
          end
          @table[@x,@y,0] = 3
        when 6;
          case @table[@x-1,@y,0]
          when 1; @table[@x-1,@y,0] = 9
          when 2; @table[@x-1,@y,0] = 14
          when 4; @table[@x-1,@y,0] = 11
          when 6; @table[@x-1,@y,0] = 15
          when 10; @table[@x-1,@y,0] = 5
          when 12; @table[@x-1,@y,0] = 8
          when 13; @table[@x-1,@y,0] = 7
          end
          @table[@x,@y,0] = 2
        when 8;
          case @table[@x,@y+1,0]
          when 1; @table[@x,@y+1,0] = 13
          when 2; @table[@x,@y+1,0] = 12
          when 3; @table[@x,@y+1,0] = 11
          when 5; @table[@x,@y+1,0] = 15
          when 9; @table[@x,@y+1,0] = 7
          when 10; @table[@x,@y+1,0] = 6
          when 14; @table[@x,@y+1,0] = 8
          end
          @table[@x,@y,0] = 1
        end
      end
      array.delete([@x,@y])
      if Configuration::SHOW
        test(@x,@y)
        test(@x+1,@y)
        test(@x-1,@y)
        test(@x,@y+1)
        test(@x,@y-1)
        update
      end
    end
    if @table[@sizex-1,@y_end,0] == 3
      array = [2,4,8]
      id = array[(@seed*5) % 3]
      case id        
      when 2;
        case @table[@sizex-1,@y_end+1,0]
        when 2; @table[@sizex-1,@y_end+1,0] = 10
        when 3; @table[@sizex-1,@y_end+1,0] = 9
        when 4; @table[@sizex-1,@y_end+1,0] = 13
        when 8; @table[@sizex-1,@y_end1,0] = 15
        when 11; @table[@sizex-1,@y_end+1,0] = 7
        when 12; @table[@sizex-1,@y_end+1,0] = 6
        when 14; @table[@sizex-1,@y_end+1,0] = 5
        end
        @table[@sizex-1,@y_end,0] = 9
      when 4;
        case @table[@sizex-2,@y_end,0]
        when 1; @table[@sizex-2,@y_end,0] = 10
        when 3; @table[@sizex-2,@y_end,0] = 14
        when 4; @table[@sizex-2,@y_end,0] = 12
        when 7; @table[@sizex-2,@y_end,0] = 15
        when 9; @table[@sizex-2,@y_end,0] = 5
        when 11; @table[@sizex-2,@y_end,0] = 8
        when 13; @table[@sizex-2,@y_end,0] = 6
        end
        @table[@sizex-1,@y_end,0] = 3
      when 6;
        case @table[@sizex,@y_end,0]
        when 1; @table[@sizex,@y_end,0] = 9
        when 2; @table[@sizex,@y_end,0] = 14
        when 4; @table[@sizex,@y_end,0] = 11
        when 6; @table[@sizex,@y_end,0] = 15
        when 10; @table[@sizex,@y_end,0] = 5
        when 12; @table[@sizex,@y_end,0] = 8
        when 13; @table[@sizex,@y_end,0] = 7
        end
        @table[@sizex-1,@y_end,0] = 2
      when 8;
        case @table[@sizex-1,@y_end-1,0]
        when 1; @table[@sizex-1,@y_end-1,0] = 13
        when 2; @table[@sizex-1,@y_end-1,0] = 12
        when 3; @table[@sizex-1,@y_end-1,0] = 11
        when 5; @table[@sizex-1,@y_end-1,0] = 15
        when 9; @table[@sizex-1,@y_end-1,0] = 7
        when 10; @table[@sizex-1,@y_end-1,0] = 6
        when 14; @table[@sizex-1,@y_end-1,0] = 8
        end
        @table[@sizex-1,@y_end,0] = 1
      end
    end
  end
  
  def test(i,j)
    return if i == @sizex
    return if i < 0
    return if j == @sizey
    return if j < 0
    id = @table[i,j,0]
    return if id == 0
    case id
    when 1; rect =  Rect.new(   0,   0,@w,@h)
    when 2; rect =  Rect.new(  @w,   0,@w,@h)
    when 3; rect =  Rect.new(2*@w,   0,@w,@h)
    when 4; rect =  Rect.new(3*@w,   0,@w,@h)
    when 5; rect =  Rect.new(   0,  @h,@w,@h)
    when 6; rect =  Rect.new(  @w,  @h,@w,@h)
    when 7; rect =  Rect.new(2*@w,  @h,@w,@h)
    when 8; rect =  Rect.new(3*@w,  @h,@w,@h)
    when 9; rect =  Rect.new(   0,2*@h,@w,@h)
    when 10; rect = Rect.new(  @w,2*@h,@w,@h)
    when 11; rect = Rect.new(2*@w,2*@h,@w,@h)
    when 12; rect = Rect.new(3*@w,2*@h,@w,@h)
    when 13; rect = Rect.new(   0,3*@h,@w,@h)
    when 14; rect = Rect.new(  @w,3*@h,@w,@h)
    when 15; rect = Rect.new(2*@w,3*@h,@w,@h)
    when  0; rect = Rect.new(3*@w,3*@h,@w,@h)
    end
    @bitmap.clear_rect(@w*i,@h*j,@w,@h)
    @bitmap.blt(@w*i,@h*j,@base,rect)
    @sprite.bitmap = @bitmap
  end
  
  
  def get_move(x,y)
    return false if @table[x,y,1] == 1
    array = []
    if (@table[x+1,y,1] == 1) && (@table[x+1,y,0] == 3) && (x+1 < @sizex)
      array.push(7)
    elsif (@table[x+1,y,0] == 0) && (x+1 < @sizex)
      array.push(6)
    end
    array.push(4) if (@table[x-1,y,0] == 0) && (x > 0)
    if (@table[x,y+1,1] == 1) && (@table[x,y+1,0] == 3) && (y+1 < @sizey)
      array.push(3)
    elsif (@table[x,y+1,0] == 0) && (y+1 < @sizey)
      array.push(2)
    end
    if (@table[x,y-1,1] == 1) && (@table[x,y-1,0] == 3) && (y > 0)
      array.push(9)
    elsif (@table[x,y-1,0] == 0) && (y > 0)
      array.push(8)
    end
    if array.length > 0
      id = (Math.log(@seed-x).to_i-Math.sqrt(y).to_i).abs % array.length if (@i/3) % 4 == 0
      id = (Math.log(@seed-x).to_i-Math.sqrt(x).to_i).abs % array.length if (@i/3) % 4 == 1
      id = (@seed-y*x-Math.sqrt(y).to_i).abs % array.length if (@i/3) % 4 == 2
      id = (Math.log(@seed).to_i).abs % array.length if (@i/3) % 4 == 3
      return array[id]
    end
    return false
  end
  
  def get_move2(x,y)
    array = []
    array.push(4) if (@table[x+1,y,0] != 0) && (x+1 < @sizex) &&(@table[x+1,y,1] != 1)
    array.push(6) if (@table[x-1,y,0] != 0) && (x-1 > -1) &&(@table[x-1,y,1] != 1)
    array.push(8) if (@table[x,y+1,0] != 0) && (y+1 < @sizey) &&(@table[x,y+1,1] != 1)
    array.push(2) if (@table[x,y-1,0] != 0) && (y-1 > -1) && (@table[x,y-1,1] != 1)
    if array.length > 0
      id = (Math.log(@seed-x).to_i-Math.sqrt(@i*y).to_i).abs % array.length if (@i/5) % 4 == 0
      id = (Math.log(@seed-x).to_i-Math.sqrt(@i*x).to_i).abs % array.length if (@i/5) % 4 == 1
      id = (@seed-y*x-Math.sqrt(@i*y).to_i).abs % array.length if (@i/5) % 4 == 2
      id = (Math.log(@seed).to_i-@i).abs % array.length if (@i/5) % 4 == 3
      return array[id]
    end
  end
  
  def restart
    result = []
    for i in 0..@sizex-1
      for j in 0..@sizey-1
        if @table[i,j,0] == 0
          a = get_move2(i,j)
          if a
            result.push([i,j,a])
          end
        end
      end
    end
    return result
  end
  
  def vide
    result = []
    for i in 0..@sizex-1
      for j in 0..@sizey-1
        result.push([i,j]) if @table[i,j,0] == 0
      end
    end
    return result
  end
  
  def create_bitmap
    for i in 0..@sizex-1
      for j in 0..@sizey-1
        id = @table[i,j,0]
        case id
        when 1; rect =  Rect.new(   0,   0,@w,@h)
        when 2; rect =  Rect.new(  @w,   0,@w,@h)
        when 3; rect =  Rect.new(2*@w,   0,@w,@h)
        when 4; rect =  Rect.new(3*@w,   0,@w,@h)
        when 5; rect =  Rect.new(   0,  @h,@w,@h)
        when 6; rect =  Rect.new(  @w,  @h,@w,@h)
        when 7; rect =  Rect.new(2*@w,  @h,@w,@h)
        when 8; rect =  Rect.new(3*@w,  @h,@w,@h)
        when 9; rect =  Rect.new(   0,2*@h,@w,@h)
        when 10; rect = Rect.new(  @w,2*@h,@w,@h)
        when 11; rect = Rect.new(2*@w,2*@h,@w,@h)
        when 12; rect = Rect.new(3*@w,2*@h,@w,@h)
        when 13; rect = Rect.new(   0,3*@h,@w,@h)
        when 14; rect = Rect.new(  @w,3*@h,@w,@h)
        when 15; rect = Rect.new(2*@w,3*@h,@w,@h)
        when  0; rect = Rect.new(3*@w,3*@h,@w,@h)
        end
        @bitmap.blt(@w*i,@h*j,@base,rect)
        if @table[i,j,1] == 2  #start
          rect = Rect.new(0,4*@h,@w,@h)
          @bitmap.blt(@w*i,@h*j,@base,rect)
        elsif @table[i,j,1] == 1  #end
          rect = Rect.new(@w,4*@h,@w,@h)
          @bitmap.blt(@w*i,@h*j,@base,rect)
        end
      end
    end
    @sprite.bitmap = @bitmap
  end
  
  def update
    loop do
      Graphics.update
      Input.update
      break if Graphics.frame_count % Configuration::TIME == 0
    end
  end
  
end
