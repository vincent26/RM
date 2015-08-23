=begin
################################################################################
Coffre de stockage
#####
Crédit : Vincent26
#####
Description :
Ce script permet de creer des coffre de stockage d'items, il sera surtout 
intéressant pour les projet possédant un limiteur d'inventaire
#####
Utilisation :
Créer/ouvrir un coffre :
$game_coffre.open_menu("nom_coffre")
avec le nom du coffre que vous voulez en laissant les ""
si 2 coffre porte le même nom il contiendrons la même chose
 
Pour ajouter des objet au coffre :
$game_coffre.coffre_new("nom_coffre",id_objet,quantité,type)
 
id_objet et un tableau qui contient l'id de chacun des objet que vous voulez ajouter (comme cela : [id1,id2,...])
quantité et un tableau qui contient la quantité d'objet que vous souhaiter ajouter au coffre ([Q1,Q2,...] Q1 correspond a la quantité de l'objet 1 ...)
type contient le type de l'objet : 0 pour un item;1 pour une arme;2pour une armure ([type1,type2,...] type1 correspond au type de l'objet 1)
ex : $game_coffre.coffre_new("coffre commun",[2,3],[20,1],[0,1])
ajoute 20*l'item 2
et 1*l'arme 3
=end
module Coffre_Stockage
  
  Touche_Switch = :A
  
  Nom_Touche_Switch = "SHIFT"
  
end
################################################################################
#                               Class mère                                     #
################################################################################
class Game_Coffre_Stockage
  def initialize
    @data = []
  end
  
  def open_menu(coffre_name)
    index = nil
    for i in 0.. @data.length-1
      index = i if (@data[i][0] == coffre_name)&&(index == nil)
    end
    if index == nil
      @data.push([coffre_name,[]])
      index = @data.length-1
    end
    @coffre = @data[index][1]
    SceneManager.call(Scene_Coffre)
    @data[index][1] = @coffre
  end
  
  def coffre_new(coffre_name,item,quantity,type)
    index = nil
    for i in 0.. @data.length-1
      index = i if (@data[i][0] == coffre_name)&&(index == nil)
    end
    if index == nil
      @data.push([coffre_name,[]])
      index = @data.length-1
    end
    @coffre = @data[index][1]
    for i in 0..item.length-1
      add_item_coffre($data_items[item[i]],quantity[i])if type[i]==0
      add_item_coffre($data_weapons[item[i][0]],quantity[i])if type[i]==1
      add_item_coffre($data_armors[item[i][0]],quantity[i])if type[i]==2
    end
    @data[index][1] = @coffre
  end
  
  def data
    return @coffre
  end
  
  def add_item_coffre(item,quantity)
    index = nil
    for i in 0..@coffre.length-1
      index = i if (@coffre[i][0] == item)&&(index == nil)
    end
    if index == nil
      @coffre.push([item,0])
      index = @coffre.length-1
    end
    @coffre[index][1] = @coffre[index][1] + quantity
    $game_party.gain_item(@coffre[index][0], -quantity, include_equip = false)
    @coffre.delete_at(index) if @coffre[index][1] == 0
  end
  
  def number_item(item)
    number = 0
    for i in 0..@coffre.length-1
      number = @coffre[i][1] if (@coffre[i][0] == item)&&(number == 0)
    end
    return number
  end
  
