=begin
Vincent26

Ce script permet de creer des map d'overlay mapping sans utiliser de logiciel externe
il est conçus pour creer des images adapter au script de Yami

Crédit non obligatoir pour ma part car ce script et juste un utilitaire
Sinon j'ai utiliser des script d'autre personne :
Bitmap exporteur et Screenshot de la map : Tsukihime
Gestion souris : V.M of D.T

Utilisation :

Il faut d'abord creer dans le dossier de votre jeu un dossier appeler "Overlay"
dans se dossier il faut 2 dossier un "Map" et l'autre "Ressource"
Dans le dossier ressource il faut mettre toute les ressource d'overlay dont vous disposer
le nom des fichier n'a pas d'importance

Dans le jeu appuyer sur la touche F6 pour lancer l'éditeur vous atterrirrez
directement sur la fenetre d'aide

lors de la sauvegarde les images sont creer dans le dossier Map que vous avez creé

Si vous utiliser d'autre script utilisant les touche F6,F7,F8 il est conseiller 
de les desactiver pour eviter un conflit de toute manière ce script peut-être 
supprimer ensuite

=end
module Map_Creator_Mod
  #Touche d'annulation (Comme CTRL+Z :D )
  TOUCHE_ANNULATION = Input::F9
  
  #Icon souris
  ICON_COUCHE_1 = 387
  ICON_COUCHE_2 = 397
  ICON_COUCHE_3 = 394
  ICON_DEPLACEMENT_MAP = 392
end
################################################################################
#                                                                              #
#             LANCEMENT DE L'EDITEUR                                           #
#                                                                              #
################################################################################
class Scene_Map < Scene_Base
  alias update_map_creator update
  def update
    update_map_creator
    SceneManager.call(Scene_Map_Creator) if Input.trigger?(:F6)
  end
