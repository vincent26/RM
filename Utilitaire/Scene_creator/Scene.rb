#╔═════════════════════════════════════════════════════════════════════════════╗
#║                         /¯¯¯ /¯¯ |¯¯ |\   | |¯¯                             ║
#║                         \__  |   |   | \  | |                               ║
#║                            \ |   |¯  |  \ | |¯                              ║
#║                         ___/ \__ |__ |   \| |__                             ║
#╚═════════════════════════════════════════════════════════════════════════════╝
=begin
Scene presente :

-Scene_Editor_Start               (ligne   21) #| Creation/gestion Scene
  -Scene_Editor_Window            (ligne  279) #| Modification Window
    -Scene_Editor_Type            (ligne  483) #| Modification Type Window
    -Scene_Editor_Coordonnée      (ligne  758) #| Modification Coordonée Window
    -Scene_Editor_Caractéristique (ligne  911) #| Modification Caracteristique Window
    -Scene_Editor_Fonction        (ligne 1128) #| Modification Fonction Window
      -Scene_Editor_W_Prog        (ligne  973) #| Modification Progamation des Fonction Window
  -Scene_Editor_Programation      (ligne  973) #| Modification Programation des Scene

  
  
=end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Start              Menu Start                               ║
#║    Creation/Modification/Suppression de scene                               ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Start < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_background
    create_window
    create_command_window
    create_description_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    DataManager.save_editor_file
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  def create_window
    @command_window = Window_EditorCommand.new
    @name_edit_window = Window_NameEdit.new("")
    @name_input_window = Window_NameInputEdit.new(@name_edit_window)
    @load_window = Window_Load_EditorCommand.new
    @load_window_command = Window_LoadCommand.new
    @window_console = Window_Console_Message.new
    @load_window_command.hide
    @load_window.hide
    @name_input_window.hide
    @name_edit_window.hide
    @command_window.hide
    @window_console.hide
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_EditorCommand.new
    @command_window.set_handler(:new,      method(:new_scene))
    @command_window.set_handler(:load,     method(:load_scene))
    @command_window.set_handler(:delete,     method(:delete_scene_editor_file))
    @command_window.set_handler(:cancel,     method(:return_scene))
    @fenetre_actuel = 0
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Create Description Window
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_EditorMenuDescription.new
  end
  ##############################################################################
  #--------------------------------------------------------------------------
  # * Delete Scene_Editor
  #--------------------------------------------------------------------------
  def delete_scene_editor_file
    File.delete("Data/Scene_Editor.rvdata2") if FileTest.exist?("Data/Scene_Editor.rvdata2")
    msgbox("Scene_Editor.rvdata2 a etait supprimer")
    $game_editor.reset
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Scene
  #--------------------------------------------------------------------------
  def new_scene
    @name_edit_window = Window_NameEdit.new("")
    @name_input_window = Window_NameInputEdit.new(@name_edit_window)
    @name_input_window.set_handler(:ok, method(:on_input_ok))
    @name_input_window.set_handler(:cancel,     method(:on_input_cancel))
  end
      #--------------------------------------------------------------------------
      # * Input [OK]
      #--------------------------------------------------------------------------
      def on_input_ok
        if $game_editor.scene_new(@name_edit_window.name)
          $game_editor.scene_actuel = @name_edit_window.name.to_sym
          SceneManager.call(Scene_Editor_Window)
          @name_edit_window.close
          @name_input_window.close
          @command_window.refresh
          @command_window.activate
        else
          @name_input_window.activate
        end
      end
      #--------------------------------------------------------------------------
      # * Cancel [OK]
      #--------------------------------------------------------------------------
      def on_input_cancel
        @name_edit_window.close
        @name_input_window.close
        @command_window.refresh
        @command_window.activate
      end
  #--------------------------------------------------------------------------
  # * Load Scene
  #--------------------------------------------------------------------------
  def load_scene
    @load_window = Window_Load_EditorCommand.new
    @load_window.set_handler(:ok,      method(:load_input_ok))
    @load_window.set_handler(:cancel,     method(:load_input_cancel))
    @command_window.hide
    @load_window.refresh
    @fenetre_actuel = 1
    @load_window.activate
    @load_window.select(0)
  end
      #--------------------------------------------------------------------------
      # * Input [OK]
      #--------------------------------------------------------------------------
      def load_input_ok
        @load_window_command = Window_LoadCommand.new
        @load_window_command.set_handler(:cancel          , method(:load_command_input_cancel))
        @load_window_command.set_handler(:modif_name      , method(:load_command_input_modif_name))
        @load_window_command.set_handler(:modif_background, method(:load_command_input_modif_background))
        @load_window_command.set_handler(:modif_window    , method(:load_command_input_modif_window))
        @load_window_command.set_handler(:modif_prog      , method(:load_command_input_modif_prog))
        @load_window_command.set_handler(:delete          , method(:load_command_input_delete))
        @fenetre_actuel = 2
        @load_window_command.activate
        puts @load_window.index
        name = $game_editor.take_scene_list[@load_window.index]
        $game_editor.scene_actuel = name
        puts name
      end
          #--------------------------------------------------------------------------
          # * load_command_input_modif_background [MODIF]
          #--------------------------------------------------------------------------
          def load_command_input_modif_background
            system("cls")
            puts "## Background"
            puts ""
            puts "Entrer le nom d'une image de fond, elle doit ce trouver dans le dossier Pictures"
            puts "Pour mettre une capture d'écran de la map au lieu d'une image entrer 0"
            puts ""
            @window_console.visible = true
            @window_console.opacity = 0
            @window_console.z = 200
            while @window_console.opacity < 250
              @window_console.opacity += 10
              update
            end
            loop do
              @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
              @background = Cache.picture(@texte) rescue false
              if (@background == false)&&(@texte != "0")&&(@texte != "@exit")
                msgbox("Le fichier demandé n'existe pas vérifier son nom et si il ce trouve bien dans le dossier pictures du jeu")
              elsif @texte == "@exit"
                break
              else
                if @texte == "0"
                  @background = @texte.to_i
                end
                $game_editor.modif_background_scene(@background)
                break
              end
            end
            puts "Ok vous pouvez retourner a l'éditeur"
            @window_console.hide
            @load_window_command.activate
          end
          #--------------------------------------------------------------------------
          # * load_command_input_modif_name [MODIF]
          #--------------------------------------------------------------------------
          def load_command_input_modif_name
            @name_edit_window = Window_NameEdit.new("")
            @name_input_window = Window_NameInputEdit.new(@name_edit_window)
            @name_input_window.set_handler(:ok, method(:on_input_ok_load_name_modif))
            @name_input_window.set_handler(:cancel,     method(:on_input_cancel_load_name_modif))
          end
              #--------------------------------------------------------------------------
              # * Input [OK]
              #--------------------------------------------------------------------------
              def on_input_ok_load_name_modif
                if $game_editor.take_scene_list.include?(@name_edit_window.name.to_sym)
                  scene = $game_editor.take_scene
                  $game_editor.scene_delete($game_editor.scene_actuel)
                  $game_editor.scene_define(@name_edit_window.name,scene)
                  $game_editor.scene_actuel = @name_edit_window.name.to_sym
                  on_input_cancel_load_name_modif
                else
                  $game_editor.scene_new(@name_edit_window.name)
                  @name_input_window.activate
                end
              end
              #--------------------------------------------------------------------------
              # * Cancel [OK]
              #--------------------------------------------------------------------------
              def on_input_cancel_load_name_modif
                @load_window_command.refresh
                @load_window_command.activate
                @name_edit_window.close
                @name_input_window.close
                @load_window.refresh
                update
              end
          #--------------------------------------------------------------------------
          # * Load modif [MODIF]
          #--------------------------------------------------------------------------
          def load_command_input_modif_window
            SceneManager.call(Scene_Editor_Window)
          end
          #--------------------------------------------------------------------------
          # * Load modif prog [MODIF]
          #--------------------------------------------------------------------------
          def load_command_input_modif_prog
            
          end
          #--------------------------------------------------------------------------
          # * Load delete [DELETE]
          #--------------------------------------------------------------------------
          def load_command_input_delete
            $game_editor.delete(@load_window_command.index-1)
            DataManager.save_editor_file
            @load_window_command.close
            @load_window.refresh
            @load_window.activate
            load_input_cancel if $game_editor.name.empty?
          end
          #--------------------------------------------------------------------------
          # * Cancel2 [OK]
          #--------------------------------------------------------------------------
          def load_command_input_cancel
            @load_window_command.close
            @fenetre_actuel = 1
            @load_window.activate
          end
      #--------------------------------------------------------------------------
      # * Cancel [OK]
      #--------------------------------------------------------------------------
      def load_input_cancel
        @load_window.close
        @command_window.show
        @command_window.refresh
        @fenetre_actuel = 0
        @command_window.activate
      end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------    
  def update
    super
    @description_window.print_description(@command_window.index+1) if @fenetre_actuel == 0
    @description_window.print_description(4) if @fenetre_actuel == 1
    @description_window.print_description(@load_window_command.index+5) if @fenetre_actuel == 2
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Window          Menu Scene modification                     ║
#║    Creation/Modification/Suppression de Window                              ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Window < Scene_Base
  def start
    super
    create_background
    create_title_window
    create_secondary_window
    create_list_window
    create_description_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Title Window
  #--------------------------------------------------------------------------
  def create_title_window
    @title_window = Window_Scene_Title.new
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_list_window
    @list_window = Window_List_Window.new
    @list_window.set_handler(:ok,      method(:list_window_ok))
    @list_window.set_handler(:cancel,     method(:return_scene))
    @list_window.refresh
    @list_window.select(0)
    @list_window.activate
  end
  #--------------------------------------------------------------------------
  # * Create Description Window
  #--------------------------------------------------------------------------
  def create_description_window
    @description_window = Window_EditorDescription.new
  end
  
  def create_secondary_window
    @edit_window_command = Window_WindowCommand.new
    @edit_window_command.set_handler(:cancel,     method(:window_command_input_cancel))
    @edit_window_command.set_handler(:modif_name,   method(:window_command_input_modif_name))
    @edit_window_command.set_handler(:modif_type,     method(:window_command_input_modif_type))
    @edit_window_command.set_handler(:modif_caracteristique,     method(:window_command_input_modif_caracteristique))
    @edit_window_command.set_handler(:modif_coord,     method(:window_command_input_modif_coord))
    @edit_window_command.set_handler(:modif_commande,     method(:window_command_input_modif_commande))
    @edit_window_command.set_handler(:delete,     method(:window_command_input_delete))
    @edit_window_command.hide
    @edit_window_command.active = false
    @edit_window_command.z = 200
  end
    ##############################################################################
    #--------------------------------------------------------------------------
    # * Input [OK]
    #--------------------------------------------------------------------------
    def list_window_ok
      if @list_window.index == $game_editor.take_window_list.length
        @name_edit_window = Window_NameEdit.new("")
        @name_input_window = Window_NameInputEdit.new(@name_edit_window)
        @name_input_window.set_handler(:ok, method(:name_input_ok))
        @name_input_window.set_handler(:cancel, method(:name_input_cancel))
      else
        create_secondary_window
        name = $game_editor.take_window_list[@list_window.index]
        $game_editor.window_actuel = name
        @edit_window_command.show
        @edit_window_command.activate
      end
    end
        #--------------------------------------------------------------------------
        # * Input [OK]
        #--------------------------------------------------------------------------
        def name_input_ok
          if $game_editor.new_window(@name_edit_window.name)
            @name_edit_window.dispose
            @name_input_window.dispose
            @name_edit_window = nil
            @name_input_window = nil
            @list_window.refresh
            @list_window.activate
          else
            @name_input_window.activate
          end
        end
        #--------------------------------------------------------------------------
        # * Cancel [OK]
        #--------------------------------------------------------------------------
        def name_input_cancel
          @name_edit_window.dispose
          @name_input_window.dispose
          @name_edit_window = nil
          @name_input_window = nil
          @list_window.refresh
          @list_window.activate
        end
      #--------------------------------------------------------------------------
      # * window_command_input_modif_name [MODIF]
      #--------------------------------------------------------------------------
      def window_command_input_modif_name
        @edit_window_command.hide
        @edit_window_command.deactivate
        @name_edit_window = Window_NameEdit.new("")
        @name_input_window = Window_NameInputEdit.new(@name_edit_window)
        @name_input_window.set_handler(:ok, method(:name_input_ok_modif))
        @name_input_window.set_handler(:cancel, method(:name_input_cancel_modif))
      end
        #--------------------------------------------------------------------------
        # * Input [OK]
        #--------------------------------------------------------------------------
        def name_input_ok_modif
          if !$game_editor.take_window_list.include?(@name_edit_window.name)
            window = $game_editor.take_window
            $game_editor.delete_window($game_editor.window_actuel)
            $game_editor.window_define(@name_edit_window.name,window)
            $game_editor.window_actuel = @name_edit_window.name.to_sym
            name_input_cancel
          else
            msgbox("Cette Window existe déjà.")
            @name_input_window.activate
          end
        end
        #--------------------------------------------------------------------------
        # * Cancel [OK]
        #--------------------------------------------------------------------------
        def name_input_cancel_modif
          @name_edit_window.dispose
          @name_input_window.dispose
          @name_edit_window = nil
          @name_input_window = nil
          @list_window.refresh
          @list_window.activate
        end
      #--------------------------------------------------------------------------
      # * window_command_input_modif_type [MODIF]
      #--------------------------------------------------------------------------
      def window_command_input_modif_type
        SceneManager.call(Scene_Editor_Type)
        @edit_window_command.activate
      end
      #--------------------------------------------------------------------------
      # * window_command_input_modif_type [MODIF]
      #--------------------------------------------------------------------------
      def window_command_input_modif_caracteristique
        SceneManager.call(Scene_Editor_Caractéristique)
        @edit_window_command.activate
      end
      #--------------------------------------------------------------------------
      # * window_command_input_modif_coord [MODIF]
      #--------------------------------------------------------------------------
      def window_command_input_modif_coord
        $game_editor.coordonnée_type = 0
        SceneManager.call(Scene_Editor_Coordonnée)
        @edit_window_command.activate
      end
      #--------------------------------------------------------------------------
      # * window_command_input_modif_commande [MODIF]
      #--------------------------------------------------------------------------
      def window_command_input_modif_commande
        SceneManager.call(Scene_Editor_Fonction)
        @edit_window_command.activate
      end
      #--------------------------------------------------------------------------
      # * window_command_input_delete [DELETE]
      #--------------------------------------------------------------------------
      def window_command_input_delete
        $game_editor.delete_window($game_editor.window_actuel.to_s)
        @edit_window_command.close
        @list_window.refresh
        @list_window.activate
      end
      #--------------------------------------------------------------------------
      # * window_command_input_cancel [OK]
      #--------------------------------------------------------------------------
      def window_command_input_cancel
        @edit_window_command.close
        @list_window.refresh
        @list_window.activate
      end
  
  def update
    super
    @description_window.print_description(@list_window.index)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Type              Modif coord window                        ║
