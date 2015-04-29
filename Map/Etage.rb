################################################################################
#                  ETAGE BY VINCENT_26                                        #
################################################################################
=begin
Crédit : Vincent_26
Version 2.3
Ce script permet de créer des étages facilement
Pour le mettre n’en place rien de plus simple :
-Ajouter l'id de la map sur laquelle vous voulez activer le script dans le tableau
prévu à cet effet.

-Créer les étages grâce aux régions id
0 : RDC (Rez de chaussé)
1 : escalier
2 : étage (impassable)
3 : étage (au-dessus du héros)
4 : escalier (etage par rapport au RDC)
5 : étage (impassable depuis l'étage 3 mais etage pour le RDC)
6 : étage pour le RDC et l'étage 3
...
C’est tout ^^
############################# BUG ET MAJ #######################################

  MAJ 2.3 :
    *Prise en compte de l'utilisation de l'areonef
    *Legere modif pour limiter le lag
  MAJ 2.2 :
    *Correction bug de creation dans certain cas de changement de map
  MAJ 2.1 :
    *Correction bug menu sauvegarde
  MAJ 2.0 :
    *Modification total du script avec nouveau system plus simple et plus efficace
    *Resolution de l'ecran correctement pris en compte
    *Ombre sur les etage pris en compte
    *Event animée sur un etage pris en compte
    *Eau et tile animée pris en compte
  VERSION 1.0 => obsolete

################################################################################

Contact : zeludtnecniv@gmail.com
         
          http://www.rpgmakervx-fr.com/t15645-vxacescript-d-etage
   
=end
module Etage
  #Si vous utiliser le systeme d'overlay de Yami mettre true :
  YAMI_OVERLAY = false
  #il faut de plus que ce script soit sous le script d'overlay
 
  #Pour recuperer l'etage du perso :
  #  $game_player.etage
 
  #Map d'activation du script
  MAP = [1,6]
 
  #Pour mettre un event a un etage particulier il doit avoir porter ce nom :
  #  ETAGE <id>
  #id est l'etage de l'event
 
end
#╔═════════════════════════════════════╗
#║    Modification du Spriteset_Map    ║
#╚═════════════════════════════════════╝
class Spriteset_Map
 
  if Etage::YAMI_OVERLAY
    alias create_overlay_map_etage create_overlay_map
    def create_overlay_map
      create_overlay_map_etage
      @light.viewport = @viewport4
      @shadow.viewport = @viewport4
      @par.viewport = @viewport4
    end
  end
 
  #Ajout de la variable etage
  alias initialize_etage initialize
  def initialize
    @etage = 0
    initialize_etage
  end
 
  #modification de l'update
  alias update_vincent update
  def update
    update_etage
    update_vincent
  end
 
  #Ajout de la suppression du tilemap
  alias dispose_tilemap_etage dispose_tilemap
  def dispose_tilemap
    dispose_tilemap_etage
    @tilemap2.dispose
  end
 
  #Ajout de la suppression du viewport
  alias dispose_viewports_etage dispose_viewports
  def dispose_viewports
    dispose_viewports_etage
    @viewport4.dispose
  end
 
  #Ajout d'une nouvelle viewport
  alias create_viewports_etage create_viewports
  def create_viewports
    create_viewports_etage
    @viewport4 = Viewport.new
    @viewport4.z = 20
  end
 
  #Mise a jour de l'etage
  def update_etage
    return if @etage == $game_player.etage && @map_id == $game_map.map_id
    @etage = $game_player.etage
    @tilemap2.map_data = $game_map.data.clone
    for i in 0..@tilemap2.map_data.xsize
      for j in 0..@tilemap2.map_data.ysize
        for k in 0..@tilemap2.map_data.zsize
          if $game_map.region_id(i,j) - @etage <= 2
            @tilemap2.map_data[i,j,k] = 0
          else
            unless Etage::MAP.include?($game_map.map_id)
              @tilemap2.map_data[i,j,k] = 0
            end
          end
        end
      end
    end
  end
 
  #Modification du chargement des tileset
  alias load_tileset_etage load_tileset
  def load_tileset
    load_tileset_etage
    @tilemap.flags = @tileset.flags
    @tileset.tileset_names.each_with_index do |name, i|
      @tilemap2.bitmaps[i] = Cache.tileset(name)
    end
    @tilemap2.flags = @tileset.flags
  end
 
  #Ajout de l'update tilemap a l'etage
  alias update_tilemap_etage update_tilemap
  def update_tilemap
    update_tilemap_etage
    if Etage::MAP.include?($game_map.map_id)
      if $game_player.in_airship?
        @tilemap2.visible = false
      else
        @tilemap2.visible = true
        @tilemap2.ox = $game_map.display_x * 32
        @tilemap2.oy = $game_map.display_y * 32
        @tilemap2.update
      end
    else
      @tilemap2.visible = false
    end
  end
 
  #Ajout de l'update de la nouvelle viewport
  alias update_viewports_etage update_viewports
  def update_viewports
    update_viewports_etage
    @viewport1.tone.set(Tone.new)
    @viewport4.tone.set($game_map.screen.tone)
    @viewport4.ox = $game_map.screen.shake
    @viewport4.update
  end
 
  #Changement de l'update des character pour mise a l'etage
  def update_characters
    refresh_characters if @map_id != $game_map.map_id
    for sprite in @character_sprites
      sprite.update
      if (sprite.etage-@etage) >= 2
        sprite.viewport = @viewport4
      else
        sprite.viewport = @viewport1
      end
    end
  end
 
  #Changement de la creation des tilemap (ajout d'un second tile map)
  def create_tilemap
    @tilemap = Tilemap.new(@viewport1)
    @tilemap2 = Tilemap.new(@viewport4)
    @tilemap.map_data = $game_map.data.clone
    @tilemap2.map_data = $game_map.data.clone
    result = []
    for i in 0..@tilemap2.map_data.xsize
      for j in 0..@tilemap2.map_data.ysize
        for k in 0..@tilemap2.map_data.zsize
          if ($game_map.region_id(i,j) - @etage) <= 1
            @tilemap2.map_data[i,j,k] = 0
          else
            unless Etage::MAP.include?($game_map.map_id)
              @tilemap2.map_data[i,j,k] = 0
            end
          end
        end
      end
    end
    load_tileset
  end
 
  #Changement de la creation des character pour mise a l'etage
  def create_characters
    @character_sprites = []
    $game_map.events.values.each do |event|
      if Etage::MAP.include?(@map_id)
        if event.event.name =~ /ETAGE <(\d+)>/
          etage = $1.to_i
          if etage > @etage+1
            @character_sprites.push(Sprite_Character.new(@viewport4, event))
          else
            @character_sprites.push(Sprite_Character.new(@viewport1, event))
          end
        else
          @character_sprites.push(Sprite_Character.new(@viewport1, event))
        end
      else
        @character_sprites.push(Sprite_Character.new(@viewport1, event))
      end
    end
    $game_map.vehicles.each do |vehicle|
      @character_sprites.push(Sprite_Character.new(@viewport1, vehicle))
    end
    $game_player.followers.reverse_each do |follower|
      @character_sprites.push(Sprite_Character.new(@viewport1, follower))
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $game_player))
    @map_id = $game_map.map_id
  end
 