end
################################################################################
#                                                                              #
#             CLASS PRINCIPALE DU CREATEUR MET EN PLACE LES IMAGES             #
#                                                                              #
################################################################################
class Map_Creator

  attr_reader :list
  
  def initialize
    @background_bitmap = Sprite.new
    @hud = Sprite.new
    @help = Sprite.new
    @image = Sprite.new
    @image.bitmap = Bitmap.new(1,1)
    @couche_1 = Sprite.new
    @couche_2 = Sprite.new
    @couche_3 = Sprite.new
    @couche_1.z =10
    @couche_2.z =20
    @couche_3.z =30
    @size = 1.0
    @couche_actuel = 0
    @taille_pictures_base = [0,0]
    @temp_bitmap = [[],[],[]]
    $cursor_map_creator.change_cursor(392)
    @name = ""
    @click_continue = false
    @coord_map_click = [0,0]
    $map_creator_background = Bitmap.new(544,416)
    make_list_ressource
    creation_hud
    creation_help
    creation_map
  end
  
  def creation_map
    s = Map_Saver_Map_Creator.new($game_map.map_id)
    s.set_scale(Tsuki::Map_Saver_Map_Creator::Mapshot_Scale)
    s.mapshot
    @background_bitmap.bitmap = $map_creator_background
  end
  
  def creation_hud
    bitmap = Bitmap.new(10,40)
    bitmap.font.size = 10
    bitmap.fill_rect(0, 0, 10, 10, Color.new(255, 0, 0))
    bitmap.fill_rect(0, 10, 10, 10, Color.new(0, 255, 0))
    bitmap.fill_rect(0, 20, 10, 10, Color.new(0, 0, 255))
    bitmap.fill_rect(0, 30, 10, 10, Color.new(255, 255, 255))
    bitmap.draw_text(0, 0, 10, 10, "1", 1) 
    bitmap.draw_text(0, 10, 10, 10, "2", 1) 
    bitmap.draw_text(0, 20, 10, 10, "3", 1)
    bitmap.draw_text(0, 30, 10, 10, "M", 1)
    @hud.bitmap = bitmap
    @hud.x = 0
    @hud.y = 0
    @hud.z = 200
  end
  def creation_help
    @help.bitmap = Bitmap.new(544,416)
    @help.bitmap.fill_rect(0, 0, 544, 200,Color.new(0, 0, 0))
    @help.bitmap.font.size = 20
    @help.bitmap.draw_text(0, 0, 544, 20, "Les 3 carrÃ©e de couleur en haut a gauche de l'Ã©cran corresponde au 3 couche d'overlay",0)
    @help.bitmap.draw_text(0, 24, 544, 20, "1 > GROUND   2 > PAR  3 > LIGTH",0)
    @help.bitmap.draw_text(0, 48, 544, 20, "Le carrÃ©e blanc permet de se dÃ©placer sur la map",0)
    @help.bitmap.draw_text(0, 72, 544, 20, "La touche F7 permet d'enregistrer les images de la map",0)
    @help.bitmap.draw_text(0, 96, 544, 20, "La touche F8 permet d'ouvrir/fermer l'aide",0)
    @help.bitmap.draw_text(0, 120, 544, 20, "Les touches Droite et Gauche permettent de changer rapidement de ressource",0)
    @help.bitmap.draw_text(0, 144, 544, 20, "La touche X permet d'ouvrir/fermer le menu de ressource",0)
    @help.bitmap.draw_text(0, 168, 544, 20, "La touche F9 permet d'annuler l'aposition d'une ressource sur la map (une seul fois)",0)
    @help.x = -544
    @help.y = 50
  end
  
  def change_help
    puts"change"
    @help.x = ((@help.x + 544) % 1088)*(-1)
    puts @help.x
  end
  
  def update
    if Input.trigger?(Map_Creator_Mod::TOUCHE_ANNULATION)
      if @temp_bitmap[@couche_actuel-1].length > 0
        puts "annulation"
        case @couche_actuel
        when 1; @couche_1.bitmap = @temp_bitmap[@couche_actuel-1][@temp_bitmap[@couche_actuel-1].length-1]
        when 2; @couche_2.bitmap = @temp_bitmap[@couche_actuel-1][@temp_bitmap[@couche_actuel-1].length-1]
        when 3; @couche_3.bitmap = @temp_bitmap[@couche_actuel-1][@temp_bitmap[@couche_actuel-1].length-1]
        end
        @temp_bitmap[@couche_actuel-1].pop
      end
    end
    if @couche_actuel == 0
      update_map
    else
      update_pictures
    end
    process_left if Input.trigger?(:LEFT)
    process_right if Input.trigger?(:RIGHT)
    process_up if Input.trigger?(:UP)
    click if Mouse_MC.lclick?(true)
    @click_continue = false if !Mouse_MC.lclick?(true)
    if @couche_actuel != 0 && ((Mouse_MC.pos?[0] > 12) || (Mouse_MC.pos?[1] > 42))
      ajout_element if Mouse_MC.lclick?(false)
    end
    process_save if Input.trigger?(:F7)
  end
  
  def process_left
    @name = @list[0] if @name == ""
    id = (@list.index(@name)-1) % @list.length
    name = @list[id]
    set_pictures_select(name)
  end
  def process_right
    @name = @list[0] if @name == ""
    id = (@list.index(@name)+1) % @list.length
    name = @list[id]
    set_pictures_select(name)
  end
  def process_up
    @size += 0.01
    new_w = @taille_pictures_base[0]*@size
    new_h = @taille_pictures_base[1]*@size
    resize(@image.bitmap, new_w, new_h)
  end
  
  def resize(bmp, new_w, new_h)
    b = Bitmap.new(new_w, new_h)
    b.blt(0, 0, bmp, Rect.new(0, 0, bmp.width, bmp.height))
    #bmp.dispose
    bmp = b
  end
  
  def update_pictures
    @image.x = Mouse_MC.pos?[0]
    @image.y = Mouse_MC.pos?[1]
    @image.z = @couche_actuel*10+9
  end
  
  def click
    @coord_mouse_click = Mouse_MC.pos? if !@click_continue
    @click_continue = true
    if (Mouse_MC.pos?[0] <= 10)&&(Mouse_MC.pos?[0] >= 0)
      if (Mouse_MC.pos?[1] <= 10)&&(Mouse_MC.pos?[1] >= 0)
        $cursor_map_creator.change_cursor(Map_Creator_Mod::ICON_COUCHE_1)
        @couche_actuel = 1
      elsif (Mouse_MC.pos?[1] <= 20)&&(Mouse_MC.pos?[1] > 10)
        $cursor_map_creator.change_cursor(Map_Creator_Mod::ICON_COUCHE_2)
        @couche_actuel = 2
      elsif (Mouse_MC.pos?[1] <= 30)&&(Mouse_MC.pos?[1] > 20)
        $cursor_map_creator.change_cursor(Map_Creator_Mod::ICON_COUCHE_3)
        @couche_actuel = 3
      elsif (Mouse_MC.pos?[1] <= 40)&&(Mouse_MC.pos?[1] > 30)
        @couche_actuel = 0
        $cursor_map_creator.change_cursor(Map_Creator_Mod::ICON_DEPLACEMENT_MAP)
      end
    end
  end
  
  def ajout_element
    case @couche_actuel
    when 1; bitmap = @couche_1.bitmap
    when 2; bitmap = @couche_2.bitmap
    when 3; bitmap = @couche_3.bitmap
    end
    bitmap = Bitmap.new(@background_bitmap.width,@background_bitmap.height) if bitmap == nil
    @temp_bitmap[@couche_actuel-1].push(bitmap.clone)
    x = @coord_map_click[0]*(-1) + @image.x - @image.ox
    y = @coord_map_click[1]*(-1) + @image.y - @image.oy
    rect = Rect.new(0, 0, @image.bitmap.width, @image.bitmap.height)
    bitmap.blt(x, y, @image.bitmap.clone, rect)
    case @couche_actuel
    when 1; @couche_1.bitmap = bitmap
    when 2; @couche_2.bitmap = bitmap
    when 3; @couche_3.bitmap = bitmap
    end
  end
  
  def update_map
    if @click_continue
      @background_bitmap.x = @coord_map_click[0] + Mouse_MC.pos?[0]-@coord_mouse_click[0]
      @background_bitmap.y = @coord_map_click[1] + Mouse_MC.pos?[1]-@coord_mouse_click[1]
      @couche_1.x = @background_bitmap.x
      @couche_2.x = @background_bitmap.x
      @couche_3.x = @background_bitmap.x
      @couche_1.y = @background_bitmap.y
      @couche_2.y = @background_bitmap.y
      @couche_3.y = @background_bitmap.y
    else
      @coord_map_click = [@background_bitmap.x,@background_bitmap.y]
    end
  end
  
  def make_list_ressource
    @list = []
    puts "ok"
    Dir.foreach("Overlay/Ressource") do |fichier|
      @list.push(fichier.to_s) if fichier.to_s != "." && fichier.to_s != ".."
    end
  end
  
  def set_pictures_select(name)
    @name = name
    @image.bitmap = Cache.load_bitmap("Overlay/Ressource/",name) rescue Bitmap.new(1,1)
    @image.ox = @image.bitmap.width/2
    @image.oy = @image.bitmap.height/2
    @taille_pictures_base = [@image.bitmap.width,@image.bitmap.height]
  end
  
  def process_save
    Save.bitmap(@couche_1.bitmap,"ground"+$game_map.map_id.to_s+"_1") rescue puts "Ground skipped"
    Save.bitmap(@couche_2.bitmap,"par"+$game_map.map_id.to_s+"_1") rescue puts "Par skipped"
    begin
      w = @couche_3.bitmap.width
      h = @couche_3.bitmap.height
      bitmap = Bitmap.new(w,h)
      bitmap.fill_rect(0, 0, w, h,Color.new(0, 0, 0))
      rect = Rect.new(0, 0, w, h)
      bitmap.blt(0,0, @couche_3.bitmap.clone, rect)
      Save.bitmap(bitmap,"light"+$game_map.map_id.to_s+"_1") 
    rescue 
      puts "Light skipped"
    end
  end
