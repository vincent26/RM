=begin
###########################################################
Multi Monnaie
####
Vincent26
####
Description :
Ce script permet de creer plusieur monnaie en jeu. Il ajoute de plus la 
possibiliter de convertir les monnaie entre elles.
####
Utilisation :
Le module ci-dessous permet de configurer le script, a la fin vous 
trouverez une explication de ce que vous pouvais faire.
=end
module Monnaie
  
  #Nombre de monnaie :
  NBR_MONNAIE = 4
  
  #Mettre un texte pour nom
  NAME = ["Or","Argent","Cuivre","Âme"]
  #Mettre l'id d'une icone si vous voulez voir l'icone plutot que le nom de la
  #monnaie , mettre nil sinon
  ICON = [190,184,187,nil]
  #Maximum transportable (mettre nil pour pas de limite)
  MAX_VALUE = [nil,nil,nil,nil]
  
  #Monnaie a afficher dans le menu
  MONNAIE_MENU = [1,2,3,4]
  
  #Utilisation du menu shop de YANFLY (Yanfly Engine Ace - Ace Shop Options v1.01)
  YANFLY_MENU = true
  
  #Utilisation du script de craft de  V.M of D.T (Advanced Recipe Crafting v1.0b)
  CRAFT_MENU = true
  #Si vous utiliser ce script :
  #Lors de la configuration de vos recette pour le prix vous pouvez configurez ainsi :
  #:gold_cost => [10,"Or"], #par exemple
  #ou encore :
  #:gold_cost => [10,"Or",200,"Argent"],
  
  #Type de conversion possible entre monnaie
  CONVERSION = [["Or","Âme"],
                ["Or","Argent"],
                ["Or","Cuivre"],
                ["Argent","Or"],
                ["Argent","Cuivre"],
                ["Cuivre","Or"],
                ["Cuivre","Argent"],
                ["Âme","Or"]
                ]
  #Taux de conversion des monnaie (a mettre dans le même ordre que le tableau juste au dessus)
  TAUX_CONVERSION = [[100,1], # <= 100 or pour 1 Âme
                     [1,10],  # <= 1 or pour 10 argent
                     [1,100], # <= 1 or pour 100 cuivre
                     [10,1],  # <= 10 argent pour 1 or
                     [1,10],  # <= 1 argent pour 10 cuivre
                     [100,1], # <= 100 cuivre pour 1 or
                     [10,1],  # <= 10 cuivre pour 1 argent
                     [1,100]  # <= 1 Âme pour 100 or
                     ]
=begin
  Nouvelle fonction :
  Dans un text au lieu de mettre \G on peut désormais mettre \G[id] pour 
  remplacer par le nom de la id'eme monnaie
  
  En appel de script pour changer recuperer la valeur d'une monnaie :
  
  #Ajout de monnaie
  gain_monnaie(name,value)
  name => sont nom ex "Or"
  value => la valeur du gain
  
  #Perte de monnaie
  perte_monnaie(name,value)
  name => sont nom ex "Or"
  value => la valeur de la perte
  
  #Recuperer la valeur d'une monnaie
  monnaie(name)
  name => sont nom ex "Or"
  OU
  name => tableau de nom ex: ["Or","Argent"]
  
  #Pour lancer un magasin avec une monnaie particulière:
   Faire un appel de script : magasin(name)
   name est le nom de la monnaie utilisable ou un tableau des monnaie utilisable
   Faire ensuite un appel de magasin basique
   ATTENTION : les objet du magasin doivent avoir été définit comme ci-dessous
   Sinon une erreur va ce produire
   ex : magasin("Or")
   ou : magasin(["Or","Argent"])
   
  #Pour définir le prix d'un item :
   Dans la note de l'item mettre :
   <Money = Prix,MON,PRIX,MON,...>
   ex : <Money = 50,Or,20,Argent> pour 50 d'or et 20 d'argent
   
  #Pour définir le gain d'argent sur un monstre
   mettre dans la note du monstre :
   <Money = GAIN,MON,GAIN,MON,...>
   ex : <Money = 10,Or,20,Cuivre> pour 10 d'or et 20 de cuivre
   
  #Pour lancer le menu de conversion de monnaie :
   SceneManager.call(Scene_Conversion)