#║    Modification des coordonnée d'une fenêtre                                ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Type < Scene_Base
  def start
    super
    create_background
    create_commande_window
    create_secondary_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_commande_window
    @commande_window = Window_TypeCommand.new
    @commande_window.set_handler(:type,     method(:modif_type))
    @commande_window.set_handler(:largeur,     method(:modif_largeur))
    @commande_window.set_handler(:hauteur,     method(:modif_hauteur))
    @commande_window.set_handler(:espace,     method(:modif_espace))
    @commande_window.set_handler(:colonne,     method(:modif_colonne))
    @commande_window.set_handler(:liste,     method(:modif_liste))
    @commande_window.set_handler(:liste_c,     method(:modif_liste_c))
    @commande_window.set_handler(:name,     method(:modif_name))
    @commande_window.set_handler(:cancel,     method(:return_scene)) 
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * Create Secondary Window
  #--------------------------------------------------------------------------
  def create_secondary_window
    @description_window = Window_EditorTypeDescription.new
    @type_window = Window_TypeSec_Type.new
    @type_window.set_handler(:normal,     method(:set_normal))
    @type_window.set_handler(:selecteur,     method(:set_selecteur))
    @type_window.set_handler(:commande_v,     method(:set_commande_v))
    @type_window.set_handler(:commande_h,     method(:set_commande_h))
    @type_window.set_handler(:cancel,     method(:set_cancel))
    @type_window.hide
    @type_window.active = false
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Type
  #--------------------------------------------------------------------------
  def modif_type
    @type_window.show
    @type_window.activate
  end
    def set_normal
      $game_editor.type = "normal"
      $game_editor.w    = 160
      $game_editor.h    = 100
      if $game_editor.take_fonction_list.include?("creation_list")
        $game_editor.supprimer_fonction($game_editor.take_fonction_list.index("creation_list"))
      end
      @type_window.hide
      @commande_window.activate
      @commande_window.refresh
    end
    def set_selecteur
      $game_editor.type = "selecteur"
      $game_editor.w    = 160*2+19-24
      $game_editor.h    = 100
      if !$game_editor.take_fonction_list.include?("creation_list")
        $game_editor.fonction_new("creation_list","Creation de la liste d'element ou commande")
      end
      @type_window.hide
      @commande_window.activate
      @commande_window.refresh
    end
    def set_commande_v
      $game_editor.type = "commande"
      $game_editor.w    = 160
      $game_editor.h    = $game_editor.nbr_commande*24+24
      if !$game_editor.take_fonction_list.include?("creation_list")
        $game_editor.fonction_new("creation_list","Creation de la liste d'element ou commande")
      end
      @type_window.hide
      @commande_window.activate
      @commande_window.refresh
    end
    def set_commande_h
      $game_editor.type = "commande hor"
      $game_editor.w    = [((160-24)*$game_editor.nbr_commande),544].min
      $game_editor.h    = 48
      if !$game_editor.take_fonction_list.include?("creation_list")
        $game_editor.fonction_new("creation_list","Creation de la liste d'element ou commande")
      end
      @type_window.hide
      @commande_window.activate
      @commande_window.refresh
    end
    def set_cancel
      @type_window.hide
      @commande_window.activate
    end
  #--------------------------------------------------------------------------
  # * [MODIF] Largeur
  #--------------------------------------------------------------------------
  def modif_largeur
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,1)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Hauteur
  #--------------------------------------------------------------------------
  def modif_hauteur
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,2)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Espace entre les colonne
  #--------------------------------------------------------------------------
  def modif_espace
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,3)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Nbr de colonne
  #--------------------------------------------------------------------------
  def modif_colonne
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,4)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Type
  #--------------------------------------------------------------------------
  def modif_liste
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,5)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Type
  #--------------------------------------------------------------------------
  def modif_liste_c
    @window_secondaire = Window_TypeSec_LHEC.new($game_editor.type,6)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Type
  #--------------------------------------------------------------------------
  def modif_name
    system("cls")
    puts "### Commande"
    puts ""
    puts "Entrer les nom des commandes, il en faut " + $game_editor.nbr_commande.to_s 
    puts "Pour passer une commande mettre 0"
    puts ""
    puts $game_editor.commande_name.to_s
    @window_console = Window_Console_Message.new
    @window_console.opacity = 0
    @window_console.z = 200
    while @window_console.opacity < 250
      @window_console.opacity += 10
      update
    end
    ok = false
    i=0
    while ok == false
      puts ""
      puts $game_editor.commande_name.to_s
      puts "Encore "+($game_editor.nbr_commande-i).to_s
      @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
      if @texte != "0" && @texte != "@exit"
        array = $game_editor.commande_name.clone
        array[i] = @texte
        $game_editor.commande_name = array
      elsif @texte == "0"
        puts "SKIP"
        if $game_editor.commande_name[i] == nil
          array = $game_editor.commande_name.clone
          array[i] = ""
          $game_editor.commande_name = array
        end
      elsif @texte == "@exit"
        ok = true
        puts "EXIT OK"
      end
      i += 1
      ok = true if i == $game_editor.nbr_commande
    end
    puts ""
    puts "Entrer maintenant une commande pour le cas de l'annulation"
    puts "Pour faire une retour de scene mettre return_scene"
    puts "pour faire une simple annulation mettre cancel"
    puts ""
    loop do
      @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
      if (@texte == "cancel" || @texte == "return_scene" || $game_editor.commande_name.include?(@texte)) && @texte != "@exit"
        array = $game_editor.commande_name.clone
        array[i] = @texte
        $game_editor.commande_name = array
        break
      elsif @texte == "@exit"
        puts "EXIT OK"
        if $game_editor.commande_name[i] == nil
          array = $game_editor.commande_name.clone
          array[i] = "cancel"
          $game_editor.commande_name = array
        end
        break
      else
        puts ""
        puts "cette commande n'existe pas"
        puts ""
      end
    end
    puts ""
    puts "Fin de creation :"
    puts $game_editor.commande_name.to_s
    puts ""
    puts "Ok vous pouvez retourner a l'éditeur"
    @window_console.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Type
  #--------------------------------------------------------------------------
  def update
    super
    @description_window.print_description(@commande_window.index)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Coordonnée              Modif coord window                  ║
