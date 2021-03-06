=begin
#######################################################
        Multi_Currency
#########
Vincent26
V. 1.6 (23/06/2015)
####
Description :
Permet de créer plusieurs types de monnaie dans RM. Chaque monnaie est alors indépendante.
Ajoute de plus un menu avec possibilité de faire des conversions de monnaie.
####
Utilisation :
Configurer le module suivant :
A la fin vous trouverez toutes les infos pour utiliser ce script.
####
=end

module Monnaie
 
  #Nombre de monnaie :
  NBR_MONNAIE = 3
 
  #Mettre un texte pour nom
  NAME = ["Or","Argent","Cuivre"]
  #Mettre l'id d'une icône si vous voulez voir l'icône plutot que le nom de la
  #monnaie, mettre nil sinon.
  ICON = [676,675,674]
  #Maximum transportable (mettre nil pour pas de limite)
  MAX_VALUE = [nil,nil,nil]
 
  #Monnaie à afficher dans le menu
  MONNAIE_MENU = [1,2,3]
  
  #Type de conversion possible entre monnaies
  CONVERSION = [["Or","Argent"],
                ["Argent","Or"],
                ["Argent","Cuivre"],
                ["Cuivre","Argent"]]
                
  #Taux de conversion des monnaies (à mettre dans le même ordre que le tableau juste au-dessus)
  TAUX_CONVERSION = [[1,100],  # <= 1 or pour 100 argent
                     [100,1],  # <= 100 argent pour 1 or
                     [1,100],  # <= 1 argent pour 100 cuivre
                     [100,1]]  # <= 100 cuivre pour 1 argent
 
##################
  # CONFIGURATION POUR CONFLIT SCRIPT
                     
  #Utilisation du menu shop de YANFLY (Yanfly Engine Ace - Ace Shop Options v1.01)
  YANFLY_MENU = false
  
  #Utilisation du script de craft de  V.M of D.T (Advanced Recipe Crafting v1.0b)
  CRAFT_MENU = false
  #Si vous utilisez ce script :
  #Lors de la configuration de vos recettes pour le prix vous pouvez configurer ainsi :
  #:gold_cost => [10,"Or"], #par exemple
  #ou encore :
  #:gold_cost => [10,"Or",200,"Argent"],
  #Lors du lancement d'un menu crafting si vous ne voulez pas utiliser toutes les monnaies,
  #ajoutez cela comme appel de script avant de lancer le magasin :
  #$crafting_monnaie = "Or" #pour n'utiliser que l'or
  #$crafting_monnaie = ["Or","Argent",...] #pour utiliser que les monnaies données
  #$crafting_monnaie = :all #pour utiliser toutes les monnaies
  #ne pas définir $crafting_monnaie utiliser toutes les monnaies
  
  #Utilisation du script de Selchar et Tsukihime (Instance Equip Leveling Base 0 Ver. 1.05)
  SELCHAR_WEAPON_UPGRADE = false
  
  #Utilisation du script de bank de Galv (Galv's Item/Bank Storage)
  GALV_BANK_SYSTEM = true
  #La modification permet de stocker toutes les monnaies
  #NOUVELLE FONCTION :
  #Dans le menu bank l'appui de la touche CTRL change la monnaie à déposer
  #bank_add(amount,name)
  #bank_rem(amount,name)
  #bank_count(name)
  
  ##############################################################################
  
  #Type du magasin (1 ou 2)
  TYPE_MENU_MAGASIN = 2
=begin
  2 Types de magain sont à votre disposition. 
  
  MAGASIN 1 :  
  Le magasin 1 est le magasin classique, chaque item peut voir son prix défini
  en fonction de toutes les monnaies à la fois :
  ex : 1 potion coûte 10 d'Or et 20 de Cuivre.
  
  Il faut un appel de script avant de lancer le magasin pour choisir les monnaies
  disponible dans celui-ci :
  Faire un appel de script : magasin(name)
  name est le nom de la monnaie utilisable ou un tableau des monnaies utilisables
  Faire ensuite un appel de magasin basique
  ATTENTION : les objets du magasin doivent avoir été définis comme ci-après
  sinon une erreur va se produire
  ex : magasin("Or")
  ou : magasin(["Or","Argent"])
  
  Pour définir les prix des objets il faut faire ainsi :
  Dans la note de l'item mettre :
  <Money = Prix,MON,PRIX,MON,...>
  ex : <Money = 50,Or,20,Argent> pour 50 d'or et 20 d'argent.
  
  Le menu magasin de Yanfly est compatible avec ce magasin.
  
  MAGASIN 2 :
  Le magasin 2 est le magasin amélioré pour ne pas déformer l'affichage en cas 
  d'utilisation de beaucoup de monnaies et plus simple d'utilisation. Chaque 
  objet voit son prix défini en fonction d'une seule monnaie à la fois :
  ex : 1 potion coûte 10 d'Or OU 20 de Cuivre.
  
  Il ne faut pas d'appel de script avant de lancer ce magasin.
  
  Pour définir les prix des objets, il faut faire ainsi :
  Dans la note de l'item mettre :
  <Money = Prix,MON,PRIX,MON,...>
  ex : <Money = 50,Or,20,Argent> pour 50 d'or OU 20 d'argent.
  
  Le menu magasin de Yanfly n'est peut-être pas compatible avec ce magasin.

