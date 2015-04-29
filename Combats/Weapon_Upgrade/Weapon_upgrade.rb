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
####
Utilisation :
Configurer le module suivant pour mettre en place ce script
=end
module Weapon_Upgrade
  #Ne pas modifier
  CARACTERISTIQUE = {:max_hp => 0,:max_mp => 1,:force => 2,:defense => 3,
                     :magic_att => 4,:magic_def => 5,:agiliter => 6,:chance => 7}
  
  #LISTE DES TYPE D'ARME DANS LE LEXIQUE DE LA BDD
  #
  #
  # Liste des upgrade des type d'arme (ne pas enlever ni oublier le true):
  # TYPE => [[NBR_COUP,VALEUR,CARACTERISTIQUE,[ID_PERSONNAGE]],...]
  #
  # TYPE est le type d'arme (l'id associer dans la BDD)
  # VALEUR est la valeur a ajouter a la caracteristique du perso
  # CARACTERISTIQUE est la cracteristique a modifier
  # ID_PERSONNAGE est la liste des personnage a qui peut s'appliquer cette upgrade
  UPGRADE_LIST = {
    1 => [[2,10,:force,[1,2]],[5,10,:defense,[1]]],
    2 => [[2,10,:max_hp,[2]]]
    }
  
  NBR_TYPE_ARME = 10
  
  LIST_TYPE_ARME = ["Hache","Griffes","Lance","Épée","Katana","Arc","Dague",
                    "Marteau","Bâton","Arme à feu"]
  
  LVL_DESCRIPTION = {0=>"Débutant",2=>"Initier",5=>"Novice",20=>"Apprentit",
                     40=>"Normal",80=>"Intermédiaire",160=>"Chercheur",
                     320=>"Habituer",640=>"Experimenter",1280=>"Maître",
                     2560=>"Grand Maître",6120=>"Génie",12240=>"Dieu"}
  
  
end
class Scene_Battle
  
  alias start_weapon_upgrade start
  def start
    @attaque_standard = false
    start_weapon_upgrade
  end
  
  alias show_animation_weapon_upgrade show_animation
  def show_animation(targets, animation_id)
    @attaque_standard = false
    show_animation_weapon_upgrade(targets, animation_id)
  end
  
  alias show_attack_animation_weapon_upgrade show_attack_animation
  def show_attack_animation(targets)
    show_attack_animation_weapon_upgrade(targets)
    @attaque_standard = true
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
    puts @weapon_upgrade
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
                                  #NOMPERSO          |              NOUVEAU RANG                   |        |         NOM ARME               |               | VALEUR AUG |   | NOM DU PARAMETRE|
            @texte_fin_combat.push(@name +" devient "+Weapon_Upgrade::LVL_DESCRIPTION[liste[0]].to_s+" en "+Weapon_Upgrade::LIST_TYPE_ARME[id]+ ", gain : +"+liste[1].to_s+" "+Vocab.param(param))
            @upgrade_list[key][j][3] = false
          end
        end
      end
    end
  end
end
class Scene_Status < Scene_MenuBase
  
  
  alias update_weapon_upgrade update
  def update
    update_weapon_upgrade
    if Input.trigger?(:A)
      Sound.play_cursor
      switch_info
    elsif Input.trigger?(:UP) && @status_window.menu == 1
      Sound.play_cursor
      @status_window.ligne_actuel -= 1
      @status_window.refresh
    elsif Input.trigger?(:DOWN) && @status_window.menu == 1
      Sound.play_cursor
      @status_window.ligne_actuel += 1
      @status_window.refresh
    end
  end
  
  def switch_info
    if @status_window.menu == 1
      @status_window.menu = 0
    else
      @status_window.menu = 1
    end
    @status_window.refresh
  end
end

class Window_Status
  
  attr_accessor :menu
  attr_reader :ligne_actuel
  
  alias initialize_weapon_upgrade initialize
  def initialize(actor)
    @ligne_actuel = 0
    initialize_weapon_upgrade(actor)
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
  
  alias draw_block3_weapon_upgrade draw_block3
  def draw_block3(y)
    if @menu == 1
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
    else
      draw_block3_weapon_upgrade(y)
    end
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
              texte = "+ "+value.to_s+" "+Vocab::param(param)
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
        texte = "Lvl"
      end
      draw_text_ex(x, y+i*line_height, texte)
    end
  end
end