=end
end
#############################
# Modification BattleManager#
#############################
module BattleManager
  def self.gain_gold
    if $game_troop.gold_total(true) != ""
      $game_message.add('\.' + $game_troop.gold_total)
    end
    wait_for_message
  end
end
##########################
# Modification Game_Troop#
##########################
class Game_Troop
  def gold_total(test = false)
    result = {}
    r = 0
    for ene in 0..dead_members.length-1
      r += dead_members[ene].gold * gold_rate
      if $data_enemies[dead_members[ene].enemy_id].note =~ /<Money = (\S+)>/
        array = $1.split(",")
        for i in 0..(array.length-1)/2
          if result.has_key?(array[i*2+1])
            result[array[i*2+1]] += array[i*2].to_i * gold_rate
          else
            result[array[i*2+1]] = array[i*2].to_i * gold_rate
          end
        end
      end
    end
    $game_party.gain_gold(r) if r != 0
    return sprintf(Vocab::ObtainGold, $game_troop.gold_total) if result.empty? && r != 0
    texte = ""
    i = 0
    result.each do |key,value|
      id = Monnaie::NAME.index(key)
      texte += sprintf("%s %s trouvés !",value,key) if i == 0
      texte += sprintf("\n%s %s trouvés !",value,key) if i != 0
      $game_party.gain_gold(value,id) if !test
      i += 1
    end
    return texte
  end
end
#############################
# New class Scene_Conversion#
#############################
class Scene_Conversion < Scene_MenuBase
  def start
    super
    create_help_window
    create_gold_window
    create_list_window
    create_number_window
  end
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
    array = Monnaie::MONNAIE_MENU
    if array.length > 1
      @gold_window.height = 24+24+@help_window.height
      @gold_window.y = 0
      @help_window.width = Graphics.width-@gold_window.width
      @help_window.create_contents
    end
    @gold_window.value_affichage = array
    @gold_window.create_contents
    @gold_window.refresh
    @help_window.height = @gold_window.height
  end
  def create_list_window
    @list_window = Window_Conversion_List.new(0, @help_window.height, Graphics.width/2,Graphics.height-@help_window.height)
    @list_window.help_window = @help_window
    @list_window.set_handler(:ok,     method(:on_list_ok))
    @list_window.set_handler(:cancel, method(:on_list_cancel))
    @list_window.refresh
    @list_window.select(0)
    @list_window.activate
  end
  def on_list_ok
    return on_number_cancel if !@list_window.enabled?(@list_window.index)
    @number_window.set(@list_window.index)
    @number_window.activate
    @list_window.deactivate
  end
  def on_list_cancel
    return_scene
  end
  def create_number_window
    wy = @list_window.y
    wh = @list_window.height
    @number_window = Window_ConvertNumber.new(Graphics.width/2, wy, Graphics.width/2, wh)
    @number_window.viewport = @viewport
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.deactivate
  end
  def on_number_ok
    nbr = @number_window.number
    taux = @number_window.taux
    id = Monnaie::NAME.index(@number_window.from)
    id2 = Monnaie::NAME.index(@number_window.to)
    $game_party.lose_gold(nbr*taux[0],id)
    $game_party.gain_gold(nbr*taux[1],id2)
    @gold_window.refresh
    @list_window.refresh
    on_number_cancel
  end
  def on_number_cancel
    @number_window.deactivate
    @number_window.contents.clear
    @list_window.activate
  end