end
################################################################################
#                                                                              #
#             SCENE DE CREATION MAP OVERLAY                                    #
#                                                                              #
################################################################################
class Scene_Map_Creator < Scene_Base

  def start
    super
    $map_creator = Map_Creator.new
    @window_ressource = List_Ressource.new
    @window_ressource.set_handler(:ok,      method(:ok_ressource))
    @window_ressource.set_handler(:cancel,     method(:cancel_ressource))
    @window_ressource.hide
    @window_ressource.refresh
    $map_creator.change_help
  end
  
  def update
    if !@window_ressource.visible
      Graphics.update
      Input.update
      mouse_cursor_map_creator
      $map_creator.update
      $map_creator.change_help if Input.trigger?(:F8)
      acces_menu_ressource if Input.trigger?(:B)
    else
      Graphics.update
      Input.update
      mouse_cursor_map_creator
      @window_ressource.update
    end
  end
  
  def acces_menu_ressource
    @window_ressource.show
    @window_ressource.activate
    @window_ressource.select(0)
    @window_ressource.refresh
  end
  
  def ok_ressource
    $map_creator.set_pictures_select(@window_ressource.name_select)
    @window_ressource.hide
  end
  
  def cancel_ressource
    @window_ressource.hide
  end
end
################################################################################
#                                                                              #
#             FENETRE CHOIX RESSOURCE                                          #
#                                                                              #
################################################################################
class List_Ressource  < Window_Selectable
  attr_reader :data
  def initialize
    super(0, 0,544,416)
    @data = []
  end
  def col_max
    return 1
  end
  def item_width
    (272 - standard_padding * 2 + spacing) / col_max - spacing
  end
  def item_max
    @data ? @data.size : 1
  end
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  def make_item_list
    @data = $map_creator.list
  end
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
  end
  def refresh
    contents.clear
    make_item_list
    create_contents
    draw_all_items
    draw_item_picture
  end
  def draw_item_picture
    puts index
    bitmap = Cache.load_bitmap("Overlay/Ressource/",@data[index]) rescue Bitmap.new(1,1)
    rect = Rect.new(0, 0, bitmap.width, bitmap.height)
    x = [272,272+272/2-bitmap.width/2].max
    contents.blt(272, 416/2-bitmap.height/2, bitmap, rect)
  end
  def cursor_down(wrap = false)
    select((index+1) % @data.length)
    refresh
  end
  def cursor_up(wrap = false)
    select((index-1) % @data.length)
    refresh
  end
  def name_select
    return @data[index]
  end
end

################################################################################
#                                                                              #
#             CREATION ET EXPORTATION DES IMAGES                               #
#                                                                              #
################################################################################
module Zlib
  class Png_File < GzipWriter
    
    ARGB2BGRA = Win32API.new('System/argb2bgra.dll', 'ARGB2BGRA', 'PL', '')
    #--------------------------------------------------------------------------
    # â— Main
    #-------------------------------------------------------------------------- 
    def make_png(bitmap_Fx,mode)
      @mode = mode
      @bitmap_Fx = bitmap_Fx
      self.write(make_header)
      self.write(make_ihdr)
      self.write(make_idat)
      self.write(make_iend)
    end
    #--------------------------------------------------------------------------
    # â— PNG file header block
    #--------------------------------------------------------------------------
    def make_header
      return [0x89,0x50,0x4e,0x47,0x0d,0x0a,0x1a,0x0a].pack("C*")
    end
    #--------------------------------------------------------------------------
    # â— PNG file data block header information (IHDR)
    #-------------------------------------------------------------------------- 
    def make_ihdr
      ih_size = [13].pack("N")
      ih_sign = "IHDR"
      ih_width = [@bitmap_Fx.width].pack("N")
      ih_height = [@bitmap_Fx.height].pack("N")
      ih_bit_depth = [8].pack("C")
      ih_color_type = [6].pack("C")
      ih_compression_method = [0].pack("C")
      ih_filter_method = [0].pack("C")
      ih_interlace_method = [0].pack("C")
      string = ih_sign + ih_width + ih_height + ih_bit_depth + ih_color_type +
               ih_compression_method + ih_filter_method + ih_interlace_method
      ih_crc = [Zlib.crc32(string)].pack("N")
      return ih_size + string + ih_crc
    end
    #--------------------------------------------------------------------------
    # â— Generated image data (IDAT)
    #-------------------------------------------------------------------------- 
    def make_idat
      header = "\x49\x44\x41\x54"
      case @mode # please 54 ~
      when 1
        data = make_bitmap_data # 1
      else
        data = make_bitmap_data
      end
      data = Zlib::Deflate.deflate(data, 8)
      crc = [Zlib.crc32(header + data)].pack("N")
      size = [data.length].pack("N")
      return size + header + data + crc
    end
    #--------------------------------------------------------------------------
    # â— Requests from the Bitmap object 54 to generate image data in mode 1 
    # (please 54 ~)
    #-------------------------------------------------------------------------- 
    def make_bitmap_data1
      w = @bitmap_Fx.width
      h = @bitmap_Fx.height
      data = []
      for y in 0...h
        data.push(0)
        for x in 0...w
          color = @bitmap_Fx.get_pixel(x, y)
          red = color.red
          green = color.green
          blue = color.blue
          alpha = color.alpha
          data.push(red)
          data.push(green)
          data.push(blue)
          data.push(alpha)
        end
      end
      return data.pack("C*")
    end
    #--------------------------------------------------------------------------
    # â— Bitmap object from the image data generated in mode 0
    #-------------------------------------------------------------------------- 
    def make_bitmap_data
      w, h = @bitmap_Fx.width, @bitmap_Fx.height
      w_4  = w * 4
      #-----
      rdata_ptr   = DL::CPtr.new((@bitmap_Fx.object_id<<1)+16, 4)[0, 4].unpack('I')[0]
      bm_info_ptr = DL::CPtr.new(rdata_ptr+8, 4)[0, 4].unpack('I')[0]
      bm_data_ptr = DL::CPtr.new(bm_info_ptr+12, 4)[0, 4].unpack('I')[0]
      data        = DL::CPtr.new(bm_data_ptr)
      s           = "\0" * (w_4 * h)
      s.clear
      for i in 0 ... h
        s << "\0"
        t_data = data[0, w_4]
        if false
          for ix in 0 ... w
          x = ix * 4
          t_data[x+2], t_data[x] = t_data[x], t_data[x+2]
          end
        else
          ARGB2BGRA.call(t_data, w)
        end
        data = data - (w_4)
        s.concat(t_data)
      end
      return s
    end
    
    #--------------------------------------------------------------------------
    # â— PNG end of the file data blocks (IEND)
    #-------------------------------------------------------------------------- 
    def make_iend
      ie_size = [0].pack("N")
      ie_sign = "IEND"
      ie_crc = [Zlib.crc32(ie_sign)].pack("N")
      return ie_size + ie_sign + ie_crc
    end
  end