#║    Modification des coordonnée d'une fenêtre                                ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Coordonnée < Scene_Base
  def start
    super
    create_background
    create_window_test
    create_window_coord
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create create_window_test
  #--------------------------------------------------------------------------
  def create_window_test
    type = $game_editor.coordonnée_type
    @x,@y,@w,@h = $game_editor.x,$game_editor.y,$game_editor.w,$game_editor.h
    puts $game_editor.window_actuel
    @window = Window_Scene_Coordonnée_Factice.new(@x,@y,@w,@h,$game_editor.window_actuel.to_s)
    @window_sec = []
    for i in $game_editor.take_window_list
      next if i.to_sym == $game_editor.window_actuel
      wind = $game_editor.get_window[i.to_sym]
      x,y,w,h = wind[:x],wind[:y],wind[:w],wind[:h]
      @window_sec.push(Window_Scene_Coordonnée_Factice.new(x,y,w,h,i.to_s))
    end
  end
  #--------------------------------------------------------------------------
  # * Create create_window_coord
  #--------------------------------------------------------------------------
  def create_window_coord
    if $game_editor.coordonnée_type == 0
      @window_coordonnée = Window_Scene_Coordonnée.new(@x,@y,@w,@h)
      @window_coordonnée.opacity = 0
    else
      @coord = $game_editor.coord.clone
      @window_coordonnée = Window_Scene_Coordonnée.new(@coord[0],@coord[1],0,0)
      @window_coordonnée.opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    @timer = 0 if @timer == nil
    @taille_modif_width = false if @taille_modif_width == nil
    @taille_modif_height = false if @taille_modif_height == nil
    if Input.press?(:RIGHT) == true
      if $game_editor.coordonnée_type == 0
        if @taille_modif_width == true
          @window.width = @window.width + 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        else
          @window.x = @window.x + 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        end
      else
        @coord[0] += 1 if (@timer == 0)||(@timer > 30)
        @timer = 1 + @timer if @timer <= 31
      end
    elsif Input.press?(:LEFT) == true
      if $game_editor.coordonnée_type == 0
        if @taille_modif_width == true
          @window.width = @window.width - 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        else
          @window.x = @window.x - 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        end
      else
        @coord[0] -= 1 if (@timer == 0)||(@timer > 30)
        @timer = 1 + @timer if @timer <= 31
      end
    elsif Input.press?(:UP) == true
      if $game_editor.coordonnée_type == 0
        if @taille_modif_height == true
          @window.height = @window.height - 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        else
          @window.y = @window.y - 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        end
      else
        @coord[1] -= 1 if (@timer == 0)||(@timer > 30)
        @timer = 1 + @timer if @timer <= 31
      end
    elsif Input.press?(:DOWN) == true
      if $game_editor.coordonnée_type == 0
        if @taille_modif_height == true
          @window.height = @window.height + 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        else
          @window.y = @window.y + 1 if (@timer == 0)||(@timer > 30)
          @timer = 1 + @timer if @timer <= 31
        end
      else
        @coord[1] += 1 if (@timer == 0)||(@timer > 30)
        @timer = 1 + @timer if @timer <= 31
      end
    else
      @timer = 0
    end
    if Input.press?(:A) == true
      @taille_modif_width = true
      @taille_modif_height = true
    elsif Input.press?(:A) == false
      @taille_modif_width = false
      @taille_modif_height = false
    end
    ok_process_coord if Input.trigger?(:C) == true 
    return_scene if Input.trigger?(:B) == true
    @window_coordonnée.refresh(@window.x,@window.y,@window.width,@window.height) if $game_editor.coordonnée_type == 0
    @window_coordonnée.refresh(@coord[0],@coord[1],0,0) if $game_editor.coordonnée_type > 0 
    @window.refresh(@coord[0],@coord[1]) if ($game_editor.coordonnée_type >= 1)
  end
  #--------------------------------------------------------------------------
  # * Ok Process
  #--------------------------------------------------------------------------
  def ok_process_coord
    if $game_editor.coordonnée_type == 0
      $game_editor.x = @window.x
      $game_editor.y = @window.y
      $game_editor.w = @window.width
      $game_editor.h = @window.height
      return_scene
    elsif $game_editor.coordonnée_type == 1
      $game_editor.ajout_commande(1,[@coord[2],@coord[0],@coord[1]])
      return_scene
    elsif $game_editor.coordonnée_type == 2
      $game_editor.ajout_commande(2,[@coord[2].to_i,@coord[0],@coord[1]])
      return_scene
    elsif $game_editor.coordonnée_type == 3
      $game_editor.ajout_commande(3,[@coord[2],@coord[3].to_i,@coord[0],@coord[1]])
      return_scene
    elsif $game_editor.coordonnée_type == 4
      $game_editor.ajout_commande(4,[@coord[2],@coord[0],@coord[1]])
      return_scene
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Caractéristique           Modif caractéristique window      ║
#║    Modification des caractéristique d'une fenêtre                           ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Caractéristique < Scene_Base
  def start
    super
    create_background
    create_commande_window
    create_secondary_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_commande_window
    @commande_window = Window_CaractCommand.new
    @commande_window.set_handler(:o_g,        method(:modif_o_g))
    @commande_window.set_handler(:o_f,        method(:modif_o_f))
    @commande_window.set_handler(:o_c,        method(:modif_o_c))
    @commande_window.set_handler(:w_z,        method(:modif_w_z))
    @commande_window.set_handler(:hide,       method(:modif_hide))
    @commande_window.set_handler(:windowskin, method(:modif_windowskin))
    @commande_window.set_handler(:ton,        method(:modif_ton))
    @commande_window.set_handler(:cancel,        method(:return_scene))
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * Create Secondary Window
  #--------------------------------------------------------------------------
  def create_secondary_window
    @description_window = Window_EditorCaracteristiqueDescription.new
    @window_ton = Window_CaractSec_Ton.new
    @window_ton_test = Window_CaractSec_Ton_Test.new
    @window_ton.opacity = 0
    @window_ton.contents_opacity = 0
    @window_ton.close
    @window_ton_test.opacity = 0
    @window_ton_test.contents_opacity = 0
    @window_ton_test.close
    @commande_window.activate
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Caractéristique
  #--------------------------------------------------------------------------
  def modif_o_g
    @window_secondaire = Window_CaracSec_OZH.new(1,$game_editor.window_opacity)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  def modif_o_f
    @window_secondaire = Window_CaracSec_OZH.new(2,$game_editor.back_opacity)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  def modif_o_c
    @window_secondaire = Window_CaracSec_OZH.new(3,$game_editor.contents_opacity)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  def modif_w_z
    @window_secondaire = Window_CaracSec_OZH.new(4,$game_editor.z)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  def modif_hide
    @window_secondaire = Window_CaracSec_OZH.new(5,$game_editor.hide)
    loop do
      break if @window_secondaire.update_2
      update
    end
    @window_secondaire.close
    @commande_window.activate
  end
  def modif_windowskin
    system("cls")
    puts "### Window Skin"
    puts ""
    puts "Entrer le nom de la Window Skin souhaiter pour cette fenêtre"
    puts "Actuellement elle utilise :"
    puts $game_editor.windowskin.to_s if $game_editor.windowskin != nil
    puts "Window Skin Standards" if $game_editor.windowskin == nil
    puts ""
    puts "Pour mettre le window skin standard mettre 0"
    puts ""
    @window_console = Window_Console_Message.new
    @window_console.opacity = 0
    @window_console.z = 200
    while @window_console.opacity < 250
      @window_console.opacity += 10
      update
    end
    loop do
      @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
      @background = Cache.system(@texte) rescue @background = false;
      if (@background == false)&&(@texte != "")&&(@texte != "@exit")&&(@texte != "0")
        msgbox("Le fichier demandé n'existe pas vérifier son nom et si il ce trouve bien dans le dossier System du jeu")
      elsif (@texte == "@exit")
        puts "EXIT OK"
        break
      elsif (@texte == "0")
        $game_editor.windowskin = nil
        break
      else
        $game_editor.windowskin = @texte
        break
      end
    end
    puts ""
    puts "Window Skin selectionner :"
    puts $game_editor.windowskin.to_s if $game_editor.windowskin != nil
    puts "Window Skin Standards" if $game_editor.windowskin == nil
    puts ""
    puts "Ok vous pouvez retourner a l'éditeur"
    @window_console.close
    @commande_window.activate
  end
  def modif_ton
    @window_ton = Window_CaractSec_Ton.new
    @window_ton_test = Window_CaractSec_Ton_Test.new
    @window_ton_test.update
    @window_ton.set_handler(:t_r,        method(:modif_t_r))
    @window_ton.set_handler(:t_b,        method(:modif_t_b))
    @window_ton.set_handler(:t_v,        method(:modif_t_v))
    @window_ton.set_handler(:t_g,        method(:modif_t_g))
    @window_ton.set_handler(:cancel,     method(:modif_t_cancel))
  end
  #--------------------------------------------------------------------------
  # * [MODIF] Caractéristique Ton
  #--------------------------------------------------------------------------
      def modif_t_r
        @window_secondaire = Window_CaracSec_OZH.new(6,$game_editor.tone[:red])
        loop do
          break if @window_secondaire.update_2
          update
        end
        @window_secondaire.close
        @window_ton_test.update
        @window_ton.activate
      end
      def modif_t_b
        @window_secondaire = Window_CaracSec_OZH.new(7,$game_editor.tone[:green])
        loop do
          break if @window_secondaire.update_2
          update
        end
        @window_secondaire.close
        @window_ton_test.update
        @window_ton.activate
      end
      def modif_t_v
        @window_secondaire = Window_CaracSec_OZH.new(8,$game_editor.tone[:blue])
        loop do
          break if @window_secondaire.update_2
          update
        end
        @window_secondaire.close
        @window_ton_test.update
        @window_ton.activate
      end
      def modif_t_g
        @window_secondaire = Window_CaracSec_OZH.new(9,$game_editor.tone[:gray])
        loop do
          break if @window_secondaire.update_2
          update
        end
        @window_secondaire.close
        @window_ton_test.update
        @window_ton.activate
      end
      def modif_t_cancel
        @window_ton.close
        @window_ton_test.close
        @commande_window.activate
      end
  def update
    super
    @description_window.print_description(@commande_window.index)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Fonction           Modif fonction window                    ║