end
##############################
# New class Window_ShopNumber#
##############################
class Window_ConvertNumber < Window_Selectable
  attr_reader   :number                   # quantity entered
  attr_reader   :from
  attr_reader   :to
  attr_reader   :taux
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @max = 1
  end
  def set(index)
    @from = Monnaie::CONVERSION[index][0]
    @to = Monnaie::CONVERSION[index][1]
    id = Monnaie::NAME.index(@from)
    id2 = Monnaie::NAME.index(@to)
    @taux = Monnaie::TAUX_CONVERSION[index]
    @max = ($game_party.gold2[id]/@taux[0])
    if Monnaie::MAX_VALUE[id2] != nil
      @max = [@max,(Monnaie::MAX_VALUE[id2]-$game_party.gold2[id2])/@taux[1]].min
    end
    @number = 1
    refresh
  end
  def refresh
    contents.clear
    draw_name
    draw_number
    draw_total_price
  end
  def draw_name
    draw_text(0, item_y-line_height, contents_width , line_height, @taux[0].to_s+" X "+@from+" => "+@taux[1].to_s+" X "+@to)
    change_color(system_color)
    draw_text(0, item_y, contents_width , line_height, @from)
    change_color(normal_color)
    draw_text(text_size(@from).width, item_y, contents_width , line_height, " => ")
    change_color(system_color)
    draw_text(text_size(@from+" => ").width, item_y, contents_width , line_height, @to)
    change_color(normal_color)
  end
  def draw_number
    change_color(normal_color)
    draw_text(cursor_x - 28, item_y, 22, line_height, "×")
    draw_text(cursor_x, item_y, cursor_width - 4, line_height, @number, 2)
  end
  def draw_total_price
    width = contents_width - 8
    rect = Rect.new(4,price_y,width,line_height)
    id = Monnaie::NAME.index(@from)
    id2 = Monnaie::NAME.index(@to)
    width_tot = 0
    width_tot += text_size(($game_party.gold2[id]-@taux[0]*@number).to_s).width
    if Monnaie::ICON[id] != nil
      width_tot += 24
    else
      width_tot += text_size(" " + @from).width
    end
    width_tot += text_size("   ").width
    width_tot += text_size(($game_party.gold2[id2]+@taux[1]*@number).to_s).width
    if Monnaie::ICON[id2] != nil
      width_tot += 24
    else
      width_tot += text_size(" " + @to).width
    end
    rect.width -= width_tot
    rect.width += text_size(($game_party.gold2[id]-@taux[0]*@number).to_s).width
    draw_text(rect, ($game_party.gold2[id]-@taux[0]*@number).to_s, 2)
    if Monnaie::ICON[id] != nil
      rect.width += 24
      draw_icon(Monnaie::ICON[id], rect.x+rect.width-24, rect.y)
    else
      rect.width += text_size(" " + @from).width
      draw_text(rect, " " + @from, 2)
    end
    rect.width += text_size("   ").width
    draw_text(rect, "   ", 2)
    rect.width += text_size(($game_party.gold2[id2]+@taux[1]*@number).to_s).width
    draw_text(rect, ($game_party.gold2[id2]+@taux[1]*@number).to_s, 2)
    if Monnaie::ICON[id2] != nil
      rect.width += 24
      draw_icon(Monnaie::ICON[id2], rect.x+rect.width-24, rect.y)
    else
      rect.width += text_size(" " + @to).width
      draw_text(rect, " " + @to, 2)
    end
  end
  def item_y
    contents_height / 2 - line_height * 3 / 2
  end
  def price_y
    contents_height / 2 + line_height / 2
  end
  def cursor_width
    figures * 10 + 12
  end
  def cursor_x
    contents_width - cursor_width - 4
  end
  def figures
    return 2
  end
  def update
    super
    if active
      last_number = @number
      update_number
      if @number != last_number
        Sound.play_cursor
        refresh
      end
    end
  end
  def update_number
    change_number(1)   if Input.repeat?(:RIGHT)
    change_number(-1)  if Input.repeat?(:LEFT)
    change_number(10)  if Input.repeat?(:UP)
    change_number(-10) if Input.repeat?(:DOWN)
  end
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
  end
  def update_cursor
    cursor_rect.set(cursor_x, item_y, cursor_width, line_height)
  end