end
#╔═══════════════════════════════════╗
#║  Modification du Scene_MenuBase  ║
#╚═══════════════════════════════════╝
class Scene_MenuBase
  #Reajustement de l'image de fond
  alias create_background_etage create_background
  def create_background
    create_background_etage
    @background_sprite.z = 20
  end
end
#╔═══════════════════════════════════╗
#║  Modification du Scene_File      ║
#╚═══════════════════════════════════╝
class Scene_File < Scene_MenuBase
  #Reajuste les viewport (mis au dessus du viewport etage)
  alias create_savefile_viewport_etage create_savefile_viewport
  def create_savefile_viewport
    create_savefile_viewport_etage
    @savefile_viewport.z = 21
  end
end
#╔═════════════════════════════════════╗
#║  Modification du Sprite_Character  ║
#╚═════════════════════════════════════╝
class Sprite_Character
 
  attr_reader :etage
 
  #Ajout de la variable etage
  alias initialize_etage initialize
  def initialize(viewport, character = nil)
    initialize_etage(viewport, character)
    @etage = 0
    begin
      if character.event.name =~ /ETAGE <(\d+)>/
        @etage = $1.to_i
      end
    rescue
      @etage = 0
    end
  end
end
#╔═══════════════════════════════╗
#║  Modification du Game_Event  ║
#╚═══════════════════════════════╝
class Game_Event
  #Ajout de la lecture de l'event associer
  attr_reader :event