=end
##############                     
=begin
  Nouvelle fonction :
  Dans un texte au lieu de mettre \G on peut désormais mettre \G[id] pour
  remplacer par le nom de la id'ème monnaie
  Pour ouvrir la fenêtre avec la quantité d'argent (avec \$)
  on peut désormais mettre \$[id] pour la id'ème monnaie ou encore \$[id1,id2]
  pour afficher 2 monnaies etc...
 
  En appel de script, pour changer ou récupérer la valeur d'une monnaie :
 
  #Ajout de monnaie
   gain_monnaie(name,value)
   name => sont nom ex "Or"
   value => la valeur du gain (possibilité de mettre la valeur
   d'une variable en écrivant $game_variables[n])
 
  #Perte de monnaie
   perte_monnaie(name,value)
   name => sont nom ex "Or"
   value => la valeur de la perte (possibilité de mettre la valeur
   d'une variable en écrivant $game_variables[n])
 
  #Récupérer la valeur d'une monnaie
   monnaie(name)
   name => son nom ex "Or"
   OU
   name => tableau de nom ex: ["Or","Argent"]
 
  #Pour lancer un magasin avec une monnaie particulière (uniquement magasin 1) :
   Faire un appel de script : magasin(name)
   name est le nom de la monnaie utilisable ou un tableau des monnaies utilisables
   Faire ensuite un appel de magasin basique
   ATTENTION : les objets du magasin doivent avoir été définis comme ci-dessous
   Sinon une erreur va se produire
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
##############################
# Modification Window_Message#
##############################
class Window_Message
  alias process_escape_character_multi_monnaie process_escape_character
  def process_escape_character(code, text, pos)
    case code.upcase
    when '$'
      if text[0] == "["
        i = 0
        while text[i] != "]"
          i+= 1
        end
        ok = text.slice!(0..i)
        ok = ok[1..-2]
        ok = ok.split(",")
        ok.each_index {|id| ok[id] = ok[id].to_i}
        @gold_window.height = (ok.length+1)*24
        @gold_window.value_affichage = ok
        @gold_window.create_contents
        @gold_window.refresh
      end
    end
    process_escape_character_multi_monnaie(code, text, pos)
  end
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
    a = 0
    for ene in 0..dead_members.length-1
      a += dead_members[ene].gold
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
    a *= gold_rate
    $game_party.gain_gold(a) if a != 0
    return sprintf(Vocab::ObtainGold, a) if result.empty? && a != 0
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
  def money
    @gold_window.value_affichage
  end
end
#####################################
# Modification de la window shopBuy #
#####################################
class Window_ShopBuy < Window_Selectable
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
end
if Monnaie::TYPE_MENU_MAGASIN == 1
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
    def selling_price
      if @item.note =~ /<Money = (\S+)>/
        array = $1.split(",")
        result = {}
        for i in 0..(array.length-1)/2
          result[array[i*2+1]] = (array[i*2].to_i/2)
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
      return false if item == nil
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
elsif Monnaie::TYPE_MENU_MAGASIN == 2
  ################################
  # Modification de la Scene_Shop#
  ################################
  class Scene_Shop < Scene_MenuBase
    alias create_gold_window_monnaie create_gold_window
    def create_gold_window
      create_gold_window_monnaie
      array = Monnaie::MONNAIE_MENU
      if Monnaie::YANFLY_MENU
        @gold_window.height = 24+24*array.length
        @gold_window.y = 0
      end
      @gold_window.value_affichage = [array[0]]
      @gold_window.create_contents
      @gold_window.refresh
      $monnaie_index = 0
    end
    def create_buy_window
      wy = @dummy_window.y
      wh = @dummy_window.height
      @buy_window = Window_ShopBuy.new(0, wy, wh, @goods)
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
          next if id != $monnaie_index
          ok.push($game_party.gold2[id] / value)
        end
        return ok.min
      end
    end
    def selling_price
      if @item.note =~ /<Money = (\S+)>/
        array = $1.split(",")
        result = {}
        for i in 0..(array.length-1)/2
          result[array[i*2+1]] = (array[i*2].to_i/2)
        end
        return result
      else
        return @item.price / 2
      end
    end
    alias update_multy_monnaie update
    def update
      update_multy_monnaie
      if Input.trigger?(:CTRL)
        $monnaie_index += 1 
        $monnaie_index %= Monnaie::MONNAIE_MENU.length
        @gold_window.value_affichage = [Monnaie::MONNAIE_MENU[$monnaie_index]]
        @gold_window.create_contents
        @gold_window.refresh
        @buy_window.refresh
        @sell_window.refresh
      end
    end
  end
  ######################################
  # Modification de la Window ShopSell #
  ######################################
  class Window_ShopSell < Window_ItemList
    def enable?(item)
      return false if item == nil
      if item.note =~ /<Money = (\S+)>/
        array = $1.split(",")
        result = {}
        for i in 0..(array.length-1)/2
          result[array[i*2+1]] = array[i*2].to_i
        end
        return true if result.has_key?(Monnaie::NAME[$monnaie_index])
        return false
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
          next if $monnaie_index != Monnaie::NAME.index(key)
          width_tot += text_size((value*@number).to_s).width
          if Monnaie::ICON[Monnaie::NAME.index(key)] != nil
            width_tot += 24
          else
            width_tot += text_size(key).width
          end
        end
        rect.width -= width_tot
        @price.each do |key,value|
          next if $monnaie_index != Monnaie::NAME.index(key)
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
    def initialize(x, y, height, shop_goods)
      super(x, y, window_width, height)
      @shop_goods = shop_goods
      refresh
      select(0)
    end
    def enable?(item)
      if item && !$game_party.item_max?(item)
        return false if !@price[item].has_key?(Monnaie::NAME[$monnaie_index])
        price(item).each do |key,value|
          next if $monnaie_index != Monnaie::NAME.index(key)
          return false if value > $game_party.gold2[Monnaie::NAME.index(key)]
        end
      else
        return false
      end
      return true
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
          next if $monnaie_index != Monnaie::NAME.index(key)
            width_tot += text_size(value.to_s).width
          if Monnaie::ICON[Monnaie::NAME.index(key)] != nil
            width_tot += 24
          else
            width_tot += text_size(key).width
          end
        end
        rect.width -= width_tot
        price(item).each do |key,value|
          next if $monnaie_index != Monnaie::NAME.index(key)
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
    if @value_affichage != []
      for i in 0..@value_affichage.length-1
        draw_currency_value(value(@value_affichage[i]-1), currency_unit(@value_affichage[i]-1), 4, i*line_height, contents.width - 8)
      end
    else
      draw_currency_value(value, currency_unit, 4, 0, contents.width - 8)
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
##################################
# Modification de la window gold #
##################################
class Window_Gold2 < Window_Gold
  def refresh
    contents.clear
    if @value_affichage != []
      @coef2 = (contents.width/calcul_size).to_f
      @coef = [@coef2,1.0].min
      @pos_x = 0
      for i in @value_affichage
        largeur = text_size(value(i-1).to_s+" ").width
        if currency_unit(i-1).is_a?(Integer)
          largeur += 24
        else
          largeur += text_size(currency_unit(i-1)+"   ").width
        end
        @pos_x += largeur*@coef
        draw_currency_value(value(i-1), currency_unit(i-1), contents.width-@pos_x, 0, largeur*@coef)
      end
    else
      draw_currency_value(value, currency_unit, 4, 0, contents.width - 8)
    end
  end
  def calcul_size
    w = 0
    texte = ""
    for i in 0..@value_affichage.length-1
      texte += value(@value_affichage[i]-1).to_s+" "
      if currency_unit(@value_affichage[i]-1).is_a?(Integer)
        w+= 26 
      else
        texte += currency_unit(@value_affichage[i]-1)+" "
      end
    end
    w += text_size(texte).width
    return w
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
    SceneManager.scene.prepare(goods, @params[4],@magasin_monnaie) if Monnaie::TYPE_MENU_MAGASIN == 1
    SceneManager.scene.prepare(goods, @params[4]) if Monnaie::TYPE_MENU_MAGASIN == 2
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
  $crafting_monnaie = :all
  class Scene_CraftingAll < Scene_Base
    alias start_multi_monnaie start
    def start
      start_multi_monnaie
      if !ADV_RECIPE::DISABLE_GOLD_COST
        array = Monnaie::MONNAIE_MENU if $crafting_monnaie == :all
        if $crafting_monnaie.is_a?(Array)
          array = []
          for i in $crafting_monnaie
            array.push(Monnaie::NAME.index(i)+1)
          end
        elsif $crafting_monnaie.is_a?(String)
          array = [Monnaie::NAME.index($crafting_monnaie)+1]
        end
        @gold_window = Window_Gold2.new
        @gold_window.width = Graphics.width / 2
        @gold_window.y = Graphics.height - @gold_window.height
        @gold_window.x = Graphics.width / 2
        @gold_window.value_affichage = array
        @gold_window.create_contents
        @gold_window.refresh
      end
    end
    def terminate
      super
      $crafting_monnaie = :all
    end
  end
  #Modification de la class recette
  class Recipe
    #Modification du test de possetion argent
    def has_gold?
      if @gold_cost.is_a?(Array)
        result = 0
        for i in 0..@gold_cost.length/2-1
          id = Monnaie::NAME.index(@gold_cost[i*2+1])
          if $crafting_monnaie.is_a?(Array)
            if $game_party.gold2[id] >= @gold_cost[i*2] && $crafting_monnaie.include?(@gold_cost[i*2+1])
              result +=2
            else
              return false
            end
          elsif $crafting_monnaie.is_a?(String)
            if $game_party.gold2[id] >= @gold_cost[i*2] && $crafting_monnaie == @gold_cost[i*2+1]
              result +=2
            else
              return false
            end
          else
            if $game_party.gold2[id] >= @gold_cost[i*2]
              result +=2
            else
              return false
            end
          end
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
        draw_text(0,contents.height-contents.font.size*2,contents.width,contents.font.size,"Coût de production :")
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
            w = text_size(i.to_s).width*1.2
            w *= 1.2 if i.to_s.length == 1
            draw_text(x+width-w-x2, y, w, contents.font.size, i.to_s, 2)
            x2 += w
          else
            id = Monnaie::NAME.index(i)
            if Monnaie::ICON[id] != nil
              draw_icon(Monnaie::ICON[id], x+width-24-x2, y-(24-contents.font.size)/2)
              x2 += 24
            else
              w = text_size(i).width*1.2
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
################################
# Modif pour l'update des arme #
################################
if Monnaie::SELCHAR_WEAPON_UPGRADE
  class Scene_Shop < Scene_MenuBase
    def selling_price
      if @item.note =~ /<Money = (\S+)>/
        array = $1.split(",")
        result = {}
        for i in 0..(array.length-1)/2
          begin
            @item.level
            result[array[i*2+1]] = (@item.make_price(array[i*2].to_i)/2)
          rescue
            result[array[i*2+1]] = (array[i*2].to_i)/2
          end
        end
        return result
      else
        return @item.price / 2
      end
    end
  end
  class Window_ShopBuy < Window_Selectable
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
              begin
                item.level
                result[array[i*2+1]] = item.make_price(array[i*2].to_i)
              rescue
                result[array[i*2+1]] = array[i*2].to_i
              end
            end
            @price[item] = result
          else
            @price[item] = goods[2] == 0 ? item.price : goods[3]
          end
        end
      end
    end
  end
end
################################
# Modif pour le system de bank #
################################
if Monnaie::GALV_BANK_SYSTEM
  class Window_Bank < Window_Selectable
    alias initialize_multi_monnaie initialize
    def initialize
      @monnaie = 0
      initialize_multi_monnaie
    end
    def gold_transfer
      if Input.repeat?(:DOWN) && $game_party.gold2[@monnaie] > 0 || Input.repeat?(:UP) && $game_party.gold_stored[@monnaie] > 0
          RPG::SE.new(Storage::SE_BANK[0], Storage::SE_BANK[1], Storage::SE_BANK[2]).play
      end
      if Input.press?(:DOWN)
        before = $game_party.gold2[@monnaie]
        $game_party.lose_gold(@deposit_rate,@monnaie)
        after = $game_party.gold2[@monnaie]
        $game_party.gold_stored[@monnaie] += (before - after)
        @deposit_rate += 1
        refresh
      end
      if Input.trigger?(:R) && !Input.press?(:DOWN) && !Input.press?(:UP)
        return if $game_party.gold2[@monnaie] == 0
        before = $game_party.gold2[@monnaie]
        $game_party.lose_gold($game_party.gold2[@monnaie],@monnaie)
        after = $game_party.gold2[@monnaie]
        $game_party.gold_stored[@monnaie] += before - after
        refresh
        RPG::SE.new(Storage::SE_BANK[0], Storage::SE_BANK[1], Storage::SE_BANK[2]).play
      end
      if !Input.press?(:DOWN)
        @deposit_rate = 1
      end
      if Input.press?(:UP)
        @withdraw_rate = $game_party.gold_stored[@monnaie] if @withdraw_rate >= $game_party.gold_stored[@monnaie]
        before = $game_party.gold_stored[@monnaie]
        $game_party.gold_stored[@monnaie] -= @withdraw_rate
        after = $game_party.gold_stored[@monnaie]
        $game_party.gain_gold(before - after,@monnaie)
        if $game_party.gold_stored[@monnaie] == 0
          return refresh
        end
        @withdraw_rate += 1
        refresh
      end
      
      if Input.trigger?(:L) && !Input.press?(:DOWN) && !Input.press?(:UP)
        take_all_gold = $game_party.gold_stored[@monnaie]
        before = $game_party.gold_stored[@monnaie]
        $game_party.gold_stored[@monnaie] -= take_all_gold
        after = $game_party.gold_stored[@monnaie]
        $game_party.gain_gold(before - after,@monnaie)
        refresh
        RPG::SE.new(Storage::SE_BANK[0], Storage::SE_BANK[1], Storage::SE_BANK[2]).play
      end
      if !Input.press?(:UP)
        @withdraw_rate = 1
      end
      if Input.trigger?(:CTRL)
        @monnaie += 1
        @monnaie %= Monnaie::NAME.length
        refresh
      end
    end
    def refresh
      contents.clear
      draw_gold_location(Storage::GOLD_INVENTORY, 0, 0, 250)
      draw_gold_location(Storage::GOLD_BANKED, 0, line_height * 1, 250)
      draw_currency_value([value,Monnaie::NAME[@monnaie]],"", 0, 0, contents.width)
      draw_currency_value([value_stored,Monnaie::NAME[@monnaie]],"", 0, line_height * 1, contents.width)
    end
    def draw_currency_value(value, unit, x, y, width)
      if value.is_a?(Array)
        x2 = 0
        value2 = value.clone.reverse!
        for i in value2
          if i.is_a?(Integer)
            w = text_size(i.to_s).width*1.2
            draw_text(width-w-x2-x, y, w, contents.font.size, i.to_s, 2)
            x2 += w
          else
            id = Monnaie::NAME.index(i)
            if Monnaie::ICON[id] != nil
              draw_icon(Monnaie::ICON[id], width-24-x2-x, y-(24-contents.font.size)/2)
              x2 += 24
            else
              w = text_size(i).width*1.2
              draw_text(width-w-x2-x, y, w, contents.font.size, i, 2)
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
    def value
      $game_party.gold2[@monnaie]
    end
    def value_stored
      $game_party.gold_stored[@monnaie]
    end
  end
  class Game_Interpreter
    def bank_add(amount,name)
      id = Monnaie::NAME.index(name)
      $game_party.gold_stored[id] += amount
    end
    def bank_rem(amount,name)
      id = Monnaie::NAME.index(name)
      $game_party.gold_stored[id] -= amount
      $game_party.gold_stored[id] = 0 if $game_party.gold_stored[id] < 0
    end
    def bank_count(name)
      id = Monnaie::NAME.index(name)
      $game_party.gold_stored[id]
    end
  end
  class Game_Party < Game_Unit
    
    alias init_all_items_multi_monnaie init_all_items
    def init_all_items
      init_all_items_multi_monnaie
      init_gold_stored
    end
    
    def init_gold_stored
      @gold_stored = {}
      for i in 0...Monnaie::NAME.length
        @gold_stored[i] = 0
      end
    end
  end
end