end
################################################################################
#                               Scene_coffre                                   #
################################################################################
class Scene_Coffre < Scene_MenuBase
 
  def start
    super
    $coffre = true
    create_help_window
    create_category_window
    create_name_window
    create_item_window
  end
  def terminate
    super
    $coffre = false
  end
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  
  def on_category_ok
    @item_window_perso.activate
    @item_window_perso.select(0)
   # @item_window_perso.select_last
  end
  def create_item_window
    wy = @category_window.y + @category_window.height + @switch_window.height
    wh = Graphics.height - wy
    @item_window_perso = Window_ItemList.new(0, wy, Graphics.width/2, wh)
    @item_window_coffre = Window_ItemList_Coffre.new(Graphics.width/2, wy, Graphics.width/2, wh)
    @item_window_perso.viewport = @viewport
    @item_window_coffre.viewport = @viewport
    @item_window_perso.help_window = @help_window
    @item_window_coffre.help_window = @help_window
    @item_window_perso.set_handler(:ok,     method(:on_item_ok))
    @item_window_coffre.set_handler(:ok,     method(:on_item_ok_c))
    @item_window_perso.set_handler(:cancel, method(:on_item_cancel))
    @item_window_coffre.set_handler(:cancel, method(:on_item_cancel_c))
    @item_window_perso.set_handler(:switch, method(:on_item_switch))
    @item_window_coffre.set_handler(:switch, method(:on_item_switch_c))
    @category_window.item_window = @item_window_perso
    @item_window_coffre.unselect
  end
  ####INVENTAIRE
  def on_item_ok
    if @item_window_perso.item_max >= 1
      a = @item_window_perso.item
      if $game_party.item_number(a)>=2
        b = @item_window_perso.index - @item_window_perso.top_row*2
        c = [@item_window_perso.item_rect(b).x,@item_window_perso.item_rect(b).y]
        @number_window = Window_Number.new(a,c[0]+@item_window_perso.x+12,c[1]+@item_window_perso.y+12,0)
        @number_window.viewport = @viewport
        @number_window.set_handler(:ok,     method(:on_item_number_ok))
        @number_window.set_handler(:cancel, method(:on_item_number_cancel))
        @number_window.activate
      else
        $game_coffre.add_item_coffre(@item_window_perso.item,1)
        @item_window_coffre.refresh
        @item_window_perso.refresh
        @item_window_perso.activate
      end
    else
      @item_window_perso.activate
    end
  end
      def on_item_number_ok
        $game_coffre.add_item_coffre(@item_window_perso.item,$number_item_to_coffre)
        @item_window_coffre.refresh
        @item_window_perso.refresh
        @item_window_perso.activate
        @number_window.close
      end
      def on_item_number_cancel
        @number_window.close
        @item_window_perso.activate
      end
  def on_item_cancel
    $coffre = false
    @item_window_perso.unselect
    @category_window.activate
  end
  def on_item_switch
    @item_window_perso.unselect
    @item_window_coffre.activate
    @item_window_coffre.select_last
  end
  ####COFFRE
  def on_item_ok_c
    if @item_window_coffre.item_max >= 1
      a = @item_window_coffre.item
      if $game_coffre.number_item(a)>=2
        b = @item_window_coffre.index - @item_window_coffre.top_row*2
        c = [@item_window_coffre.item_rect(b).x,@item_window_coffre.item_rect(b).y]
        @number_window = Window_Number.new(a,c[0]+@item_window_coffre.x+12,c[1]+@item_window_coffre.y+12,1)
        @number_window.viewport = @viewport
        @number_window.set_handler(:ok,     method(:on_item_number_ok_c))
        @number_window.set_handler(:cancel, method(:on_item_number_cancel_c))
        @number_window.activate
      else
        if $game_party.item_number(@item_window_coffre.item)+1 <= $game_party.max_item_number(@item_window_coffre.item)
          $game_coffre.add_item_coffre(@item_window_coffre.item,-1)
        end
        @item_window_perso.refresh
        @item_window_coffre.refresh
        @item_window_coffre.activate
      end
    else
      @item_window_coffre.activate
    end
  end
      def on_item_number_ok_c
        if $game_party.item_number(@item_window_coffre.item)+$number_item_to_coffre > $game_party.max_item_number(@item_window_coffre.item)
          $game_coffre.add_item_coffre(@item_window_coffre.item,-($game_party.max_item_number(@item_window_coffre.item)-$game_party.item_number(@item_window_coffre.item)))
        else
          $game_coffre.add_item_coffre(@item_window_coffre.item,-$number_item_to_coffre)
        end
        @item_window_perso.refresh
        @item_window_coffre.refresh
        @item_window_coffre.activate
        @number_window.close
      end
      def on_item_number_cancel_c
        @number_window.close
        @item_window_coffre.activate
      end
  def on_item_cancel_c
    @item_window_coffre.unselect
    @category_window.activate
  end
  def on_item_switch_c
    @item_window_coffre.unselect
    @item_window_perso.activate
    @item_window_perso.select_last
  end
  
  def use_item
    super
    @item_window_perso.redraw_current_item
  end
  def create_name_window
    @switch_window = Window_Switch.new
    @title_window_1 = Window_Title_1.new
    @title_window_2 = Window_Title_2.new
    @switch_window.viewport = @viewport
    @title_window_1.viewport = @viewport
    @title_window_2.viewport = @viewport
  end