end
class Bitmap
  
  #--------------------------------------------------------------------------
  # â— Related
  #-------------------------------------------------------------------------- 
  def make_png(name="like", path="",mode=0)
    make_dir(path) if path != ""
    Zlib::Png_File.open("temp.gz") {|gz|
      gz.make_png(self,mode)
    }
    Zlib::GzipReader.open("temp.gz") {|gz|
      $read = gz.read
    }
    f = File.open(name,"wb")
    f.write($read)
    f.close
    File.delete('temp.gz') 
    end
  #--------------------------------------------------------------------------
  # â— Save the path generated
  #-------------------------------------------------------------------------- 
  def make_dir(path)
    dir = path.split("/")
    for i in 0...dir.size
      unless dir == "."
        add_dir = dir[0..i].join("/")
        begin
          Dir.mkdir(add_dir)
        rescue
        end
      end
    end
  end
  
  def export(name)
    make_png(name)
  end
end
module Save
  def self.bitmap(bitmap,name,dirName = "Overlay/Map")
    raise if !bitmap.is_a?(Bitmap)
    Dir.mkdir(dirName) unless File.directory?(dirName)
    filename = "%s\\%s.png" %[dirName, name]
    bitmap.export(filename)
    puts "bitmap saved at : "+filename
  end
end
################################################################################
#                                                                              #
#             GESTION DE LA SOURIS                                             #
#                                                                              #
################################################################################
CPOS = Win32API.new 'user32', 'GetCursorPos', ['p'], 'v'
WINX = Win32API.new 'user32', 'FindWindowEx', ['l','l','p','p'], 'i'
ASKS = Win32API.new 'user32', 'GetAsyncKeyState', ['p'], 'i'
SMET = Win32API.new 'user32', 'GetSystemMetrics', ['i'], 'i'
WREC = Win32API.new 'user32', 'GetWindowRect', ['l','p'], 'v'
SHOWMOUS = Win32API.new 'user32', 'ShowCursor', 'i', 'i'
SHOWMOUS.call(0)

module Mouse_MC
  def self.setup
    @enabled = true
    @delay = 0
    bwap = true if SMET.call(23) != 0
    bwap ? @lmb = 0x02 : @lmb = 0x01
    bwap ? @rmb = 0x01 : @rmb = 0x02
  end
  def self.update
    return false unless @enabled
    self.setup if @lmb.nil?
    @delay -= 1
    @window_loc = WINX.call(0,0,"RGSS PLAYER",0)
    if ASKS.call(@lmb) == 0 then @l_clicked = false end
    if ASKS.call(@rmb) == 0 then @r_clicked = false end
    rect = '0000000000000000'
    cursor_pos = '00000000'
    WREC.call(@window_loc, rect)
    side, top = rect.unpack("ll")
    CPOS.call(cursor_pos)
    @m_x, @m_y = cursor_pos.unpack("ll")
    w_x = side + SMET.call(5) + SMET.call(45)
    w_y = top + SMET.call(6) + SMET.call(46) + SMET.call(4)
    @m_x -= w_x; @m_y -= w_y
    return true
  end
  def self.pos?
    return[-50,-50] unless self.update
    return [@m_x, @m_y]
  end
  def self.lclick?(repeat = false)
    return unless self.update
    return false if @l_clicked
    if ASKS.call(@lmb) != 0 then
      @l_clicked = true if !repeat
      return true end
  end
  def self.rclick?(repeat = false)
    return unless self.update
    return false if @r_clicked
    if ASKS.call(@rmb) != 0 then
      @r_clicked = true if !repeat
      return true end
  end
  def self.slowpeat
    return unless self.update
    return false if @delay > 0
    @delay = 120
    return true
  end
  def self.within?(rect)
    return unless self.update
    return false if @m_x < rect.x or @m_y < rect.y
    bound_x = rect.x + rect.width; bound_y = rect.y + rect.height
    return true if @m_x < bound_x and @m_y < bound_y
    return false
  end
  def self.disable
    @enabled = false
    SHOWMOUS.call(1)
  end
  def self.enable
    @enabled = true
    SHOWMOUS.call(0)
  end
end
 
Mouse_MC.setup
 
module DataManager
  class << self
    alias mouse_init_mc init
  end
  def self.init
    mouse_init_mc
    $cursor_map_creator = Mouse_Cursor_Map_Creator.new
  end
end
 
class Scene_Base
  alias cursor_update_map_creator update_basic
  def update_basic
    cursor_update_map_creator
    mouse_cursor_map_creator
  end
  def mouse_cursor_map_creator
    pos = Mouse_MC.pos?
    $cursor_map_creator.x = pos[0]
    $cursor_map_creator.y = pos[1]
  end
end
 
class Mouse_Cursor_Map_Creator < Sprite_Base
  def initialize
    super
    draw_cursor
    self.z = 255
  end
  def draw_cursor
    self.bitmap = nil
    change_cursor(394)
  end
  def change_cursor(id)
    self.bitmap = Cache.system("IconSet")
    self.src_rect.set(id % 16 * 24, id / 16 * 24, 24, 24)  
  end
end
################################################################################
#                                                                              #
#             CREATION DU FOND DE CARTE                                        #
#                                                                              #
################################################################################
$imported = {} if $imported.nil?
$imported["Tsuki_MapSaver"] = true
#==============================================================================
# ** Configuration
# Some settings you can customize
#==============================================================================
module Tsuki
  module Map_Saver_Map_Creator
    
    #Mapshot options. This takes an image of the entire map
    Mapshot_Scale = 1
    Mapshot_Button = Input::F7
    
    #Should events be drawn in the image?
    Draw_Events = false
    
    #Should the game player be drawn in the image?
    Draw_Player = false
    Draw_Followers = false
    
    #Should shadows be drawn? What color?
    Draw_Shadow = false
    Shadow_Color = Color.new(0, 0, 0, 128)
    
    #Should damage tiles be highlighted? What color?
    Highlight_Damage = true
    Damage_Color = Color.new(128, 0, 0, 128)
    
    #Should regions be drawn?
    #And at what opacity (0 = transparent, 255 = opaque)
    Draw_Regions = false
    Region_Opacity = 160
    
    #Set this to true if your game crashes when trying to save image
    #Specify format to fallback to if your game crashes: choice of [bmp, png]
    Crashes = false
    Crash_Format = "png"
    
    ###Not implemented yet###
    Draw_Vehicles = false
  end