end
###################################
# New class Window_Conversion_List#
###################################
class Window_Conversion_List < Window_Selectable
  def initialize(x,y,w,h)
    super(x,y,w,h)
    @data = []
  end
  def col_max
    return 1
  end
  def item_max
    @data ? @data.size : 1
  end
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  def make_item_list
    @data = []
    for i in Monnaie::CONVERSION
      @data.push(i[0]+" => "+i[1])
    end
  end
  def enabled?(index)
    @from = Monnaie::CONVERSION[index][0]
    @to = Monnaie::CONVERSION[index][1]
    id = Monnaie::NAME.index(@from)
    id2 = Monnaie::NAME.index(@to)
    @taux = Monnaie::TAUX_CONVERSION[index]
    @max = ($game_party.gold2[id]/@taux[0])
    if Monnaie::MAX_VALUE[id2] != nil
      @max = [@max,(Monnaie::MAX_VALUE[id2]-$game_party.gold2[id2])/@taux[1]].min
    end
    return false if @max == 0
    return true
  end
  def draw_item(index)
    rect = item_rect(index)
    change_color(normal_color, enabled?(index))
    draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
  end
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  def update_help
    text = "Convertir "
    text += Monnaie::CONVERSION[index][0]
    text += " en "
    text += Monnaie::CONVERSION[index][1]
    @help_window.set_text(text) if @help_window
  end
end
################################
# Modification de la Scene_Shop#
################################
class Scene_Shop < Scene_MenuBase
  alias prepare_monnaie prepare
  def prepare(goods, purchase_only,monnaie)
    prepare_monnaie(goods, purchase_only)
    @monnaie = monnaie
    msgbox("Monnaie non définit pour ce shop") if @monnaie == nil
  end
  alias create_gold_window_monnaie create_gold_window
  def create_gold_window
    create_gold_window_monnaie
    array = @monnaie
    array = [@monnaie] if !@monnaie.is_a?(Array)
    if array.length > 1
      if !Monnaie::YANFLY_MENU
        @gold_window.height = 24+24+@help_window.height
        @gold_window.y = 0
        @help_window.width = Graphics.width-@gold_window.width
        @help_window.create_contents
      else
        @gold_window.height = 24+24*array.length
        @gold_window.y = 0
      end
    end
    @gold_window.value_affichage = array
    @gold_window.create_contents
    @gold_window.refresh
  end
  def create_buy_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @buy_window = Window_ShopBuy.new(0, wy, wh, @goods, money)
    @buy_window.viewport = @viewport
    @buy_window.help_window = @help_window
    @buy_window.status_window = @status_window
    @buy_window.hide
    @buy_window.set_handler(:ok,     method(:on_buy_ok))
    @buy_window.set_handler(:cancel, method(:on_buy_cancel))
    if Monnaie::YANFLY_MENU
      array = @monnaie
      array = [@monnaie] if !@monnaie.is_a?(Array)
      @status_window.height -= 24*(array.length-1)
      @status_window.y += 24*(array.length-1)
    end
  end
  alias do_buy_multi_monnaie do_buy
  def do_buy(number)
    if buying_price.is_a?(Integer)
      do_buy_multi_monnaie(number)
    else
      buying_price.each do |key,value|
        id = Monnaie::NAME.index(key)
        $game_party.lose_gold((value*number),id)
      end
      $game_party.gain_item(@item, number)
    end
  end
  alias do_sell_multi_monnaie do_sell
  def do_sell(number)
    if selling_price.is_a?(Integer)
      do_sell_multi_monnaie(number)
    else
      selling_price.each do |key,value|
        id = Monnaie::NAME.index(key)
        $game_party.gain_gold((value*number),id)
      end
      $game_party.lose_item(@item, number)
    end
  end
  alias max_buy_multi_monnaie max_buy
  def max_buy
    max = $game_party.max_item_number(@item) - $game_party.item_number(@item)
    if buying_price.is_a?(Integer)
      return max_buy_multi_monnaie
    else
      ok = [max]
      buying_price.each do |key,value|
        id = Monnaie::NAME.index(key)
        ok.push($game_party.gold2[id] / value)
      end
      return ok.min
    end
  end
  def money
    @gold_window.value_affichage
  end
  def selling_price
    if @item.note =~ /<Money = (\S+)>/
      array = $1.split(",")
      result = {}
      for i in 0..(array.length-1)/2
        result[array[i*2+1]] = array[i*2].to_i
      end
      return result
    else
      return @item.price / 2
    end
  end
