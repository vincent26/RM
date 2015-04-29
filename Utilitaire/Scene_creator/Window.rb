#╔═════════════════════════════════════════════════════════════════════════════╗
#║              \          / ¯¯|¯¯ |\   | |¯¯\ /¯¯\ \          /               ║
#║               \        /    |   | \  | |  | |  |  \        /                ║
#║                \  /\  /     |   |  \ | |  | |  |   \  /\  /                 ║
#║                 \/  \/    __|__ |   \| |__/ \__/    \/  \/                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
=begin 
Window presente :

-Window_FonctionModifSelect               (ligne   37) #| Fenetre de Modification fonction
-Window_List_Fonction                     (ligne   65) #| Liste des fonction lié a une window selectionné  
-Window_FonctionWindowDescription         (ligne  100) #| Fenetre de description generale pour les fonction
-Window_CaractSec_Ton_Test                (ligne  132) #| Fenêtre qui affiche le ton en instantaner
-Window_CaractCommand_Ton                 (ligne  155) #| Modification Caracteristique Window
-Window_CaracSec_OZH                      (ligne  173) #| Modification Fonction Window
-Window_CaractCommand                     (ligne  322) #| Modification Progamation des Fonction Window
-Window_TypeSec_LHEC                      (ligne  343) #| Modification Programation des Scene
-Window_TypeSec_Type                      (ligne  446) #| Modification Programation des Scene
-Window_TypeCommand                       (ligne  464) #| Modification Programation des Scene
-Window_Console_Message                   (ligne  491) #| Modification Programation des Scene
-Window_Scene_Coordonnée                  (ligne  501) #| Modification Programation des Scene
-Window_Scene_Coordonnée_Factice          (ligne  516) #| Modification Programation des Scene
-Window_WindowCommand                     (ligne  545) #| Modification Programation des Scene
-Window_EditorDescription                 (ligne  566) #| Modification Programation des Scene
-Window_Scene_Title                       (ligne  601) #| Modification Programation des Scene
-Window_List_Window                       (ligne  616) #| Modification Programation des Scene
-Window_EditorTypeDescription             (ligne  648) #| Modification Programation des Scene
-Window_EditorCaracteristiqueDescription  (ligne  678) #| Modification Programation des Scene
-Window_EditorMenuDescription             (ligne  706) #| Modification Programation des Scene
-Window_EditorCommand                     (ligne  736) #| Modification Programation des Scene
-Window_NameInputEdit                     (ligne  756) #| Modification Programation des Scene
-Window_NameEdit                          (ligne  768) #| Modification Programation des Scene
-Window_Load_EditorCommand                (ligne  850) #| Modification Programation des Scene
-Window_LoadCommand                       (ligne  881) #| Modification Programation des Scene
  