end
#╔══════════════════════════════╗
#║ Modification du Game_Player  ║
#╚══════════════════════════════╝
class Game_Player
 
  #Ajout de la variable etage_actuel
  alias initialize_etage initialize
  def initialize
    initialize_etage
    @etage_actuel = 0
  end
 
  #Mise a jour de la variable etage_actuel
  alias update_etage update
  def update
    update_etage
    @etage_actuel = $game_map.region_id(x,y) if ($game_map.region_id(x,y)-@etage_actuel).abs <= 1
    @etage_actuel = 0 if !Etage::MAP.include?($game_map.map_id)
  end
 
  #Lecture de la variable en externe
  def etage
    return @etage_actuel
  end
 
  #Modification de la passabiliter pour l'etage
  alias passable_etage? passable?
  def passable?(x, y, d)
    return passable_etage?(x,y,d) if !Etage::MAP.include?($game_map.map_id)
    x2 = $game_map.round_x_with_direction(x, d)
    y2 = $game_map.round_y_with_direction(y, d)
    return false if $game_map.region_id(x2,y2)-etage <= -2
    if $game_map.region_id(x2,y2)-etage > 2
      return false if collide_with_characters?(x2, y2)
      return true
    elsif $game_map.region_id(x2,y2)-etage == 2
      return false
    elsif $game_map.region_id(x2,y2) - $game_map.region_id(x,y) <= -2
      return false unless $game_map.valid?(x2, y2)
      return true if @through || debug_through?
      return false unless map_passable?(x2, y2, reverse_dir(d))
      return false if collide_with_characters?(x2, y2)
      return true
    else
      return passable_etage?(x,y,d)
    end
  end
 
  #Modification de la sortie vehicule pour assignation etage
  alias update_vehicle_get_off_etage update_vehicle_get_off
  def update_vehicle_get_off
    @etage_actuel = $game_map.region_id(x,y) if Etage::MAP.include?($game_map.map_id) && in_airship?
    update_vehicle_get_off_etage
  end
 
  #Modification de la detection de collision avec des event
  def collide_with_events?(x, y)
    $game_map.events_xy_nt(x, y).any? do |event|
      if event.event.name =~ /ETAGE <(\d+)>/ && Etage::MAP.include?($game_map.map_id)
        etage = $1.to_i
        if (etage-@etage_actuel).abs >= 2
          false
        else
          event.normal_priority? || self.is_a?(Game_Event)
        end
      else
        event.normal_priority? || self.is_a?(Game_Event)
      end
    end
  end
 
  #Modification du demarrage des event
  def start_map_event(x, y, triggers, normal)
    return if $game_map.interpreter.running?
    $game_map.events_xy(x, y).each do |event|
      if event.trigger_in?(triggers) && event.normal_priority? == normal
        if event.event.name =~ /ETAGE <(\d+)>/ && Etage::MAP.include?($game_map.map_id)
          etage = $1.to_i
          event.start if (etage-@etage_actuel).abs < 2
        else
          event.start
        end
      end
    end
  end
end