end
######################################
# Modification de la Window ShopSell #
######################################
class Window_ShopSell < Window_ItemList
  def enable?(item)
    if item.note =~ /<Money = (\S+)>/
      return true
    else
      return item && item.price > 0
    end
  end
end
########################################
# Modification de la window ShopNumber #
########################################
class Window_ShopNumber < Window_Selectable
  alias draw_total_price_multi_monnaie draw_total_price
  def draw_total_price ############
    if @price.is_a?(Integer)
      draw_total_price_multi_monnaie
    else
      width = contents_width - 8
      rect = Rect.new(4,price_y,width,line_height)
      width_tot = 0
      @price.each do |key,value|
        width_tot += text_size((value*@number).to_s).width
        if Monnaie::ICON[Monnaie::NAME.index(key)] != nil
          width_tot += 24
        else
          width_tot += text_size(key).width
        end
      end
      rect.width -= width_tot
      @price.each do |key,value|
        id = Monnaie::ICON[Monnaie::NAME.index(key)]
        rect.width += text_size((value*@number).to_s).width
        draw_text(rect, (value*@number).to_s, 2)
        if id != nil
          rect.width += 24
          draw_icon(id, rect.x+rect.width-24, rect.y)
        else
          rect.width += text_size(key).width
          draw_text(rect, key, 2)
        end
      end
    end
  end
end
#####################################
# Modification de la window shopBuy #
#####################################
class Window_ShopBuy < Window_Selectable
  def initialize(x, y, height, shop_goods,money = 0)
    super(x, y, window_width, height)
    @shop_goods = shop_goods
    @money = money
    refresh
    select(0)
  end
  def enable?(item)
    if item && !$game_party.item_max?(item)
      price(item).each do |key,value|
        return false if !@money.include?(Monnaie::NAME.index(key)+1)
        return false if value > $game_party.gold2[Monnaie::NAME.index(key)]
      end
    else
      return false
    end
    return true
  end
  def make_item_list
    @data = []
    @price = {}
    @shop_goods.each do |goods|
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        @data.push(item)
        if item.note =~ /<Money = (\S+)>/
          array = $1.split(",")
          result = {}
          for i in 0..(array.length-1)/2
            result[array[i*2+1]] = array[i*2].to_i
          end
          @price[item] = result
        else
          @price[item] = goods[2] == 0 ? item.price : goods[3]
        end
      end
    end
  end
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    if price(item).is_a?(Integer)
      draw_text(rect, price(item), 2)
    else
      width_tot = 0
      price(item).each do |key,value|
          width_tot += text_size(value.to_s).width
        if Monnaie::ICON[Monnaie::NAME.index(key)] != nil
          width_tot += 24
        else
          width_tot += text_size(key).width
        end
      end
      rect.width -= width_tot
      price(item).each do |key,value|
        id = Monnaie::ICON[Monnaie::NAME.index(key)]
        rect.width += text_size(value.to_s).width
        draw_text(rect, value.to_s, 2)
        if id != nil
          rect.width += 24
          draw_icon(id, rect.x+rect.width-24, rect.y,enable?(item))
        else
          rect.width += text_size(key).width
          draw_text(rect, key, 2)
        end
      end
    end
  end
