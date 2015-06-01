=begin
##############################################################
Weapon_Upgrade
####
Vincent26
####
Description:
Ce script permet de monter en level pour l'utilisation de catégorie d'arme
Le principe et que chaque coup donner avec un type d'arme particulier augmente
son experience. Une fois un niveaux passer le personnage reçois une amélioration
définitive d'une de ces caractéristique
Un menu secondaire est ajouter au menu status a l'appuye de la touche shift
Le niveau de competence pour une arme du héros est asocier a un nom descriptif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Il est actuellement adapter pour focntionner avec le script Yanfly - Ace status menu

####
Utilisation :
Configurer le module suivant pour mettre en place ce script
=end
module Weapon_Upgrade
  
  #Ne pas modifier
  CARACTERISTIQUE = {:max_hp => 0,:max_mp => 1,:force => 2,:defense => 3,
                    :magic_atk => 4,:magic_def => 5,:agilité => 6,:chance => 7}
  
  #LISTE DES TYPES D'ARMES DANS LE LEXIQUE DE LA BDD
  #
  #
  # Liste des upgrades des types d'armes :
  # TYPE => [[NBR_COUP,VALEUR,CARACTERISTIQUE,[ID_PERSONNAGE]],...]
  #
  # TYPE est le type d'arme (l'id associé dans la BDD)
  # VALEUR est la valeur à ajouter à la caractéristique du perso
  # CARACTERISTIQUE est la caractéristique à modifier
  # ID_PERSONNAGE est la liste des personnages à qui peut s'appliquer cet upgrade
  UPGRADE_LIST = {
    1 => [[20,3,:force,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:force,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:force,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:force,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:force,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:force,[1,2,3,4,5,6,7,8,9,10]]],
    2 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:force,[1,2,3,4,5,6,7,8,9,10]]],
    3 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:force,[1,2,3,4,5,6,7,8,9,10]]],
    4 => [[20,3,:force,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:force,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:force,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:force,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:force,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:force,[1,2,3,4,5,6,7,8,9,10]]],
    5 => [[20,3,:force,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:force,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:force,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:force,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:force,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:force,[1,2,3,4,5,6,7,8,9,10]]],
    6 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:agilité,[1,2,3,4,5,6,7,8,9,10]]],
    7 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:agilité,[1,2,3,4,5,6,7,8,9,10]]],
    8 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,150,:magic_atk,[1,2,3,4,5,6,7,8,9,10]]],
    9 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,150,:magic_atk,[1,2,3,4,5,6,7,8,9,10]]],
   10 => [[20,3,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [50,5,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [100,10,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [500,20,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [1000,50,:agilité,[1,2,3,4,5,6,7,8,9,10]],
         [9999,100,:agilité,[1,2,3,4,5,6,7,8,9,10]]]
    }
  
  #Nombre de type d'arme
  NBR_TYPE_ARME = 10
  
  #Liste des types d'armes
  LIST_TYPE_ARME = ["Hache","Griffes","Lance","Épée","Katana","Arc","Dague",
                    "Massue","Bâton","Arme à feu"]
  
  #Description des levels de maitrisse
  LVL_DESCRIPTION = {0=>"Néophyte",20=>"Initié",50=>"Apprenti",100=>"Confirmé",
                    500=>"Expert",1000=>"Maître", 9999=>"Légende"}
  
  #Pour définir une autre attaque que celle de base pour le décompte des point 
  #ajouter cela dans la note d'un personnage :
  #<Basic_Skill = ID>
  #ID est l'id de la compétence prise pour base
  
end
class Scene_Battle
  
  alias start_weapon_upgrade start
  def start
    @attaque_standard = false
    start_weapon_upgrade
  end
  
  alias use_item_weapon_upgrade use_item
  def use_item
    @attaque_standard = false
    item = @subject.current_action.item
    if @subject.actor?
      if @subject.actor.note =~ /<Basic_Skill = (\d+)>/
        skill_id = $1.to_i
        @attaque_standard = true if item.id == skill_id
      else
        @attaque_standard = true if item.animation_id < 0
      end
    end
    use_item_weapon_upgrade
  end
  
  alias apply_item_effects_weapon_uprade apply_item_effects
  def apply_item_effects(target, item)
    apply_item_effects_weapon_uprade(target, item)
    if target.result.hit? && target.result.success && @attaque_standard
      if @subject.actor?
        @subject.upgrade_weapon_skill
      end
    end
  end
  
end
module BattleManager
  
  class << self
    
    alias gain_exp_weapon_update gain_exp
    alias process_abort_weapon_update process_abort
    
    def gain_exp
      new = false
      for i in $game_party.members
        for j in i.texte_fin_combat
          $game_message.new_page if new = false
          new = true
          $game_message.add(j)
        end
        i.texte_fin_combat = []
      end
      gain_exp_weapon_update
    end
    
    def process_abort
      new = false
      for i in $game_party.members
        for j in i.texte_fin_combat
          $game_message.new_page if new = false
          new = true
          $game_message.add(j)
        end
        i.texte_fin_combat = []
      end
      process_abort_weapon_update
    end
  end
end
class Game_Actor
  
  attr_reader :upgrade_list
  attr_accessor :texte_fin_combat
  
  alias initialize_weapon_upgrade initialize
  def initialize(actor_id)
    initialize_weapon_upgrade(actor_id)
    @weapon_upgrade = {}
    @texte_fin_combat = []
    @upgrade_list = {}
    Weapon_Upgrade::UPGRADE_LIST.each do |key,value|
      li = []
      for list in value
        if list[3].include?(actor_id)
          li.push([list[0],list[1],list[2],true])
        end
      end
      @upgrade_list[key] = li if li != []
    end
  end
  
  def upgrade_weapon_skill
    for i in 1..Weapon_Upgrade::NBR_TYPE_ARME
      if wtype_equipped?(i)
        @weapon_upgrade[i.to_s] = 0 if !@weapon_upgrade.include?(i.to_s)
        @weapon_upgrade[i.to_s] += 1
        test_upgrade_weapon(i)
      end
    end
  end
  
  def weapon_upgrade
    return @weapon_upgrade
  end
  
  def test_upgrade_weapon(id)
    @upgrade_list.each do |key,lis|
      next if key != id
      for j in 0..lis.length-1
        liste = lis[j]
        if liste[3]
          if @weapon_upgrade[id.to_s] >= liste[0]
            param = Weapon_Upgrade::CARACTERISTIQUE[liste[2]]
            add_param(param, liste[1])
                     #NOMPERSO          |              NOUVEAU RANG                  |        |        NOM ARME              |                      | NOM DU PARAMETRE|     | VALEUR AUG |
            @texte_fin_combat.push(@name +" devient "+Weapon_Upgrade::LVL_DESCRIPTION[liste[0]].to_s+" en "+Weapon_Upgrade::LIST_TYPE_ARME[id-1]+ ", "+Vocab.param(param)+" +"+liste[1].to_s+".")
            @upgrade_list[key][j][3] = false
          end
        end
      end
    end
  end
end
class Scene_Status
  
  
  alias update_weapon_upgrade update
  def update
    update_weapon_upgrade
    if Input.trigger?(:A)
      Sound.play_cursor
      switch_info
    elsif Input.trigger?(:UP) && @item_window.menu == 1
      Sound.play_cursor
      @item_window.ligne_actuel -= 1
      @item_window.refresh
    elsif Input.trigger?(:DOWN) && @item_window.menu == 1
      Sound.play_cursor
      @item_window.ligne_actuel += 1
      @item_window.refresh
    end
  end
  
  def switch_info
    if @item_window.menu == 1
      @item_window.menu = 0
      @command_window.activate
    else
      @item_window.menu = 1
      @command_window.deactivate
    end
    @item_window.refresh
  end
end
class Window_StatusItem < Window_Base
  
  attr_accessor :menu
  attr_reader :ligne_actuel
  
  alias initialize_weapon_upgrade initialize
  def initialize(*args)
    @ligne_actuel = 0
    initialize_weapon_upgrade(*args)
    @menu = 0
  end
  
  def ligne_actuel=(value)
    table = []
    for feat in @actor.class.features
      if feat.code == 51
        table.push(feat.data_id)
      end
    end
    table.uniq!
    @ligne_actuel = [[value,table.length-5].min,0].max
  end
  
  def refresh
    contents.clear
    reset_font_settings
    return unless @actor
    draw_window_contents if @menu == 0
    draw_block_vincent26(0) if @menu == 1
  end
  
  def draw_block_vincent26(y)
    table = []
    for feat in @actor.class.features
      if feat.code == 51
        table.push(feat.data_id)
      end
    end
    table.uniq!
    draw_arme_usable(32,y,table)
    draw_arme_lvl(270,y,table)
    draw_arme_param(380,y,table)
    draw_arme_rang(150,y,table)
  end
  
  
  def draw_arme_rang(x,y,table)
    for i in 0..table.length
      next if i > 5
      if i != 0
        nbr = @actor.weapon_upgrade[table[i-1+@ligne_actuel].to_s] || 0
        rang = Weapon_Upgrade::LVL_DESCRIPTION[0]
        Weapon_Upgrade::LVL_DESCRIPTION.each do |key , value|
          break if nbr < key
          rang = value
        end
        rang = "" if !Weapon_Upgrade::UPGRADE_LIST.has_key?(table[i-1+@ligne_actuel])
      else
        rang = "Rang"
      end
      draw_text_ex(x, y+i*line_height, rang)
    end
  end
  
  def draw_arme_param(x,y,table)
    for i in 0..table.length
      next if i > 5
      if i != 0
        if @actor.upgrade_list.has_key?(table[i-1+@ligne_actuel])
          for j in @actor.upgrade_list[table[i-1+@ligne_actuel]]
            if j[3] == true
              value = j[1]
              param = Weapon_Upgrade::CARACTERISTIQUE[j[2]]
              texte = Vocab::param(param)+" +"+value.to_s
              break
            end
            texte = "-----"
          end
        else
          texte = "-----"
        end
      else
        texte = "Upgrade"
      end
      draw_text_ex(x, y+i*line_height, texte)
    end
  end
  
  def draw_arme_usable(x,y,table)
    for i in 0..table.length
      if i != 0
        next if i > 5
        texte = Weapon_Upgrade::LIST_TYPE_ARME[table[i-1+@ligne_actuel]-1]
      else
        texte = "Type"
      end
      draw_text_ex(x, y+i*line_height, texte)
    end
  end
  
  def draw_arme_lvl(x,y,table)
    for i in 0..table.length
      if i != 0
        next if i > 5
        nbr = @actor.weapon_upgrade[table[i-1+@ligne_actuel].to_s] || 0
        if @actor.upgrade_list.has_key?(table[i-1+@ligne_actuel])
          for j in @actor.upgrade_list[table[i-1+@ligne_actuel]]
            if j[3] == true
              lvl = j[0]
              texte = nbr.to_s+"/"+lvl.to_s
              break
            end
            texte = "-/-"
          end
        else
          texte = "-/-"
        end
      else
        texte = "Points"
      end
      draw_text_ex(x, y+i*line_height, texte)
    end
  end
end