end

#==============================================================================
# ** Module: Map_Tiles
# Contains data and methods useful for working with maps and tiles
#==============================================================================

module Map_Tiles_Map_Creator
  
  AUTOTILE_PARTS = [[18,17,14,13], [ 2,14,17,18], [13, 3,17,18], [ 2, 3,17,18],
                    [13,14,17, 7], [ 2,14,17, 7], [13, 3,17, 7], [ 2, 3,17, 7],
                    [13,14, 6,18], [ 2,14, 6,18], [13, 3, 6,18], [ 2, 3, 6,18],
                    [13,14, 6, 7], [ 2,14, 6, 7], [13, 3, 6, 7], [ 2, 3, 6, 7],
                    [16,17,12,13], [16, 3,12,13], [16,17,12, 7], [12, 3,16, 7], 
                    [10, 9,14,13], [10, 9,14, 7], [10, 9, 6,13], [10, 9, 6, 7],
                    [18,19,14,15], [18,19, 6,15], [ 2,19,14,15], [ 2,19, 6,15],
                    [18,17,22,21], [ 2,17,22,21], [18, 3,22,21], [ 2, 3,21,22],
                    [16,19,12,15], [10, 9,22,21], [ 8, 9,12,13], [ 8, 9,12, 7],
                    [10,11,14,15], [10,11, 6,15], [18,19,22,23], [ 2,19,22,23],
                    [16,17,20,21], [16, 3,20,21], [ 8,11,12,15], [ 8, 9,20,21],
                    [16,19,20,23], [10,11,22,23], [ 8,11,20,23], [ 0, 1, 4, 5]]
  WATERFALL_PIECES = [[ 2, 1, 6, 5], [ 0, 1, 4, 5], [ 2, 3, 6, 7], [0, 3, 4, 7]]
  WALL_PIECES =  [[10, 9, 6, 5], [ 8, 9, 4, 5], [ 2, 1, 6, 5], [ 0, 1, 4, 5],
                  [10,11, 6, 7], [ 8,11, 4, 7], [ 2, 3, 6, 7], [ 0, 3, 4, 7],
                  [10, 9,14,13], [ 8, 9,12,13], [ 2, 1,14,13], [ 0, 1,12,13],
                  [10,11,14,15], [8, 11,12,15], [ 2, 3,14,15], [ 0, 3,12,15]]

  A1_TILES = [[0, 0], [0, 96], [192, 0], [192, 96],
               [256, 0], [448, 0], [256, 96], [448, 96],
               [0, 192], [192, 192], [0, 288], [192, 288],
               [256, 192], [448, 192], [256, 288], [448, 288]]
    
  
  #--------------------------------------------------------------------------
  # * Checks if a tile is a wall
  #--------------------------------------------------------------------------
  def is_wall?(data)
    return true if data.between?(2288, 2335)
    return true if data.between?(2384, 2431)
    return true if data.between?(2480, 2527)
    return true if data.between?(2576, 2623)
    return true if data.between?(2672, 2719)
    return true if data.between?(2768, 2815)
    return true if data.between?(4736, 5119)
    return true if data.between?(5504, 5887)
    return true if data.between?(6272, 6655)
    return true if data.between?(7040, 7423)
    return true if data > 7807
    false
  end
  #--------------------------------------------------------------------------
  # * Checks if a tile is roof
  #--------------------------------------------------------------------------
  def is_roof?(data)
    return true if data.between?(4352, 4735)
    return true if data.between?(5120, 5503)
    return true if data.between?(5888, 6271)
    return true if data.between?(6656, 7039)
    return true if data.between?(7424, 7807)
    false
  end  
  #--------------------------------------------------------------------------
  # * Checks if a tile is soil
  #--------------------------------------------------------------------------
  def is_soil?(data)
    return true if data.between?(2816, 4351) && !is_table?(data)
    return true if data > 1663 && !is_stair?(data)
    false
  end    
  #--------------------------------------------------------------------------
  # * Checks if a tile is a stair
  #--------------------------------------------------------------------------
  def is_stair?(data)
     return true if data.between?(1541, 1542)
     return true if data.between?(1549, 1550)
     return true if data.between?(1600, 1615)
     false
  end
  #--------------------------------------------------------------------------
  # * Checks if a tile is a table
  #--------------------------------------------------------------------------
  def is_table?(data)
    return true if data.between?(3152, 3199)
    return true if data.between?(3536, 3583)
    return true if data.between?(3920, 3967)
    return true if data.between?(4304, 4351)
    false
  end
 
  #--------------------------------------------------------------------------
  # * The tileset to be used
  #--------------------------------------------------------------------------
  def tileset
    $data_tilesets[@tileset_id]
  end
  
  #--------------------------------------------------------------------------
  # * Region ID
  #--------------------------------------------------------------------------
  def region_id(x, y)
    valid?(x, y) ? @map.data[x, y, 3] >> 8 : 0
  end
  
  #--------------------------------------------------------------------------
  # * Gets all of the tiles for each layer at position x,y
  #--------------------------------------------------------------------------
  def layered_tiles(x, y)
    [2, 1, 0].collect {|z| @map.data[x, y, z] }
  end
  
  def layered_tiles_flag?(x, y, bit)
    layered_tiles(x, y).any? {|tile_id| tileset.flags[tile_id] & bit != 0 }
  end
   
  def valid?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end
  
  def damage_floor?(x, y)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x100)
  end
  
  #--------------------------------------------------------------------------
  # * Specifies which type of autotile is used
  #--------------------------------------------------------------------------
  def auto_tile(id)
    id / 48
  end
  
  #--------------------------------------------------------------------------
  # * Specifies the specific arrangement of autotiles used
  #--------------------------------------------------------------------------
  def auto_index(id)
    id % 48
  end
  
  #--------------------------------------------------------------------------
  # * Put the auto-tile pieces together
  #--------------------------------------------------------------------------
  def make_autotile(rects, sx, sy)
    @tile.clear
    for i in 0...4
      @auto_rect.x = (rects[i] % 4) * 16 + sx
      @auto_rect.y = (rects[i] / 4) * 16 + sy
      @tile.blt((i % 2) * 16,(i / 2) * 16, @tilemap, @auto_rect)
    end
  end
     
  #--------------------------------------------------------------------------
  # * Get auto-tile A1 tiles
  #--------------------------------------------------------------------------
  def autotile_A1(tile_id)
    @tilemap = @bitmaps[0]
    autotile = tile_id / 48
    auto_id = tile_id % 48
    sx, sy = A1_TILES[autotile]
    if is_wall?(tile_id + 2048)
      rects = WATERFALL_PIECES[auto_id]
    else  
      rects = AUTOTILE_PARTS[auto_id]
    end
    make_autotile(rects, sx, sy)
  end
  
  #--------------------------------------------------------------------------
  # * Get auto-tile A2 tiles.
  # 64x96 tiles, 8 per row, 4 rows
  #--------------------------------------------------------------------------
  def autotile_A2(tile_id)
    autotile = tile_id / 48
    auto_id = tile_id % 48
    @tilemap = @bitmaps[1]
    sx = (autotile % 8) * 64
    sy = (autotile / 8 % 4) * 96
    rects = AUTOTILE_PARTS[auto_id]
    make_autotile(rects, sx, sy)
  end
  
  #--------------------------------------------------------------------------
  # * Get auto-tile A3 tiles.
  # 64x64 tiles, 8 per row, 4 rows
  #--------------------------------------------------------------------------
  def autotile_A3(tid)
    @tilemap = @bitmaps[2]
    sx = (auto_tile(tid) % 8) * 64
    sy = (auto_tile(tid) / 8 % 4) * 64
    rects = WALL_PIECES[auto_index(tid)]
    make_autotile(rects, sx, sy)
  end
  
  #--------------------------------------------------------------------------
  # * Get auto-tile A4 tiles (walls)
  #--------------------------------------------------------------------------
  def autotile_A4(tile_id)
    @tilemap = @bitmaps[3]
    autotile = tile_id / 48
    auto_id = tile_id % 48
    sx = (autotile % 8) * 64
    sy = (autotile / 16 * 160) + (autotile / 8 % 2) * 96
    if is_wall?(tile_id + 5888)
      rects = WALL_PIECES[auto_id]
    else
      rects = AUTOTILE_PARTS[auto_id]
    end 
    make_autotile(rects, sx, sy)
  end
  
  #--------------------------------------------------------------------------
  # * Get auto-tile A5 tiles (normal)
  #--------------------------------------------------------------------------
  def autotile_A5(tile_id)
    @tilemap = @bitmaps[4]
    sx = (tile_id) % 8 * tilesize
    sy = (tile_id) / 8 * tilesize
    @src_rect.set(sx, sy, tilesize, tilesize)
    @tile.clear
    @tile.blt(0, 0, @tilemap, @src_rect)
  end
  
  #--------------------------------------------------------------------------
  # * Get normal tiles B, C, D, E
  #--------------------------------------------------------------------------
  def normal_tile(tile_id)
    @tilemap = @bitmaps[5 + tile_id / 256]
    sx = (tile_id / 128 % 2 * 8 + tile_id % 8) * tilesize;
    sy = (tile_id % 256 / 8 % 16) * tilesize;
    @src_rect.set(sx, sy, tilesize, tilesize)
    @tile.clear
    @tile.blt(0, 0, @tilemap, @src_rect)
  end
   
  #--------------------------------------------------------------------------
  # * Get bitmap for the specified tile id
  #--------------------------------------------------------------------------
  def get_bitmap(id)
    if id < 1024
      normal_tile(id)
    elsif id < 1664
      autotile_A5(id - 1536)
    elsif id < 2816
      autotile_A1(id - 2048)
    elsif id < 4352
      autotile_A2(id - 2816)
    elsif id < 5888
      autotile_A3(id - 4352)
    else
      autotile_A4(id - 5888)
    end
  end