end
##################################
# Modification de la window gold #
##################################
class Scene_Menu
  alias create_gold_window_monnaie create_gold_window
  def create_gold_window
    create_gold_window_monnaie
    @gold_window.value_affichage = Monnaie::MONNAIE_MENU
    @gold_window.height = (Monnaie::MONNAIE_MENU.length+1)*24
    @gold_window.y = Graphics.height - @gold_window.height
    @gold_window.create_contents
    @gold_window.refresh
  end
end
###################
# Ajout du \G[id] #
###################
class Window_Base
  alias convert_escape_characters_monnaie convert_escape_characters
  def convert_escape_characters(text)
    result = text.to_s.clone
    result.gsub!(/\\/)            { "\e" }
    result.gsub!(/\eG\[(\d+)\]/i) { Monnaie::NAME[$1.to_i-1] }
    convert_escape_characters_monnaie(result)
  end
end
##################################
# Modification de la window gold #
##################################
class Window_Gold < Window_Base
  attr_accessor :value_affichage
  alias initialize_monnaie initialize
  def initialize
    @value_affichage = []
    initialize_monnaie
  end
  def refresh
    contents.clear
    for i in 0..@value_affichage.length-1
      draw_currency_value(value(@value_affichage[i]-1), currency_unit(@value_affichage[i]-1), 4, i*line_height, contents.width - 8)
    end
  end
  def value(id = nil)
    return $game_party.gold if id == nil
    return $game_party.gold2[id]
  end
  def draw_currency_value(value, unit, x, y, width)
    if unit.is_a?(Integer)
      change_color(normal_color)
      draw_text(x, y, width - 24 - 2, line_height, value, 2)
      draw_icon(unit, x+width-24, y)
    else
      cx = text_size(unit).width
      change_color(normal_color)
      draw_text(x, y, width - cx - 2, line_height, value, 2)
      change_color(system_color)
      draw_text(x, y, width, line_height, unit, 2)
    end
  end
  def currency_unit(id = nil)
    return Vocab::currency_unit if id == nil
    return Monnaie::ICON[id] != nil ? Monnaie::ICON[id] : Monnaie::NAME[id]
  end
end
################################
# Ajout des monnaie a l'équipe #
################################
class Game_Party
  attr_reader :gold2
  alias initialize_monnaie initialize
  alias gain_gold_monnaie gain_gold
  alias max_gold_monnaie max_gold
  
  def initialize
    initialize_monnaie
    super
    @gold2 = Array.new(Monnaie::NBR_MONNAIE,0)
  end
  def gain_gold(amount,id = nil)
    if id == nil
      gain_gold_monnaie(amount)
    else
      if max_gold(id)
        @gold2[id] = [[@gold2[id]+amount,0].max,max_gold(id)].min
      else
        @gold2[id] = [@gold2[id]+amount,0].max
      end
    end
  end
  def lose_gold(amount,id = nil)
    gain_gold(-amount, id)
  end
  def max_gold(id = nil)
    return max_gold_monnaie if id == nil
    return Monnaie::MAX_VALUE[id]
  end
end
#############################################
# Ajout de commande de modification monnaie #
#############################################
class Game_Interpreter
  
  def command_302
    return if $game_party.in_battle
    goods = [@params]
    while next_event_code == 605
      @index += 1
      goods.push(@list[@index].parameters)
    end
    SceneManager.call(Scene_Shop)
    SceneManager.scene.prepare(goods, @params[4],@magasin_monnaie)
    @magasin_monnaie = nil
    Fiber.yield
  end
  
  def magasin(name)
    if name.is_a?(Array)
      result = []
      for i in name
        result.push(Monnaie::NAME.index(i)+1)
      end
    else
      result = Monnaie::NAME.index(name)+1
    end
    @magasin_monnaie = result
  end
  
  def gain_monnaie(name,value)
    id = Monnaie::NAME.index(name)
    $game_party.gain_gold(value,id)
  end
  def perte_monnaie(name,value)
    id = Monnaie::NAME.index(name)
    $game_party.lose_gold(value,id)
  end
  def monnaie(name)
    id = Monnaie::NAME.index(name)
    return $game_party.gold2[id]
  end