#║    Modification des fonction lier a une fenêtre                             ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_Fonction < Scene_Base
  def start
    super
    create_background
    create_commande_window
    create_secondary_window
    @commande_list_window.activate
  end
  #--------------------------------------------------------------------------
  # * Termination Processing 
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_commande_window
    @commande_list_window = Window_List_Fonction.new
    @commande_list_window.set_handler(:ok,      method(:list_commande_ok))
    @commande_list_window.set_handler(:cancel,     method(:return_scene))
    @commande_list_window.refresh
    @commande_list_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Create Secondary Window
  #--------------------------------------------------------------------------
  def create_secondary_window
    $game_editor.fonction_actuel = @commande_list_window.index
    @description_window = Window_FonctionWindowDescription.new
    @window_command_modif = Window_FonctionModifSelect.new
    @window_command_modif.set_handler(:Modif_Nom,         method(:modifier_nom))
    @window_command_modif.set_handler(:Modif_Desc,        method(:modifier_description))
    @window_command_modif.set_handler(:Modif,             method(:modifier_commande))
    @window_command_modif.set_handler(:Suppr,             method(:supprimer_commande))
    @window_command_modif.set_handler(:cancel,            method(:Modreturn))
    @window_command_modif.hide
    @window_command_modif.select(0)
    @window_command_modif.deactivate
    @window_console = Window_Console_Message.new
    @window_console.hide
  end
  
  def list_commande_ok
    create_secondary_window
    @commande_list_window.deactivate
    if @commande_list_window.index == $game_editor.commande.length
      @window_command_modif.deactivate
      @name_edit_window = Window_NameEdit.new("")
      @name_input_window = Window_NameInputEdit.new(@name_edit_window)
      @name_input_window.set_handler(:ok, method(:on_input_ok))
      @name_input_window.set_handler(:cancel,     method(:on_input_cancel))
    else
      @window_command_modif.show
      @commande_list_window.deactivate
      @window_command_modif.activate
    end
  end
      #--------------------------------------------------------------------------
      # * Input [OK]
      #--------------------------------------------------------------------------
      def on_input_ok
        if $game_editor.fonction_new(@name_edit_window.name,"")
          define_description_new_fonction
          @name_edit_window.close
          @name_input_window.close
          @commande_list_window.refresh
          @commande_list_window.activate
        else
          @name_input_window.activate
        end
      end
      #--------------------------------------------------------------------------
      # * Cancel [OK]
      #--------------------------------------------------------------------------
      def on_input_cancel
        @name_edit_window.close
        @name_input_window.close
        @commande_list_window.refresh
        @window_command_modif.activate
      end
  
  def define_description_new_fonction
    system("cls")
    puts "## Description"
    puts ""
    puts "Entrer une petite description de la fonction"
    puts ""
    puts $game_editor.fonction_description
    puts ""
    @window_console.visible = true
    @window_console.opacity = 0
    @window_console.z = 200
    while @window_console.opacity < 250
      @window_console.opacity += 10
      update
    end
    loop do
      @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
      if @texte == "@exit"
        break
      else
        $game_editor.fonction_description = @texte
        break
      end
    end
    puts ""
    puts $game_editor.fonction_description
    puts ""
    puts "Ok vous pouvez retourner a l'éditeur"
    @window_console.hide
  end
      
  def modifier_nom
    @name_edit_window = Window_NameEdit.new("")
    @name_input_window = Window_NameInputEdit.new(@name_edit_window)
    @name_input_window.set_handler(:ok,         method(:on_input_ok_name))
    @name_input_window.set_handler(:cancel,     method(:on_input_cancel_name))
    @window_command_modif.hide
    @window_command_modif.deactivate
  end
      #--------------------------------------------------------------------------
      # * Input [OK]
      #--------------------------------------------------------------------------
      def on_input_ok_name
        if !$game_editor.take_fonction_list.include?(@name_edit_window.name)
          puts $game_editor.fonction_actuel
          puts $game_editor.fonction_name
          puts @name_edit_window.name
          $game_editor.fonction_name = @name_edit_window.name
          @name_edit_window.close
          @name_input_window.close
          @commande_list_window.refresh
          @commande_list_window.activate
        else
          msgbox("Cette Fonction existe déjà.")
          @name_input_window.activate
        end
      end
      #--------------------------------------------------------------------------
      # * Cancel [OK]
      #--------------------------------------------------------------------------
      def on_input_cancel_name
        @name_edit_window.close
        @name_input_window.close
        @commande_list_window.refresh
        @window_command_modif.activate
      end
  
  def modifier_description
    @window_command_modif.hide
    @window_command_modif.deactivate
    define_description_new_fonction
    @commande_list_window.refresh
    @commande_list_window.activate
  end
  
  def modifier_commande
    SceneManager.call(Scene_Editor_W_Prog)
  end
  
  def supprimer_commande
    $game_editor.supprimer_fonction(@commande_list_window.index)
    @window_command_modif.hide
    @window_command_modif.deactivate
    @commande_list_window.refresh
    @commande_list_window.activate
  end
  
  def Modreturn
    @window_command_modif.hide
    @window_command_modif.deactivate
    @commande_list_window.activate
  end  
  
  def update
    super
    @description_window.print_description(@commande_list_window.index)
  end
end