=end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_FonctionModifSelect     Fenêtre secondaire Fonction               ║
#║    Fenetre de Modification fonction                                         ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_FonctionModifSelect < Window_Command
  def initialize
    super(136,148)
  end
  def window_width
    return 272
  end
  def window_height
    return 120
  end
  def make_command_list
    add_command("Modifier Nom" ,    :Modif_Nom,        base_fonction?)
    add_command("Modifier Desc",    :Modif_Desc,        base_fonction?)
    add_command("Modifier"     ,    :Modif,        true)
    add_command("Supprimer"    ,    :Suppr,        base_fonction?)
  end
  def base_fonction?
    name = $game_editor.fonction_name rescue false
    if (name == "update") || (name == "initialize") || (name == "refresh")||(name == "creation_list")
      return false
    end
    return true
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Fonction              Liste commande window                  ║
#║    Liste des fonction lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Fonction < Window_Selectable
  def initialize
    super(0, 0,272,416)
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
    for i in 0..$game_editor.commande.length-1
      @data.push($game_editor.commande[i][:name])
    end
    @data.push("New Fonction")
  end
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
  end
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_FonctionWindowDescription         Description window              ║
#║    Fenetre de description generale pour les fonction                        ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_FonctionWindowDescription  < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    if id == $game_editor.commande.length
      draw_text_ex(0, 0, "Creation d'une nouvelle\nfonction")
    else
      desc = $game_editor.commande[id][:description]
      return unless desc.is_a?(String)
      desc = desc.split(" ")
      final = ""
      ligne = ""
      for i in 0..desc.length-1
        if (ligne+desc[i]).length > 23
          final += "\n"
          ligne = ""
        end
        final += desc[i]
        ligne += desc[i]
        final += " "
        ligne += " "
      end
      draw_text_ex(0, 0, final)
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CaractSec_Ton_Test     Window pour test de ton                    ║
#║    Fenêtre qui affiche le ton en instantaner                                ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CaractSec_Ton_Test < Window_Base
  def initialize
    super(0,13*24,544-272,416-13*24)
    tone = $game_editor.tone
    @tone = [tone[:red],tone[:green],tone[:blue],tone[:gray]]
    draw_text_ex(0,0,@tone.to_s)
  end
  def update
    super
    contents.clear
    tone = $game_editor.tone
    @tone = [tone[:red],tone[:green],tone[:blue],tone[:gray]]
    draw_text_ex(0,0,@tone.to_s)
  end
  def update_tone
    tone = $game_editor.tone
    self.tone.set(tone[:red],tone[:green],tone[:blue],tone[:gray])
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CaractCommand_Ton     Fenêtre secondaire caractéristique          ║
#║    Selecteur de ton de fenêtre                                              ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CaractSec_Ton < Window_Command
  def initialize
    super(0, 8*24)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("Rouge",   :t_r,        true)
    add_command("Bleu",    :t_b,        true)
    add_command("Vert",    :t_v,        true)
    add_command("Gris",    :t_g,        true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CaracSec_OZH     Fenêtre secondaire caractéristique               ║
#║    Selecteur Différent attribut de la fenêtre                               ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CaracSec_OZH < Window_Base
  def initialize(id,value)
    super(272, (id+(id/6).floor*2-1)*24,544-272,72)
    @number = value
    @number = 0 if @number == true
    @number = -1 if @number == false
    @id = id
    draw_item
  end
  def draw_item
    contents.clear
    if @id%5 !=0 
      if @number == -1
        draw_text_ex(0,0,"Base : "+$game_editor.window_opacity.to_s)    if @id == 1
        draw_text_ex(0,0,"Base : "+$game_editor.back_opacity.to_s)      if @id == 2
        draw_text_ex(0,0,"Base : "+$game_editor.contents_opacity.to_s)  if @id == 3
        draw_text_ex(0,0,"Base : "+$game_editor.z.to_s)                 if @id == 4
        draw_text_ex(0,0,(@number).floor.to_s)                          if (@id >= 6)&&(@id<9)
        draw_text_ex(0,0,"Base : "+$data_system.window_tone.gray.to_s)  if @id == 9
      elsif @number == -256
        draw_text_ex(0,0,"Base : "+$data_system.window_tone.red.to_s)   if @id == 6
        draw_text_ex(0,0,"Base : "+$data_system.window_tone.green.to_s) if @id == 7
        draw_text_ex(0,0,"Base : "+$data_system.window_tone.blue.to_s)  if @id == 8
      else
        draw_text_ex(0,0,(@number).floor.to_s)
      end
    else
      draw_text_ex(0,0,"Cacher au démarrage") if (@id == 5)&&(@number == 0)
      draw_text_ex(0,0,"Montrer au démarrage") if (@id == 5)&&(@number == -1)
    end
  end
  def update_2
    if Input.trigger?(:UP)
      @number += 1
      @number = -1 if (@number>255)&&(@id == 1)
      @number = -1 if (@number>255)&&(@id == 2)
      @number = -1 if (@number>255)&&(@id == 3)
      @number = -1 if (@number>0)&&(@id == 5)
      @number = -256 if (@number>255)&&(@id == 6)
      @number = -256 if (@number>255)&&(@id == 7)
      @number = -256 if (@number>255)&&(@id == 8)
      @number = -1 if (@number>255)&&(@id == 9)
    elsif Input.trigger?(:DOWN)
      @number -= 1
      @number = 255 if (@number<-1)&&(@id == 1)
      @number = 255 if (@number<-1)&&(@id == 2)
      @number = 255 if (@number<-1)&&(@id == 3)
      @number = -1 if (@number<-1)&&(@id == 4)
      @number = 0 if (@number<-1)&&(@id == 5)
      @number = 255 if (@number<-256)&&(@id == 6)
      @number = 255 if (@number<-256)&&(@id == 7)
      @number = 255 if (@number<-256)&&(@id == 8)
      @number = 255 if (@number<-1)&&(@id == 9)
    elsif Input.trigger?(:LEFT)
      @number -= 10
      @number = 255 if (@number<-1)&&(@id == 1)
      @number = 255 if (@number<-1)&&(@id == 2)
      @number = 255 if (@number<-1)&&(@id == 3)
      @number = -1 if (@number<-1)&&(@id == 4)
      @number = 0 if (@number<-1)&&(@id == 5)
      @number = 255 if (@number<-256)&&(@id == 6)
      @number = 255 if (@number<-256)&&(@id == 7)
      @number = 255 if (@number<-256)&&(@id == 8)
      @number = 255 if (@number<-1)&&(@id == 9)
    elsif Input.trigger?(:RIGHT)
      @number += 10
      @number = -1 if (@number>255)&&(@id == 1)
      @number = -1 if (@number>255)&&(@id == 2)
      @number = -1 if (@number>255)&&(@id == 3)
      @number = -1 if (@number>0)&&(@id == 5)
      @number = -256 if (@number>255)&&(@id == 6)
      @number = -256 if (@number>255)&&(@id == 7)
      @number = -256 if (@number>255)&&(@id == 8)
      @number = -1 if (@number>255)&&(@id == 9)
    elsif Input.trigger?(:B)
      return true
    elsif Input.trigger?(:C)
      puts "ok"
      case @id
      when 1;
        $game_editor.window_opacity = @number if @number > -1
        return true
      when 2;
        $game_editor.back_opacity = @number if @number > -1
        return true
      when 3;
        $game_editor.contents_opacity = @number if @number > -1
        return true
      when 4;
        $game_editor.z = @number if @number > -1
        return true
      when 5;
        $game_editor.hide = false if @number == -1
        $game_editor.hide = true  if @number == 0
        return true
      when 6;
        if @number != -256
          tone = $game_editor.tone.clone
          tone[:red] = @number
          $game_editor.tone = tone
        else
          tone = $game_editor.tone.clone
          tone[:red] = $data_system.window_tone.red
          $game_editor.tone = tone
        end
        return true
      when 7;
        if @number != -256
          tone = $game_editor.tone.clone
          tone[:green] = @number
          $game_editor.tone = tone
        else
          tone = $game_editor.tone.clone
          tone[:green] = $data_system.window_tone.green
          $game_editor.tone = tone
        end
        return true
      when 8;
        if @number != -256
          tone = $game_editor.tone.clone
          tone[:blue] = @number
          $game_editor.tone = tone
        else
          tone = $game_editor.tone.clone
          tone[:blue] = $data_system.window_tone.blue
          $game_editor.tone = tone
        end
        return true
      when 9;
        if @number != -1
          tone = $game_editor.tone.clone
          tone[:gray] = @number
          $game_editor.tone = tone
        else
          tone = $game_editor.tone.clone
          tone[:gray] = $data_system.window_tone.gray
          $game_editor.tone = tone
        end
        return true
      end
    end
    draw_item
    return false
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CaractCommand     Fenêtre command caractéristique                 ║
#║    Commande pour caractéristique de la fenêtre                              ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CaractCommand < Window_Command
  def initialize
    super(0, 0)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("Opacité génerale",          :o_g,        true)
    add_command("Opacité du fond",           :o_f,        true)
    add_command("Opacité du contenue",       :o_c,        true)
    add_command("Position z",                :w_z,        true)
    add_command("Cacher montrer la fenêtre", :hide,       true)
    add_command("Windowskin associé",        :windowskin, true)
    add_command("Ton de la fenêtre",         :ton,        true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_TypeSec_LHEC     Fenêtre secondaire type                          ║
#║    Selecteur Différent attribut de fenêtre                                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_TypeSec_LHEC < Window_Base
  def initialize(type,id)
    puts id
    type = $game_editor.type
    @type = 1 if type == "normal"
    @type = 2 if type == "selecteur"
    @type = 3 if type == "commande"
    @type = 4 if type == "commande hor"
    super(272, @type*24,544-272,72)
    @number = -1
    @id = id
    draw_item
  end
  def draw_item
    contents.clear
    if @id != 5 
      if @number == -1
        case @type
        when 2;
          draw_text_ex(0,0,"Base : "+$game_editor.w.to_s)        if @id == 1
          draw_text_ex(0,0,"En fonction du \nnbr d'item")        if @id == 2
          draw_text_ex(0,0,"Base : "+$game_editor.espace.to_s)   if @id == 3
          draw_text_ex(0,0,"Base : "+$game_editor.colonne.to_s)  if @id == 4
        when 3;
          draw_text_ex(0,0,"Base : "+$game_editor.w.to_s)        if @id == 1
          draw_text_ex(0,0,"En fonction du \nnbr d'item")        if @id == 2
          draw_text_ex(0,0,"Base : "+$game_editor.nbr_commande.to_s)  if @id == 6
        when 4;
          draw_text_ex(0,0,"Base : "+$game_editor.w.to_s)        if @id == 1
          draw_text_ex(0,0,"En fonction du \nnbr d'item")        if @id == 2
          draw_text_ex(0,0,"Base : "+$game_editor.espace.to_s)   if @id == 3
          draw_text_ex(0,0,"Base : "+$game_editor.colonne.to_s)  if @id == 4
          draw_text_ex(0,0,"Base : "+$game_editor.nbr_commande.to_s)  if @id == 6
        end
      else
        draw_text_ex(0,0,(@number).floor.to_s)
      end
    else
      draw_text_ex(0,0,"Automatique") if (@number == 0)
      draw_text_ex(0,0,"Définie") if (@number == -1)
    end
  end
  def update_2
    if Input.trigger?(:UP)
      @number += 1
      @number = -1 if (@number>520)&&(@id == 1)
      @number = -1 if (@number>392)&&(@id == 2)
      @number = -1 if (@number>544)&&(@id == 3)
      @number = -1 if (@number> 20)&&(@id == 4)
      @number = -1 if (@number > 0)&&(@id == 5)
    elsif Input.trigger?(:DOWN)
      @number -= 1
      @number = 520 if (@number<-1)&&(@id == 1)
      @number = 392 if (@number<-1)&&(@id == 2)
      @number = 544 if (@number<-1)&&(@id == 3)
      @number = 20  if (@number<-1)&&(@id == 4)
      @number = 0   if (@number<-1)&&(@id == 5)
      @number = -1  if (@number<-1)&&(@id == 6)
    elsif Input.trigger?(:LEFT)
      @number -= 10
      @number = 520 if (@number<-1)&&(@id == 1)
      @number = 392 if (@number<-1)&&(@id == 2)
      @number = 544 if (@number<-1)&&(@id == 3)
      @number = 20  if (@number<-1)&&(@id == 4)
      @number = 0   if (@number<-1)&&(@id == 5)
      @number = -1  if (@number<-1)&&(@id == 6)
    elsif Input.trigger?(:RIGHT)
      @number += 10
      @number = -1 if (@number>520)&&(@id == 1)
      @number = -1 if (@number>392)&&(@id == 2)
      @number = -1 if (@number>544)&&(@id == 3)
      @number = -1 if (@number> 20)&&(@id == 4)
      @number = -1 if (@number > 0)&&(@id == 5)
    elsif Input.trigger?(:B)
      return true
    elsif Input.trigger?(:C)
      case @id
      when 1;
        $game_editor.w = @number if @number != -1
      when 2;
        $game_editor.h = @number if @number != -1
        $game_editor.h = nil     if @number == -1
      when 3;
        $game_editor.espace = @number if @number != -1
      when 4;
        $game_editor.colonne = @number if @number != -1
      when 5;
        $game_editor.nbr_commande = @number+1
        $game_editor.commande_name = [""]
      when 6;
        $game_editor.nbr_commande = @number+1
        $game_editor.commande_name = [""]
      end
      return true
    end
    draw_item
    return false
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_TypeSec_Type     Fenêtre secondaire type                          ║
#║    Selecteur de type de fenêtre                                             ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_TypeSec_Type < Window_Command
  def initialize
    super(272, 0)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("Normal",               :normal,             true)
    add_command("Selecteur",            :selecteur,          true)
    add_command("Commande vertical",    :commande_v,         true)
    add_command("Commande horizontal",  :commande_h,         true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_TypeCommand     Commande onglet type                              ║
#║    Commande de modification window en fonction du type selectionné          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_TypeCommand  < Window_Command
  def initialize
    super(0, 0)
  end
  def window_width
    return 272
  end
  def make_command_list
    type = $game_editor.type
    @type = 1 if type == "normal"
    @type = 2 if type == "selecteur"
    @type = 3 if type == "commande"
    @type = 4 if type == "commande hor"
    add_command("Type",          :type,             true)
    add_command("Largeur",       :largeur,          @type>1)
    add_command("Hauteur",       :hauteur,          @type%4>1)
    add_command("Espacement",    :espace,           @type%2==0)
    add_command("Nbr Colonne",   :colonne,          @type%2==0)
    add_command("Element Liste", :liste,            @type==2)
    add_command("Commande Liste",:liste_c,          @type>2)
    add_command("Nom associer au commande",  :name, @type>2)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_Console_Message     Console message popup                         ║
#║    Affichage message go console                                             ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_Console_Message < Window_Base
  def initialize
    super(544/2-150,416/2-36,300,72)
    draw_text_ex(0,0,"Pour continuer aller\ndans la console")
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_Scene_Coordonnée              Coord window factice                ║
#║    Affichage des coordonnée de la factice window                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_Scene_Coordonnée < Window_Base
  def initialize(x,y,w,h)
    super(0,416-24*5,150,24*5)
    refresh(x,y,w,h)
  end
  
  def refresh(x,y,w,h)
    contents.clear
    draw_text_ex(0,0,"x: "+x.to_s+"\ny: "+y.to_s+"\nwidth: "+w.to_s+"\nheight: "+h.to_s)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_Scene_Coordonnée_Factice     Window Factice pour coordonnée       ║
#║    Fenetre pour le placement                                                ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_Scene_Coordonnée_Factice < Window_Base
  def initialize(x,y,width,height,text)
    super(x,y,width,height)
    @texte = text
    draw_text_ex(0,0,@texte) if $game_editor.coordonnée_type == 0
    draw_text_ex(0,0,$game_editor.coord[2]) if $game_editor.coordonnée_type == 1
    draw_icon($game_editor.coord[2],0,0) if $game_editor.coordonnée_type == 2
    draw_face($game_editor.coord[2],$game_editor.coord[3],0,0) if $game_editor.coordonnée_type == 3
    if $game_editor.type == 4
      @image = Sprite.new
      @image.bitmap = Cache.picture($game_editor.coord[2])
      @image.x = 0
    end
  end
  
  def refresh(x =0,y =0)
    contents.clear
    draw_text_ex(x,y,@texte) if $game_editor.coordonnée_type == 1
    draw_icon($game_editor.coord[2],x,y) if $game_editor.coordonnée_type == 2
    draw_face($game_editor.coord[2],$game_editor.coord[3],x,y) if $game_editor.coordonnée_type == 3
    if $game_editor.coordonnée_type == 4
      @image.x = x
      @image.y = y
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_WindowCommand              sous menu window                       ║
#║    Modification ou suppression d'une window existante                       ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_WindowCommand  < Window_Command
  def initialize
    super(50, 50)
  end
  def window_width
    return 200
  end

  def make_command_list
    add_command("Modifier nom",    :modif_name,   true)
    add_command("Modifier type",   :modif_type,   true)
    add_command("Modifier caractéristique",   :modif_caracteristique,   true)
    add_command("Modifier coordonnée",   :modif_coord,   true)
    add_command("Gestionnaire commande",   :modif_commande,   true)
    add_command("Supprimer Window",  :delete,  true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorDescription              Description window                 ║
#║    Fenetre de description generale                                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_EditorDescription  < Window_Base
  
  def initialize
    super(272,94,544-272,416-94)
  end
  
  def print_description(index)
    contents.clear
    if index < $game_editor.take_window_list.length
      $game_editor.window_actuel = $game_editor.take_window_list[index]
      draw_text(0, 0,272-24,24,"Name :")
      draw_text(0, 24,272-24,24,$game_editor.window_actuel.to_s,2)
      i = 2
      draw_text(0, 24*i,272-24,24,"Type :")
      draw_text(0, 24*i,272-24,24,$game_editor.type,2)
      i+= 1
      draw_text(0, 24*i,272-24,24,"Dim :")
      dim = [$game_editor.x,$game_editor.y,$game_editor.w,$game_editor.h]
      draw_text(0, 24*i,272-24,24,dim.to_s,2)
      i+= 1
      draw_text(0, 24*i,272-24,24,"Caché ? :")
      draw_text(0, 24*i,272-24,24,$game_editor.hide,2)
      i+= 1
      draw_text(0, 24*i,272-24,24,"Position z :")
      draw_text(0, 24*i,272-24,24,$game_editor.z,2)
      i+= 1
    else
      draw_text(0, 0,272-24,24,"Creer une nouvelle fenetre")
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Window              List window existant                     ║
#║    Liste des window attaché a la scene selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_Scene_Title < Window_Base
  def initialize
    super(0, 0, Graphics.width, 94)
    refresh
  end
  def refresh
    self.contents.clear
    contents.font.size = 70
    contents.draw_text(0, 0, Graphics.width, 70, $game_editor.scene_actuel.to_s,1)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Window              List window existant                     ║
#║    Liste des window attaché a la scene selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Window  < Window_Selectable
  def initialize
    super(0, 94,272,416-94)
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
    @data = $game_editor.take_window_list
    @data.push("New window")
  end
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
  end
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorTypeDescription              Description window             ║
#║    Fenetre de description des menu de la scene EDITEUR_TYPE                 ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_EditorTypeDescription < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    case id              #                      |
    when 0;
      draw_text_ex(0, 0, "Modifier le type de la\nWindow :\n\nNormal\nSeleteur\nCommande\nCommande Horizontal")
    when 1;
      draw_text_ex(0, 0, "Modifier la largeur de\nla Window")
    when 2;
      draw_text_ex(0, 0, "Modifier la Hauteur de\nla Window") 
    when 3;
      draw_text_ex(0, 0, "Modifier la largeur des\nespace entre les colonne")
    when 4;
      draw_text_ex(0, 0, "Modifier le nombre de\ncolonne")
    when 5;
      draw_text_ex(0, 0, "Modifier la manière dont\nest créer la liste\nd'élèment")
    when 6;
      draw_text_ex(0, 0, "Modifier le nombre de\ncommande")
    when 7;
      draw_text_ex(0, 0, "Modifier les noms des\ncommandes")
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorCaracteristiqueDescription      Description window          ║
#║    Fenetre de description des menu de la scene EDITEUR_CARACTERISTIQUE      ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_EditorCaracteristiqueDescription < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    case id              #                      |
    when 0;
      draw_text_ex(0, 0, "Modifier l'opaciter\ngenerale de la Window")
    when 1;
      draw_text_ex(0, 0, "Modifier l'opaciter\nde la Window")
    when 2;
      draw_text_ex(0, 0, "Modifier l'opaciter\ndu contenu de la\nWindow") 
    when 3;
      draw_text_ex(0, 0, "Modifier la position\nz de la window")
    when 4;
      draw_text_ex(0, 0, "Modifier la visibiliter\na la creation de\nla Window")
    when 5;
      draw_text_ex(0, 0, "Modifier le Window Skin\nassocier a la\nWindow")
    when 6;
      draw_text_ex(0, 0, "Modifier le Ton du\nfond de la Fenetre")
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorDescription              Description window                 ║
#║    Fenetre de description generale                                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_EditorMenuDescription  < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    case id              #                      |
    when 1;
      draw_text_ex(0, 0, "Creer un nouveaux menu\n\n\n\n\n\n\n shift = supprimer\nx ou echap = annuler")
    when 2;
      draw_text_ex(0, 0, "Modifier ou supprimer \nun menu existant") 
    when 3;
      draw_text_ex(0, 0, "Supprime le fichier\nScene_Editor.rvdata2")
    when 4;
      draw_text_ex(0, 0, "Vous étes dans la zone \nde chargement vous \npouvez modifier ou \nsupprimer des scene \ndéjà créer")
    when 5;
      draw_text_ex(0, 0, "Modifier la scene \nselectionné")
    when 6;
      draw_text_ex(0, 0, "Modifier le nom de la\nscene selectionné")
    when 7;
      draw_text_ex(0, 0, "Modifier le fond de la\nscene selectionné")
    when 8;
      draw_text_ex(0, 0, "Supprimer la scene\nselectionné")
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorCommand              Fenetre 1 menu                         ║
#║    Creation/Modification/Suppression de scene                               ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_EditorCommand  < Window_Command
  def initialize
    super(0, 0)
  end
  def window_width
    return 272
  end
  def make_command_list
    add_command("Nouvelle scene",   :new,   true)
    add_command("Gerer les Scene existante",  :load,  main_commands_enabled)
    add_command("Supprimer scene_editor",  :delete,  true)
  end
  def main_commands_enabled
    return !$game_editor.take_scene_list.empty?
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_Name              Fenetre nouvelle scene menu 1                   ║
#║    Création d'une nouvelle scene permet de la nommer                        ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_NameInputEdit < Window_NameInput
  def process_handling
    return unless open? && active
    process_cancel if Input.trigger?(:B)
    process_back if Input.repeat?(:A)
    process_ok   if Input.trigger?(:C)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_NameEdit              Fenetre nouvelle scene menu 1               ║
#║    Création d'une nouvelle scene permet de la nommer                        ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_NameEdit < Window_Base
  attr_reader   :name                     # name
  attr_reader   :index                    # cursor position
  attr_reader   :max_char                 # maximum number of characters
  def initialize(name)
    x = (Graphics.width - 360) / 2
    y = (Graphics.height - (fitting_height(4) + fitting_height(9) + 8)) / 2
    super(x, y, 360, fitting_height(4))
    @max_char = 32
    @default_name = @name = name
    @index = @name.size
    deactivate
    refresh
  end
  def restore_default
    @name = @default_name
    @index = @name.size
    refresh
    return !@name.empty?
  end
  def add(ch)
    return false if @index >= @max_char
    @name += ch
    @index += 1
    refresh
    return true
  end
  def back
    return false if @index == 0
    @index -= 1
    @name = @name[0, @index]
    refresh
    return true
  end
  def face_width
    return 0
  end
  def char_width
    text_size($game_system.japanese? ? "あ" : "A").width 
  end
  def left
    name_center = (contents_width + face_width) / 2
    name_width = (@max_char + 1) * char_width
    return [name_center - name_width / 2, contents_width - name_width].min
  end
  def item_rect(index)
    Rect.new(left + index * char_width, 36, char_width, line_height)
  end
  def underline_rect(index)
    rect = item_rect(index)
    rect.x += 1
    rect.y += rect.height - 4
    rect.width -= 2
    rect.height = 2
    rect
  end
  def underline_color
    color = normal_color
    color.alpha = 48
    color
  end
  def draw_underline(index)
    contents.fill_rect(underline_rect(index), underline_color)
  end
  def draw_char(index)
    rect = item_rect(index)
    rect.x -= 1
    rect.width += 4
    change_color(normal_color)
    draw_text(rect, @name[index] || "")
  end
  def refresh
    contents.clear
    @max_char.times {|i| draw_underline(i) }
    @name.size.times {|i| draw_char(i) }
    cursor_rect.set(item_rect(@index))
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_Load_EditorCommand            List scene existant                 ║
#║    Chargement ou suppression d'une scene existante                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_Load_EditorCommand  < Window_Selectable
  def initialize
    super(0, 0,272,416)
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
    @data = $game_editor.take_scene_list
  end
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
  end
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_LoadCommand              sous menu chargement                     ║
#║    Chargement ou suppression d'une scene existante                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_LoadCommand  < Window_Command
  def initialize
    super(50, 50)
  end
  def window_width
    return 200
  end

  def make_command_list
    add_command("Modifier Scene Window" , :modif_window     , true)
    add_command("Modifier Scene Prog"   , :modif_prog       , true)
    add_command("Modifier Nom Scene"    , :modif_name       , true)
    add_command("Fond de Scene"         , :modif_background , true)
    add_command("Supprimer Scene"       , :delete           , true)
  end
end
