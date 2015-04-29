=begin
#################################################################
Modification de l'apparence du héros en fonction de l'armure
####
Vincent26
####
Description :
Ce script permet de modifier le personnage en fonction de son equipement
####
Utilisation :
Pour faire en sorte qu'un équipement modifie l'apparence du perso il faut mettre :
<Image = NAME>
dans la note de l'objet (NAME etant le nom de l'image lié a l'objet, il ne doit pas contenir d'espace !)
Les images sont a ajouter dans le dossier character
 
 
le sprite est creer ainsi :
1 er couche : armure
2 eme couche : accessoire
3 eme couche : arme
4 eme couche : bouclier
5 eme couche :casque
 
 
 
si aucun objet n'est équiper ou si il n'a pas d'image associer une image par défault est prise
elle doivent ce nommé ainsi :
Base_ID
ou ID est a remplacer par le chiffre correspondant a l'emplacement
0 arme, 1 bouclier, 2 casque, 3 armure, 4 accessoire
 
ex : nom de l'image de base pour la tête :
Base_2.png
 
=end
class Sprite_Character < Sprite_Base
  alias set_character_bitmap_old set_character_bitmap
  def set_character_bitmap
    if (@character.character_name == $data_actors[1].character_name)&&(@character.character_index == $data_actors[1].character_index)
      bitmap = Cache.character(@character_name)
      sign = @character_name[/^[\!\$]./]
      if sign && sign.include?('$')
        w = bitmap.width
        h = bitmap.height
      else
        w = bitmap.width / 4
        h = bitmap.height / 2
      end
      bitmap_principale = Bitmap.new(w,h)
      i = 3
      while i != -1
        begin
          item = $data_weapons[$game_party.leader.equips[i].id] if $game_party.leader.equip_slots[i] == 0
          item = $data_armors[$game_party.leader.equips[i].id] if $game_party.leader.equip_slots[i] != 0
          item.note =~ /<Image = (\S+)>/
          name = $1.to_s
          name = nil if name ==""
        rescue
          name = nil
        end
        if name != nil
          bitmap = Cache.character(name)
          bitmap_principale.blt(0, 0, bitmap, Rect.new(0,0,w,h))
        else
          begin
            bitmap = Cache.character("Base_"+i.to_s)
            bitmap_principale.blt(0, 0, bitmap, Rect.new(0,0,w,h))
          rescue
          end
        end
        i = (i == 2) ? -1 : (i+1) % 5
      end
      self.bitmap = bitmap_principale
      @cw = bitmap_principale.width / 3
      @ch = bitmap_principale.height / 4
      self.ox = @cw / 2
      self.oy = @ch
    else
      set_character_bitmap_old
    end
  end
end
class Window_Base < Window
  alias draw_character_old draw_character
  def draw_character(character_name, character_index, x, y)
    return unless character_name
    if (character_name == $data_actors[1].character_name)&&(character_index == $data_actors[1].character_index)
      bitmap = Cache.character(character_name)
      sign = character_name[/^[\!\$]./]
      if sign && sign.include?('$')
        w = bitmap.width
        h = bitmap.height
      else
        w = bitmap.width / 4
        h = bitmap.height / 2
      end
      bitmap_principale = Bitmap.new(w,h)
      i = 3
      while i != -1
        begin
          item = $data_weapons[$game_party.leader.equips[i].id] if $game_party.leader.equip_slots[i] == 0
          item = $data_armors[$game_party.leader.equips[i].id] if $game_party.leader.equip_slots[i] != 0
          item.note =~ /<Image = (\S+)>/
          name = $1.to_s
          name = nil if name ==""
        rescue
          name = nil
        end
        if name != nil
          bitmap = Cache.character(name)
          bitmap_principale.blt(0, 0, bitmap, Rect.new(0,0,w,h))
        else
          begin
            bitmap = Cache.character("Base_"+i.to_s)
            bitmap_principale.blt(0, 0, bitmap, Rect.new(0,0,w,h))
          rescue
          end
        end
        i = (i == 2) ? -1 : (i+1) % 5
      end
      cw = bitmap_principale.width / 3
      ch = bitmap_principale.height / 4
      n = character_index
      src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
      contents.blt(x - cw / 2, y - ch, bitmap_principale, src_rect)
    else
      draw_character_old(character_name, character_index, x, y)
    end
  end
end