end
################################################################################
#                               Window_Number                                  #
################################################################################
class Window_Number < Window_Selectable
  def initialize(item,x,y,type)
    super(x+20, y-12,48,48)
    $number_item_to_coffre = 1
    @item_coffre = item
    @type = type
    refresh
  end
  def update
    super
    refresh
  end
  def refresh
    contents.clear
    contents.draw_text(0, 0, 24, 24, $number_item_to_coffre,1)
    $number_item_to_coffre = $number_item_to_coffre + 1 if Input.trigger?(:UP)
    $number_item_to_coffre = $number_item_to_coffre - 1 if Input.trigger?(:DOWN)
    $number_item_to_coffre = $number_item_to_coffre - 10 if Input.trigger?(:LEFT)
    $number_item_to_coffre = $number_item_to_coffre + 10 if Input.trigger?(:RIGHT)
    if @type == 0
      $number_item_to_coffre = 1 if $game_party.item_number(@item_coffre) < $number_item_to_coffre
      $number_item_to_coffre = $game_party.item_number(@item_coffre) if $number_item_to_coffre <1
    else
      $number_item_to_coffre = 1 if $game_coffre.number_item(@item_coffre) < $number_item_to_coffre
      $number_item_to_coffre = $game_coffre.number_item(@item_coffre) if $number_item_to_coffre <1
    end
  end
end
################################################################################
#                               Window_Switch                                  #
################################################################################
class Window_Switch < Window_Base
  def initialize
    super(222, 120, 100, 48)
    refresh
  end
  def refresh
    self.contents.clear
    contents.font.size = 24
    change_color(text_color(30), true)
    contents.draw_text(0, 0, 76, 24, "◄─► "+Coffre_Stockage::Nom_Touche_Switch.to_s,1)
  end
end
################################################################################
#                               Window_Title_1                                 #
################################################################################
class Window_Title_1 < Window_Base
  def initialize
    super(0, 120, 222, 48)
    refresh
  end
  def refresh
    self.contents.clear
    contents.font.size = 24
    change_color(text_color(0), true)
    contents.draw_text(0, 0, 198, 24, "Inventaire",1)
  end
end
################################################################################
#                               Window_Title_2                                 #
################################################################################
class Window_Title_2 < Window_Base
  def initialize
    super(322, 120, 222, 48)
    refresh
  end
  def refresh
    self.contents.clear
    contents.font.size = 24
    change_color(text_color(0), true)
    contents.draw_text(0, 0, 198, 24, "Coffre",1)
  end
end
################################################################################
#                               Window_Selectable                                 #
################################################################################
class Window_Selectable < Window_Base
  
  alias process_handling_coffre_stockage process_handling
  def process_handling
    process_handling_coffre_stockage
    return unless open? && active
    return process_ok       if ok_enabled?        && Input.trigger?(:C)
    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
    return process_switch   if handle?(:switch)   && Input.trigger?(Coffre_Stockage::Touche_Switch)
  end

  def process_switch
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:switch)
  end
end
################################################################################
#                               Window ItemList                                #
################################################################################
class Window_ItemList < Window_Selectable
  alias draw_item_coffre_stockage draw_item
  def draw_item(index)
    if $coffre != true
      draw_item_coffre_stockage(index)
    else
      item = @data[index]
      if item
        rect = item_rect(index)
        rect.width -= 4
        draw_item_name(item, rect.x, rect.y, enable?(item),rect.width-60)
        draw_item_number(rect, item)
      end
    end
  end

  alias enable_coffre? enable?
  def enable?(item)
    if $coffre != true
      enable_coffre?(item)
    else
      true
    end
  end
end
################################################################################
#                         Window ItemList Coffre                               #
################################################################################
class Window_ItemList_Coffre < Window_Selectable

  def initialize(x, y, width, height)
    super
    @category = :none
    @data = []
    refresh
  end

  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  def spacing
    return 10
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.length : 1
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    true
  end
  #--------------------------------------------------------------------------
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    for i in 0..$game_coffre.data.length-1
      @data.push($game_coffre.data[i][0])
    end
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item),rect.width-75)
      draw_item_number(rect, index)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, index)
    draw_text(rect, sprintf(":%2d", $game_coffre.data[index][1]), 2) if $game_coffre.data[index]!= nil
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
################################################################################
#                               Ajout au save                                  #
################################################################################
module DataManager
  class << self
    alias :create_game_objects_coffre_stockage :create_game_objects
    def create_game_objects
      create_game_objects_coffre_stockage 
      $game_coffre      = Game_Coffre_Stockage.new
    end
    alias :make_save_contents_coffre_stockage :make_save_contents
    def make_save_contents
      contents = make_save_contents_coffre_stockage
      contents[:coffre_stockage]        = $game_coffre
      contents
    end
    alias :extract_save_contents_coffre_stockage :extract_save_contents
    def extract_save_contents(contents)
      extract_save_contents_coffre_stockage(contents)
      $game_coffre        = contents[:coffre_stockage]
    end
  end
end