end
############################
# Modif pour le menu craft #
############################
if Monnaie::CRAFT_MENU
  #Modification de la class recette
  class Recipe
    #Modification du test de possetion argent
    def has_gold?
      if @gold_cost.is_a?(Array)
        result = 0
        for i in 0..@gold_cost.length/2-1
          id = Monnaie::NAME.index(@gold_cost[i*2+1])
          result +=2 if $game_party.gold2[id] >= @gold_cost[i*2]
        end
        return true if result == @gold_cost.length
      else
        return true if $game_party.gold >= @gold_cost
      end
      return false
    end
    #Modification de la récuperation nombre d'item max craftable
    def amount_craftable?
      mat_amount = []
      for item in @materials
        mat_amount.push($game_party.item_number(item.item) / item.amount)
      end
      if @gold_cost != 0
        if @gold_cost.is_a?(Array)
          result = []
          for i in 0..@gold_cost.length/2-1
            id = Monnaie::NAME.index(@gold_cost[i*2+1])
            result.push($game_party.gold2[id]/@gold_cost[i*2])
          end
          return [result.min,mat_amount.min].min
        else
          return [$game_party.gold / @gold_cost,mat_amount.min].min
        end
      else
        return mat_amount.min
      end
    end
    #Modification de la suppression materiels
    def remove_materials
      for item in @materials
        $game_party.gain_item(item.item,-item.amount)
      end
      if @gold_cost.is_a?(Array)
        for i in 0..@gold_cost.length/2-1
          id = Monnaie::NAME.index(@gold_cost[i*2+1])
          $game_party.gain_gold(-@gold_cost[i*2],id)
        end
      else
        $game_party.gain_gold(-@gold_cost)
      end
    end
  end
  #Modification de la window information recette
  class Window_RecipeDetail < Window_Base
    #Modif de test de gold
    def draw_gold_cost
      if @recipe.gold_cost != 0
        change_color(system_color, @recipe.has_gold?)
        draw_text(0,contents.height-contents.font.size*2,contents.width,contents.font.size,"Crafting Cost:")
        change_color(normal_color, @recipe.has_gold?)
        draw_currency_value(@recipe.gold_cost,Vocab::currency_unit,0,contents.height-contents.font.size*2,contents.width)
      end  
    end
    #Modification de la fonction d'écriture de l'argent
    def draw_currency_value(value, unit, x, y, width)
      if value.is_a?(Array)
        x2 = 0
        value2 = value.clone.reverse!
        for i in value2
          if i.is_a?(Integer)
            w = text_size(i.to_s).width
            draw_text(x+width-w-x2, y, w, contents.font.size, i.to_s, 2)
            x2 += w
          else
            id = Monnaie::NAME.index(i)
            if Monnaie::ICON[id] != nil
              draw_icon(Monnaie::ICON[id], x+width-24-x2, y-(24-contents.font.size)/2)
              x2 += 24
            else
              w = text_size(i).width
              draw_text(x+width-w-x2, y, w, contents.font.size, i, 2)
              x2 += w
            end
          end
        end
      else
        cx = text_size(unit).width
        change_color(normal_color,$game_party.gold >= value)
        draw_text(x, y, width - cx - 2, contents.font.size, value, 2)
        change_color(system_color)
        draw_text(x, y, width, contents.font.size, unit, 2)
      end
    end
  end
end