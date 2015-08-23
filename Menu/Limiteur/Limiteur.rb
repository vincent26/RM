=begin
################################################################################
Limiteur d'inventaire
#####
Crédit : Vincent26
#####
Description :
Ce script permet de limiter le nombre total d'objet que peut posseder un personnage
Lorsque celui-ci récupere un objet avec un inventaire plein un message s'affiche 
pour l'informer
Ce script ajoute la possibiliter de jeter un objet depuis l'inventaire
Les objet cle ne sont pas comptabiliser dans le nombre maximum d'objet
#####
Utilisation :
Pour savoir le nombre d'item total transportable par le héros :
$game_party.nbr_max_item
Pour définir en jeu le nombre total de d'item du heros :
$game_party.nbr_max_item = X
Pour savoir le nombre d'item total posséder par le heros :
$game_party.max_item_number_total
=end
module LIMITEUR
NBR_MX_ITEM = 600
TEXTE_INVENTAIRE_PLEIN = "Inventaire plein"
end
################################################################################
#                               Limiteur nbr d'objet                           #
################################################################################
class Game_Party < Game_Unit
  
  attr_accessor :nbr_max_item
  
  alias initialize_limiteur_inv initialize
  def initialize
    initialize_limiteur_inv
    @nbr_max_item = LIMITEUR::NBR_MX_ITEM
  end
  
  alias max_item_number_2 max_item_number
  def max_item_number(item)
    return (@nbr_max_item - max_item_number_total)
  end
  
  def max_item_number_total
    total = 0
    for i in 0..(all_items.length-1)
      test = true
      test = !all_items[i].key_item? if all_items[i].class == RPG::Item
      a = item_number(all_items[i]) if test
      a = 0 if !test
      total = total + a
    end
    return total
  end
  
  alias gain_item_2 gain_item
  def gain_item(item, amount, include_equip = false)
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number + amount
    a = [amount,max_item_number(item)].min
    container[item.id] = [last_number + a,0].max
    test = false
    test = item.key_item? if item.class == RPG::Item
    container[item.id] = new_number if test
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_message.add(LIMITEUR::TEXTE_INVENTAIRE_PLEIN) if (max_item_number_total == @nbr_max_item)&&(!$game_message.has_text?)&&!test 
    $game_map.need_refresh = true
  end
end
################################################################################
#            Scene_Item ajout de la possibilité de jeter un objet              #
################################################################################
class Scene_Item < Scene_ItemBase
  alias on_item_ok_inventaire on_item_ok
  def on_item_ok
    a = @item_window.item
    b = @item_window.index - @item_window.top_row*2
    c = [@item_window.item_rect(b).x,@item_window.item_rect(b).y]
    c[1] = @item_window.item_rect(b-2).ye if (@item_window.index - @item_window.top_row*2) >= 18
    c[1] = @item_window.item_rect(b-4).y if (@item_window.index - @item_window.top_row*2) >= 20
    puts @category_window.index
    @command_item_window = Window_Command_Item.new(c[0]+@item_window.x+24,c[1]+@item_window.y+12,@item_window.enable_inventaire?(a),@category_window.index)
    @command_item_window.viewport = @viewport
    @command_item_window.set_handler(:utiliser,     method(:on_item_utiliser))
    @command_item_window.set_handler(:jeter, method(:on_item_jeter))
    @command_item_window.set_handler(:cancel, method(:on_item_command_cancel))
  end
  def on_item_utiliser
    on_item_ok_inventaire
  end
  def on_item_command_cancel
    @command_item_window.close
    @item_window.activate
  end
  def on_item_jeter
    a = @item_window.item
    if $game_party.item_number(a)>=2
      b = @item_window.index - @item_window.top_row*2
      c = [@item_window.item_rect(b).x,@item_window.item_rect(b).y]
      c[1] = @item_window.item_rect(b-2).y if (@item_window.index - @item_window.top_row*2) >= 18
      c[1] = @item_window.item_rect(b-4).y if (@item_window.index - @item_window.top_row*2) >= 20
      @number_window = Window_Number_Inventaire.new(a,c[0]+@item_window.x+24,c[1]+@item_window.y+24)
      @number_window.viewport = @viewport
      @number_window.set_handler(:ok,     method(:on_item_number_ok))
      @number_window.set_handler(:cancel, method(:on_item_number_cancel))
      @number_window.activate
    else
      $game_party.gain_item(@item_window.item,-1)
      @item_window.refresh
      @item_window.activate
      @command_item_window.close
    end
  end
  def on_item_number_ok
    $game_party.gain_item(@item_window.item,-$number_item_to_coffre)
    @item_window.refresh
    @item_window.activate
    @command_item_window.close
    @number_window.close
  end
  def on_item_number_cancel
    @number_window.close
    @command_item_window.activate
  end
end

class Window_ItemList < Window_Selectable
  alias enable_inventaire? enable?
  def enable?(item)
    return true
  end
end
################################################################################
#        Scene_ItemBase ajout de la possibilité de jeter un objet              #
################################################################################  
class Scene_Item
  alias activate_item_window_inventaire activate_item_window
  def activate_item_window
    @item_window.refresh
    @item_window.activate
    @command_item_window.close
  end
end
################################################################################
#                     Window_Number_Inventaire selecteur nbr a jeter           #
################################################################################ 
class Window_Number_Inventaire < Window_Selectable
  def initialize(item,x,y)
    super(x+20, y-12,48,48)
    $number_item_to_coffre = 1
    @item_coffre = item
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
    $number_item_to_coffre = 1 if $game_party.item_number(@item_coffre) < $number_item_to_coffre
    $number_item_to_coffre = $game_party.item_number(@item_coffre) if $number_item_to_coffre <1
  end
end
################################################################################
#                     Window_Command_Item commande utiliser jeter              #
################################################################################
class Window_Command_Item < Window_Command

  def initialize(x,y,utilisable,jetable)
    @utilisable = utilisable
    @jetable = false if (jetable == 3)
    @jetable = true if (jetable != 3)
    puts @jetable
    super(x, y)
  end

  def window_width
    return 160
  end

  def make_command_list
    add_command("Utiliser", :utiliser, @utilisable)
    add_command("Jeter", :jeter, @jetable)
  end
end