end

class Game_Vehicle
  attr_reader :map_id
end

#==============================================================================
# ** 
#==============================================================================

class Map_Saver_Map_Creator
  include Tsuki::Map_Saver_Map_Creator
  include Map_Tiles_Map_Creator
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------

  SHADOW_COLOR = Tsuki::Map_Saver_Map_Creator::Shadow_Color
  DAMAGE_COLOR = Tsuki::Map_Saver_Map_Creator::Damage_Color
  REGION_COLORS = { 0 => Color.new(0, 0, 0, 0),
                    1 => Color.new(183, 95, 95, Region_Opacity),
                    2 => Color.new(183, 139, 95, Region_Opacity),
                    3 => Color.new(183, 183, 95, Region_Opacity),
                    4 => Color.new(140, 183, 95, Region_Opacity),
                    5 => Color.new(95, 183, 95, Region_Opacity),
                    6 => Color.new(95, 183, 139, Region_Opacity),
                    7 => Color.new(95, 183, 182, Region_Opacity),
                    8 => Color.new(0, 0, 0, 0),
                    9 => Color.new(0, 0, 0, 0),
                    10 => Color.new(0, 0, 0, 0),
                    11 => Color.new(0, 0, 0, 0),
                    12 => Color.new(0, 0, 0, 0),
                    13 => Color.new(0, 0, 0, 0),
                    14 => Color.new(0, 0, 0, 0),
                    15 => Color.new(0, 0, 0, 0),
                    16 => Color.new(0, 0, 0, 0),
                    17 => Color.new(0, 0, 0, 0),
                    18 => Color.new(0, 0, 0, 0),
                    19 => Color.new(0, 0, 0, 0),
                    20 => Color.new(0, 0, 0, 0),
                    21 => Color.new(0, 0, 0, 0),
                    22 => Color.new(0, 0, 0, 0),
                    23 => Color.new(0, 0, 0, 0),
                    24 => Color.new(0, 0, 0, 0),
                    25 => Color.new(0, 0, 0, 0),
                    26 => Color.new(0, 0, 0, 0),
                    27 => Color.new(0, 0, 0, 0),
                    28 => Color.new(0, 0, 0, 0),
                    29 => Color.new(0, 0, 0, 0),
                    30 => Color.new(0, 0, 0, 0),
                    31 => Color.new(0, 0, 0, 0),
                    32 => Color.new(0, 0, 0, 0),
                    33 => Color.new(0, 0, 0, 0),
                    34 => Color.new(0, 0, 0, 0),
                    35 => Color.new(0, 0, 0, 0),
                    36 => Color.new(0, 0, 0, 0),
                    37 => Color.new(0, 0, 0, 0),
                    38 => Color.new(0, 0, 0, 0),
                    39 => Color.new(0, 0, 0, 0),
                    40 => Color.new(0, 0, 0, 0),
                    41 => Color.new(0, 0, 0, 0),
                    42 => Color.new(0, 0, 0, 0),
                    43 => Color.new(0, 0, 0, 0),
                    44 => Color.new(0, 0, 0, 0),
                    45 => Color.new(0, 0, 0, 0),
                    46 => Color.new(0, 0, 0, 0),
                    47 => Color.new(0, 0, 0, 0),
                    48 => Color.new(0, 0, 0, 0),
                    49 => Color.new(0, 0, 0, 0),
                    50 => Color.new(0, 0, 0, 0),
                    51 => Color.new(0, 0, 0, 0),
                    52 => Color.new(0, 0, 0, 0),
                    53 => Color.new(0, 0, 0, 0),
                    54 => Color.new(0, 0, 0, 0),
                    55 => Color.new(0, 0, 0, 0),
                    56 => Color.new(0, 0, 0, 0),
                    57 => Color.new(0, 0, 0, 0),
                    58 => Color.new(0, 0, 0, 0),
                    59 => Color.new(0, 0, 0, 0),
                    60 => Color.new(0, 0, 0, 0),
                    61 => Color.new(0, 0, 0, 0),
                    62 => Color.new(0, 0, 0, 0),
                    63 => Color.new(0, 0, 0, 0)
                   }

  #--------------------------------------------------------------------------
  # * Public instance variables
  #--------------------------------------------------------------------------
  attr_reader :map_image
  attr_accessor :screen_local
  attr_accessor :scale
  attr_accessor :draw_layer0
  attr_accessor :draw_layer1
  attr_accessor :draw_layer2
  attr_accessor :draw_shadow
  attr_accessor :draw_regions
  attr_accessor :draw_damage
  attr_accessor :draw_vehicles
  attr_accessor :draw_events
  attr_accessor :draw_player
  
  def initialize(map_id=$game_map.map_id, x=$game_player.x, y=$game_player.y)
    @scale = 1
    @local_x = x
    @local_y = y
    @screen_local = false
    @shadow_bitmap = Bitmap.new(128, 128)
    @draw_layer0 = true
    @draw_layer1 = true
    @draw_layer2 = true
    @draw_events = Draw_Events
    @draw_vehicles = Draw_Vehicles
    @draw_player = Draw_Player
    @draw_followers = Draw_Followers
    @draw_shadow = Draw_Shadow
    @draw_damage = Highlight_Damage
    @draw_regions = Draw_Regions
    @tile = Bitmap.new(32, 32) #stores the current tile to be drawn
    @tilemap = nil
    @src_rect = Rect.new
    @auto_rect = Rect.new(0, 0, tilesize / 2, tilesize/ 2) #constant
    @tile_rect = Rect.new(0, 0, tilesize, tilesize)        #constant
  end
  
  def load_tilesets
    bitmaps = []
    tileset.tileset_names.each_with_index do |name, i|
      bitmaps[i] = Cache.tileset(name)
    end
    return bitmaps
  end
  
  #--------------------------------------------------------------------------
  # * Refresh, possibly with a new map
  #--------------------------------------------------------------------------
  def redraw(map_id=$game_map.map_id, x=$game_player.x, y=$game_player.y)
    @map_image.dispose if @map_image
    @map_id = map_id
    @local_x = x
    @local_y = y
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
    @map_info = $data_mapinfos[map_id]
    @screen = $game_map.screen
    @tileset_id = @map.tileset_id
    @bitmaps = load_tilesets
    
    get_bounds
    @map_image = Bitmap.new(@width * tilesize, @height * tilesize)
    draw_map
    scale_map if @scale != 1
  end
  
  #--------------------------------------------------------------------------
  # * Pre-process. These will never change when drawing the map. 
  #--------------------------------------------------------------------------
  def get_bounds
    @start_x = start_x
    @start_y = start_y
    @end_x = end_x
    @end_y = end_y
    @width = width
    @height = height
    @tilesize = tilesize
  end
  
  def screen_tile_x
    Graphics.width / 32
  end
  
  def screen_tile_y
    Graphics.height / 32
  end
  
  #--------------------------------------------------------------------------
  # * Sets the scale for the map
  #--------------------------------------------------------------------------
  def set_scale(scale)
    @scale = scale
  end
  
  #--------------------------------------------------------------------------
  # * Size of a tile
  #--------------------------------------------------------------------------
  def tilesize
    32
  end
  
  #--------------------------------------------------------------------------
  # * Width and height of the map, both locally and globally
  #--------------------------------------------------------------------------
  def width
    end_x - @start_x
  end
  
  def height
    end_y - @start_y
  end
  
  #--------------------------------------------------------------------------
  # * Starting and end positions, relative to the screen or map
  #--------------------------------------------------------------------------
  def start_x
    @screen_local ? [[$game_player.x - screen_tile_x / 2, @map.width - screen_tile_x].min, 0].max : 0
  end

  def start_y
    @screen_local ? [[$game_player.y - screen_tile_y / 2, @map.height - screen_tile_y].min, 0].max : 0
  end
  
  def end_x
    @screen_local ? [[screen_tile_x, @local_x + screen_tile_x / 2 + 1].max, @map.width].min : @map.width
  end
  
  def end_y
    @screen_local ? [[screen_tile_y, @local_y + screen_tile_y / 2 + 1].max, @map.height].min : @map.height
  end

  #--------------------------------------------------------------------------
  # * Draw tile onto image. x and y values are absolute coords. They should
  # be re-mapped based on the start_x and start_y values
  #--------------------------------------------------------------------------
  def draw_tile(x, y, tile, rect)
    ox = (x - @start_x) * tilesize
    oy = (y - @start_y) * tilesize
    @map_image.blt(ox, oy, tile, rect)
  end
  
  #--------------------------------------------------------------------------
  # * Get bitmap for the specified character
  #--------------------------------------------------------------------------
  def get_character_bitmap(name)
    charmap = Cache.character(name)
    sign = name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = charmap.width / 3
      ch = charmap.height / 4
    else
      cw = charmap.width / 12
      ch = charmap.height / 8
    end
    return charmap, cw, ch
  end
  
  #--------------------------------------------------------------------------
  # * Draw the character onto the tile
  #--------------------------------------------------------------------------
  def set_character_bitmap(character, x, y)
    charmap, cw, ch = get_character_bitmap(character.character_name)
    index = character.character_index
    pattern = character.pattern < 3 ? character.pattern : 1
    sx = (index % 4 * 3 + pattern) * cw
    sy = (index / 4 * 4 + (character.direction - 2) / 2) * ch
    @src_rect.set(sx, sy, cw, ch)
    x -= cw / (@tilesize * 2) if cw >= @tilesize
    y -= ch / (@tilesize * 2) if ch >= @tilesize  
    draw_tile(x, y, charmap, @src_rect)
  end
  
  #--------------------------------------------------------------------------
  # * create the shadow map
  #--------------------------------------------------------------------------
  def make_shadow_map
    for s in 0 ... 16
      x = s % 4
      y = s / 4
      if s & 0b1000 == 0b1000
        @shadow_bitmap.fill_rect(x*tilesize+16, y*@tilesize+16, 16, 16, SHADOW_COLOR)
      end
      if s & 0b0100 == 0b0100
        @shadow_bitmap.fill_rect(x*tilesize, y*@tilesize+16, 16, 16, SHADOW_COLOR)
      end
      if s & 0b0010 == 0b0010
        @shadow_bitmap.fill_rect(x*tilesize+16, y*@tilesize, 16, 16, SHADOW_COLOR)
      end
      if s & 0b0001 == 0b0001
        @shadow_bitmap.fill_rect(x*tilesize, y*@tilesize, 16, 16, SHADOW_COLOR)
      end
    end
  end
  
  def draw_parallax
    image = Cache.parallax(@map.parallax_name)
    @src_rect.set(0, 0, image.width, image.height)
    @map_image.blt(0, 0, image, @src_rect)
  end
  
  #--------------------------------------------------------------------------
  # * Draw the shadow map
  #--------------------------------------------------------------------------
  def draw_shadow_map
    for x in @start_x ... @end_x
      for y in @start_y ... @end_y
      _x, _y = x*@tilesize, y*@tilesize
        s = @map.data[x, y, 3]  & 0b1111
        if s != 0
          x_ = (s % 4) * @tilesize
          y_ = (s / 4) * @tilesize
          @src_rect.set(x_, y_, @tilesize, @tilesize)
          draw_tile(x, y, @shadow_bitmap, @src_rect)
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw the specified layer
  #--------------------------------------------------------------------------
  def draw_layer(layer)
    for x in @start_x ... @end_x
      for y in @start_y ... @end_y
        _x, _y = x*@tilesize, y*@tilesize
        tile_id = @map.data[x, y, layer]
        next if tile_id == 0
        get_bitmap(tile_id)
        draw_tile(x, y, @tile, @tile_rect)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Draw the game player
  #--------------------------------------------------------------------------
  def draw_player
    set_character_bitmap($game_player, $game_player.x, $game_player.y) if @map_id == $game_map.map_id
  end
  
  def draw_followers
  end
  
  #--------------------------------------------------------------------------
  # * Draw map events
  #--------------------------------------------------------------------------
  def draw_events
    @map.events.values.each do |event|
      id = event.pages[0].graphic.tile_id
      char_name = event.pages[0].graphic.character_name
      if id > 0
        normal_tile(id)
        draw_tile(event.x, event.y, @tilemap, @src_rect)
      elsif char_name != ""
        set_character_bitmap(event.pages[0].graphic, event.x, event.y)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw map vehicles
  #--------------------------------------------------------------------------
  def draw_vehicles
    $game_map.vehicles.each do |vehicle|
      set_character_bitmap(vehicle, vehicle.x, vehicle.y,) if @map_id == vehicle.map_id
    end
  end
  
  #--------------------------------------------------------------------------
  # * Draw map sprites
  #--------------------------------------------------------------------------
  def draw_sprites
    draw_events if @draw_events
    draw_vehicles if @draw_vehicles
    draw_player if @draw_player
    draw_followers if @draw_followers
  end
  
  #--------------------------------------------------------------------------
  # * Highlight damage tiles
  #--------------------------------------------------------------------------
  def draw_damage
    @tile.clear
    @tile.fill_rect(0, 0, @tilesize, @tilesize, DAMAGE_COLOR)
    @src_rect.set(0, 0, @tilesize, @tilesize)
    for x in @start_x ... @end_x
      for y in @start_y ... @end_y
        _x, _y = x*@tilesize, y*@tilesize
        if damage_floor?(x, y)
          draw_tile(x, y, @tile, @src_rect)
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Highlight regions
  #--------------------------------------------------------------------------
  def draw_regions
    for x in @start_x ... @end_x
      for y in @start_y ... @end_y
        _x, _y = x*@tilesize, y*@tilesize
        @tile.fill_rect(0, 0, @tilesize, @tilesize, REGION_COLORS[region_id(x,y)])
        draw_tile(x, y, @tile, @src_rect)
      end
    end
  end
  
  def draw_screen_effects
  end
  #--------------------------------------------------------------------------
  # * Draw the map
  #--------------------------------------------------------------------------
  def draw_map
    make_shadow_map if @draw_shadow
    draw_parallax
    draw_layer(0)
    draw_layer(1)
    draw_shadow_map
    draw_layer(2)
    draw_damage if @draw_damage
    draw_regions if @draw_regions
    draw_sprites
    draw_screen_effects
  end
  
  #--------------------------------------------------------------------------
  # * Scale the map
  #--------------------------------------------------------------------------
  def scale_map
    nw = @width * @scale
    nh = @height * @scale
    @src_rect.set(0, 0, @width, @height)
    scaled_map = Bitmap.new(nw, nh)
    scaled_rect = Rect.new(0, 0, nw, nh)
    scaled_map.stretch_blt(scaled_rect, @map_image, @src_rect)
    @map_image = scaled_map
  end
  
  #--------------------------------------------------------------------------
  # * Take a mapshot of the map
  #--------------------------------------------------------------------------
  def mapshot
    @screen_local = false
    redraw
    export
    $game_message.add("Mapshot taken")
  end
  
  #--------------------------------------------------------------------------
  # * Export the map to a file
  #--------------------------------------------------------------------------
  def export
    $map_creator_background = @map_image
  end
end
