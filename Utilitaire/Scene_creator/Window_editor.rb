#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Scene_Editor_Commande           Modif commande window                    ║
#║    Modification des commande lier a une fenêtre                             ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Scene_Editor_W_Prog < Scene_Base
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
    @commande_list_window = Window_List_Command.new
    @commande_list_window.set_handler(:ok,      method(:list_commande_ok))
    @commande_list_window.set_handler(:cancel,     method(:return_scene))
    @commande_list_window.refresh
    @commande_list_window.select(0)
    @commande_window = Window_CommandSelect.new
    @commande_window.set_handler(:C1,        method(:Com1))
    @commande_window.set_handler(:C2,        method(:Com2))
    @commande_window.set_handler(:C3,        method(:Com3))
    @commande_window.set_handler(:C4,        method(:Com4))
    @commande_window.set_handler(:C5,        method(:Com5))
    @commande_window.set_handler(:C6,        method(:Com6))
    @commande_window.set_handler(:C7,        method(:Com7))
    @commande_window.set_handler(:C8,        method(:Com8))
    @commande_window.set_handler(:C9,        method(:Com9))
    @commande_window.set_handler(:C10,       method(:Com10))
    @commande_window.set_handler(:C11,       method(:Com11))
    @commande_window.set_handler(:C12,       method(:Com12))
    @commande_window.set_handler(:cancel,    method(:Comreturn))
    @commande_window.hide
    @commande_window.deactivate
  end
  
  def list_commande_ok
    @commande_list_window.deactivate
    if @commande_list_window.index == $game_editor.fonction_command.length
      @commande_window.show
      @commande_window.activate
    else
      @window_command_modif.show
      @window_command_modif.activate
    end
  end
  
  #--------------------------------------------------------------------------
  # * Create Secondary Window
  #--------------------------------------------------------------------------
  def create_secondary_window
    $game_editor.commande_actuel = @commande_list_window.index
    @description_window = Window_CommandeWindowDescription.new
    @window_command_modif = Window_CommandModifSelect.new
    @window_command_modif.set_handler(:Modif,         method(:Modifier_commande))
    @window_command_modif.set_handler(:Inser,         method(:Inserer_commande))
    @window_command_modif.set_handler(:Depla,         method(:Deplacer_commande))
    @window_command_modif.set_handler(:Suppr,         method(:Supprimer_commande))
    @window_command_modif.set_handler(:cancel,        method(:Modreturn))
    @window_command_modif.hide
    @window_command_modif.deactivate
    @window_console = Window_Console_Message.new
    @window_console.hide
    @commande_list_window.activate
  end
  
  def Modifier_commande
    
  end
  def Inserer_commande
  end
  def Deplacer_commande
  end
  def Supprimer_commande
    $game_editor.supprimer_commande(@commande_list_window.index)
    @window_command_modif.hide
    @window_command_modif.deactivate
    @commande_list_window.refresh
    @commande_list_window.activate
  end
  
  def Modreturn
    puts "return"
    @window_command_modif.hide
    @window_command_modif.deactivate
    @commande_list_window.activate
  end
  
  ##==========================================================================##
  ##==========================================================================##
  ##                                                                          ##
  ##                                COMMANDE                                  ##
  ##                                                                          ##
  ##==========================================================================##
  ##==========================================================================##
  
  def Com5 # Gestion variables
    
  end
  def Com6 # Recuperation Info
  end
  def Com7 # Lancement action
  end
  def Com8 # Définition liste
  end
  def Com9 # Condition
  end
  def Com10 # Boucle
  end
  def Com11 # Execution Script
  end
  
  def Comreturn
    @commande_window.hide
    @commande_window.deactivate
    @commande_list_window.activate
  end
  
  
  #=====================================================#
  #              COMMANDE 1 : TEXTE                     #
  #=====================================================#
  #Ajout texte
  def Com1
    @type = "Texte"
    @commande_window.deactivate
    if console_texte
      @x = 0
      @y = 0
      @commande_window.hide
      @window_command_command = Window_CommandTextSelect.new(@texte,@x,@y)
      @window_command_command.set_handler(:CT1,         method(:ComText1))
      @window_command_command.set_handler(:CT2,         method(:ComText2))
      @window_command_command.set_handler(:CT3,         method(:ComText3))
      @window_command_command.set_handler(:cancel,      method(:ComText4))
      @window_command_command.activate
    else
      @commande_window.activate
    end
  end
  
  def console_texte
    system("cls")
    puts "### Texte"
    puts ""
    puts "Entrer le texte que vous voulez afficher \nVoici la liste des commandes possibles :"
    puts ""
    puts "\\n  retour a la ligne"
    puts "\\{ augmente la taille du texte"
    puts "\\} diminue la taille du texte"
    puts "\\C[n] Affiche le texte qui suit de la couleur n"
    puts "\\I[n] Affiche l'icone numéro n"
    puts "\\V[name] Affiche la valeur de la variable name (lié a la window uniquement et non \ncelle du jeu)"
    puts "Liste des variables :"
    puts $game_editor.take_variable_list.to_s
    puts ""
    @window_console.show
    @window_console.opacity = 0
    @window_console.z = 200
    while @window_console.opacity < 250
      @window_console.opacity += 10
      update
    end
    @texte = ""
    loop do
      @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
      if @texte=="@exit"
        puts ""
        puts "EXIT OK"
        puts ""
        break
      elsif @texte != ""
        puts ""
        puts "Texte entrer : "
        puts ""
        puts @texte
        puts ""
        break
      end
    end
    puts "Ok vous pouvez retourner a l'éditeur"
    if @texte == "@exit"
      @window_console.hide
      return false
    end
    @window_console.hide
    return true
  end
  
    def ComText1
      console_texte
      @window_command_command.texte = @texte
      @window_command_command.refresh
      @window_command_command.activate
    end
    def ComText2
      @variable = "x"
      create_window_coord_texte
    end
    def ComText3
      @variable = "y"
      create_window_coord_texte
    end
    def ComText4
      array = [@type,@texte,@x,@y]
      $game_editor.commande_new(array)
      @window_command_command.close
      @commande_list_window.refresh
      @commande_list_window.activate
    end
    def create_window_coord_texte
      @window_command_command.deactivate
      @window_command_command_coord = Window_CommandTextCoordSelect.new
      @window_command_command_coord.set_handler(:CTT1,         method(:ComTextCoord1))
      @window_command_command_coord.set_handler(:CTT2,         method(:ComTextCoord2))
      @window_command_command_coord.activate
    end
      def ComTextCoord1 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
        @window_command_command_coord_define.number = @x if @variable == "x"
        @window_command_command_coord_define.number = @y if @variable == "y"
        loop do
          break if @window_command_command_coord_define.update_2
          update
        end
        @x = @window_command_command_coord_define.number if @variable == "x"
        @y = @window_command_command_coord_define.number if @variable == "y"
        @window_command_command_coord_define.close
        @window_command_command.x = @x
        @window_command_command.y = @y
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComTextCoord2 #"Variables"
        @window_command_command_coord.deactivate
        @window_command_command_coord_variables = Window_List_Variable_Int.new
        @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_text_ok))
        @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_text_cancel))
        @window_command_command_coord_variables.refresh
        @window_command_command_coord_variables.select(0)
        @window_command_command_coord_variables.activate
      end
        def list_variable_text_ok
          if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length
            creation_variables_texte
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          else
            @x = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index] if @variable == "x"
            @y = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index] if @variable == "y"
            @window_command_command.x = @x
            @window_command_command.y = @y
            @window_command_command.refresh
            @window_command_command.activate
            @window_command_command_coord_variables.close
            @window_command_command_coord.close
          end
        end
        def creation_variables_texte
          system("cls")
          puts "### Variables"
          puts ""
          puts "Entrer le nom de la nouvelle variable"
          puts ""
          @window_console.show
          @window_console.opacity = 0
          @window_console.z = 200
          while @window_console.opacity < 250
            @window_console.opacity += 10
            update
          end
          @texte = ""
          loop do
            @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
            if @texte=="@exit"
              puts ""
              puts "EXIT OK"
              puts ""
              break
            elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
              puts ""
              puts "Variable : "
              puts ""
              puts @texte
              puts ""
              $game_editor.variable_new(@texte,"Int")
              break
            end
          end
          puts "Ok vous pouvez retourner a l'éditeur"
          @window_console.hide
        end
        def list_variable_text_cancel
          @window_command_command_coord_variables.close
          @window_command_command_coord.activate
        end

  #=====================================================#
  #               COMMANDE 2 : ICON                     #
  #=====================================================#

  #Ajout Icon
  def Com2
    @type = "Icon"
    @id = 0
    @x = 0
    @y = 0
    @commande_window.hide
    @window_command_command = Window_CommandIconSelect.new(@id,@x,@y)
    @window_command_command.set_handler(:CT1,         method(:ComIcon1))
    @window_command_command.set_handler(:CT2,         method(:ComIcon2))
    @window_command_command.set_handler(:CT3,         method(:ComIcon3))
    @window_command_command.set_handler(:cancel,      method(:ComIcon4))
    @window_command_command.activate
  end
  
    def ComIcon1
      @variable = "id"
      create_window_coord_icon
    end
    def ComIcon2
      @variable = "x"
      create_window_coord_icon
    end
    def ComIcon3
      @variable = "y"
      create_window_coord_icon
    end 
    def ComIcon4
      array = [@type,@id,@x,@y]
      $game_editor.commande_new(array)
      @window_command_command.close
      @commande_list_window.refresh
      @commande_list_window.activate
    end
      def create_window_coord_icon
        @window_command_command.deactivate
        @window_command_command_coord = Window_CommandTextCoordSelect.new
        @window_command_command_coord.set_handler(:CTT1,         method(:ComIconCoord1)) if @variable == "id"
        @window_command_command_coord.set_handler(:CTT1,         method(:ComIconCoord2)) if @variable != "id"
        @window_command_command_coord.set_handler(:CTT2,         method(:ComIconCoord3))
        @window_command_command_coord.activate
      end
      def ComIconCoord1 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_icone_define = Window_CommandIconIconSelect.new
        @window_command_command_icone_define.number = @id
        loop do
          break if @window_command_command_icone_define.update_2
          update
        end
        @id = @window_command_command_icone_define.number
        @window_command_command_icone_define.close
        @window_command_command.id = @id
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComIconCoord2 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
        @window_command_command_coord_define.number = @x if @variable == "x"
        @window_command_command_coord_define.number = @y if @variable == "y"
        loop do
          break if @window_command_command_coord_define.update_2
          update
        end
        @x = @window_command_command_coord_define.number if @variable == "x"
        @y = @window_command_command_coord_define.number if @variable == "y"
        @window_command_command_coord_define.close
        @window_command_command.x = @x
        @window_command_command.y = @y
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComIconCoord3 #"Variables"
        @window_command_command_coord.deactivate
        @window_command_command_coord_variables = Window_List_Variable_Int.new
        @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_icon_ok))
        @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_icon_cancel))
        @window_command_command_coord_variables.refresh
        @window_command_command_coord_variables.select(0)
        @window_command_command_coord_variables.activate
      end
        def list_variable_icon_ok
          if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length
            creation_variables_texte
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          else
            @id = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index] if @variable == "id"
            @x = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "x"
            @y = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "y"
            @window_command_command.id = @id
            @window_command_command.x = @x
            @window_command_command.y = @y
            @window_command_command.refresh
            @window_command_command.activate
            @window_command_command_coord_variables.close
            @window_command_command_coord.close
          end
        end
        def list_variable_icon_cancel
          @window_command_command_coord_variables.close
          @window_command_command_coord.activate
        end
      
  #=====================================================#
  #               COMMANDE 3 : FACE                     #
  #=====================================================#
  
  #Ajout Face
  def Com3
    @type = "Face"
    @name = "Actor1"
    @id = 0
    @x = 0
    @y = 0
    @commande_window.hide
    @window_command_command = Window_CommandFaceSelect.new(@name,@id,@x,@y)
    @window_command_command.set_handler(:CF1,         method(:ComFace1))
    @window_command_command.set_handler(:CF2,         method(:ComFace2))
    @window_command_command.set_handler(:CF3,         method(:ComFace3))
    @window_command_command.set_handler(:CF4,         method(:ComFace4))
    @window_command_command.set_handler(:cancel,      method(:ComFace5))
    @window_command_command.activate
  end
  
    def ComFace1
      @variable = "name"
      create_window_coord_face
    end
    def ComFace2
      @variable = "id"
      create_window_coord_face
    end
    def ComFace3
      @variable = "x"
      create_window_coord_face
    end
    def ComFace4
      @variable = "y"
      create_window_coord_face
    end
    def ComFace5
      array = [@type,@name,@id,@x,@y]
      $game_editor.commande_new(array)
      @window_command_command.close
      @commande_list_window.refresh
      @commande_list_window.activate
    end
      def create_window_coord_face
        @window_command_command.deactivate
        @window_command_command_coord = Window_CommandTextCoordSelect.new
        @window_command_command_coord.set_handler(:CTT1,         method(:ComFaceCoord1)) if @variable == "name"
        @window_command_command_coord.set_handler(:CTT1,         method(:ComFaceCoord2)) if @variable == "id"
        @window_command_command_coord.set_handler(:CTT1,         method(:ComFaceCoord3)) if @variable == "x" || @variable == "y"
        @window_command_command_coord.set_handler(:CTT2,         method(:ComFaceCoord4))
        @window_command_command_coord.activate
      end
      def ComFaceCoord1 #"Définir"
        @window_command_command_coord.deactivate
        @array_face = []
        for i in Dir.glob("Graphics/Faces/*.png")
          @array_face.push(File.basename(i,".*"))
        end
        for i in Dir.glob(SCENE_CREATOR::EMPLACEMENT_RTP + "/Graphics/Faces/*.*")
          @array_face.push(File.basename(i,".*"))
        end
        @window_command_command_face_define = Window_List_Face.new(@array_face)
        @window_command_command_face_define.set_handler(:ok,      method(:list_face_ok))
        @window_command_command_face_define.set_handler(:cancel,  method(:list_face_cancel))
        @window_command_command_face_define.refresh
        @window_command_command_face_define.select(0)
        @window_command_command_face_define.activate
        @window_command_face_view = Window_FaceSelectorView.new
      end
        def list_face_ok
          id = @window_command_command_face_define.index
          @name = @array_face[id]
          @window_command_command_face_define.hide
          @window_command_face_view.hide
          @window_command_command_coord.hide
          @window_command_command.name = @name
          @window_command_command.refresh
          @window_command_command.activate
        end
        def list_face_cancel
          @window_command_command_face_define.hide
          @window_command_face_view.hide
          @window_command_command_coord.activate
        end
      def ComFaceCoord2 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_coord_define = Window_CommandFaceSelectId.new(@name)
        @window_command_command_coord_define.number = @id
        loop do
          break if @window_command_command_coord_define.update_2
          update
        end
        @id = @window_command_command_coord_define.number
        @window_command_command_coord_define.close
        @window_command_command.id = @id
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComFaceCoord3 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
        @window_command_command_coord_define.number = @x if @variable == "x"
        @window_command_command_coord_define.number = @y if @variable == "y"
        loop do
          break if @window_command_command_coord_define.update_2
          update
        end
        @x = @window_command_command_coord_define.number if @variable == "x"
        @y = @window_command_command_coord_define.number if @variable == "y"
        @window_command_command_coord_define.close
        @window_command_command.x = @x
        @window_command_command.y = @y
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComFaceCoord4 #"Variables"
        @window_command_command_coord.deactivate
        @window_command_command_coord_variables = Window_List_Variable_Int.new if @variable != "name"
        @window_command_command_coord_variables = Window_List_Variable_Str.new if @variable == "name"
        @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_face_ok))
        @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_face_cancel))
        @window_command_command_coord_variables.refresh
        @window_command_command_coord_variables.select(0)
        @window_command_command_coord_variables.activate
      end
        def list_variable_face_ok
          if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length && @variable != "name"
            creation_variables_texte
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          elsif@window_command_command_coord_variables.index == $game_editor.take_variable_list(:str).length
            creation_variables_texte2
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          else
            @name = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index] if @variable == "name"
            @id = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index] if @variable == "id"
            @x = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "x"
            @y = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "y"
            @window_command_command.name = @name
            @window_command_command.id = @id
            @window_command_command.x = @x
            @window_command_command.y = @y
            @window_command_command.refresh
            @window_command_command.activate
            @window_command_command_coord_variables.close
            @window_command_command_coord.close
          end
        end
        def creation_variables_texte2
          system("cls")
          puts "### Variables"
          puts ""
          puts "Entrer le nom de la nouvelle variable"
          puts ""
          @window_console.show
          @window_console.opacity = 0
          @window_console.z = 200
          while @window_console.opacity < 250
            @window_console.opacity += 10
            update
          end
          @texte = ""
          loop do
            @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
            if @texte=="@exit"
              puts ""
              puts "EXIT OK"
              puts ""
              break
            elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
              puts ""
              puts "Variable : "
              puts ""
              puts @texte
              puts ""
              $game_editor.variable_new(@texte,"Str")
              break
            end
          end
          puts "Ok vous pouvez retourner a l'éditeur"
          @window_console.hide
        end
        def list_variable_face_cancel
          @window_command_command_coord_variables.close
          @window_command_command_coord.activate
        end
  #=====================================================#
  #               COMMANDE 4  : PICTURE                  #
  #=====================================================#
  
  #Ajout Picture
  def Com4
    @type = "Picture"
    @name = ""
    @x = 0
    @y = 0
    @commande_window.hide
    @window_command_command = Window_CommandTextSelect.new(@name,@x,@y)
    @window_command_command.set_handler(:CT1,         method(:ComPict1))
    @window_command_command.set_handler(:CT2,         method(:ComPict2))
    @window_command_command.set_handler(:CT3,         method(:ComPict3))
    @window_command_command.set_handler(:cancel,      method(:ComPict4))
    @window_command_command.activate
  end
  
    def ComPict1
      @variable = "name"
      create_window_coord_pict
    end
    def ComPict2
      @variable = "x"
      create_window_coord_pict
    end
    def ComPict3
      @variable = "y"
      create_window_coord_pict
    end
    def ComPict4
      array = [@type,@name,@x,@y]
      $game_editor.commande_new(array)
      @window_command_command.close
      @commande_list_window.refresh
      @commande_list_window.activate
    end
      def create_window_coord_pict
        @window_command_command.deactivate
        @window_command_command_coord = Window_CommandTextCoordSelect.new
        @window_command_command_coord.set_handler(:CTT1,         method(:ComPictCoord1)) if @variable == "name"
        @window_command_command_coord.set_handler(:CTT1,         method(:ComPictCoord2)) if @variable != "name"
        @window_command_command_coord.set_handler(:CTT2,         method(:ComPictCoord3))
        @window_command_command_coord.activate
      end
      def ComPictCoord1 #"Définir"
        @window_command_command_coord.deactivate
        @array_face = []
        for i in Dir.glob("Graphics/Pictures/*.png")
          @array_face.push(File.basename(i,".*"))
        end
        for i in Dir.glob(SCENE_CREATOR::EMPLACEMENT_RTP + "/Graphics/Pictures/*.*")
          @array_face.push(File.basename(i,".*"))
        end
        if @array_face == []
          msgbox("Aucune image présente dans le dossier Pictures")
          @window_command_command_coord.activate
          return
        end
        @window_command_command_pict_define = Window_List_Pict.new(@array_face)
        @window_command_command_pict_define.set_handler(:ok,      method(:list_pict_ok))
        @window_command_command_pict_define.set_handler(:cancel,  method(:list_pict_cancel))
        @window_command_command_pict_define.refresh
        @window_command_command_pict_define.select(0)
        @window_command_command_pict_define.activate
      end
        def list_pict_ok
          id = @window_command_command_pict_define.index
          @name = @array_face[id]
          @window_command_command_pict_define.hide
          @window_command_command_coord.hide
          @window_command_command.texte = @name
          @window_command_command.refresh
          @window_command_command.activate
        end
        def list_pict_cancel
          @window_command_command_pict_define.hide
          @window_command_command_coord.activate
        end
      def ComPictCoord2 #"Définir"
        @window_command_command_coord.deactivate
        @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
        @window_command_command_coord_define.number = @x if @variable == "x"
        @window_command_command_coord_define.number = @y if @variable == "y"
        loop do
          break if @window_command_command_coord_define.update_2
          update
        end
        @x = @window_command_command_coord_define.number if @variable == "x"
        @y = @window_command_command_coord_define.number if @variable == "y"
        @window_command_command_coord_define.close
        @window_command_command.x = @x
        @window_command_command.y = @y
        @window_command_command.refresh
        @window_command_command.activate
        @window_command_command_coord.close
      end
      def ComPictCoord3 #"Variables"
        @window_command_command_coord.deactivate
        @window_command_command_coord_variables = Window_List_Variable_Int.new if @variable != "name"
        @window_command_command_coord_variables = Window_List_Variable_Str.new if @variable == "name"
        @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_pict_ok))
        @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_pict_cancel))
        @window_command_command_coord_variables.refresh
        @window_command_command_coord_variables.select(0)
        @window_command_command_coord_variables.activate
      end
        def list_variable_pict_ok
          if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length && @variable != "name"
            creation_variables_texte
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:str).length
            creation_variables_texte2
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.activate
          else
            @name = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index] if @variable == "name"
            @x = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "x"
            @y = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @variable == "y"
            @window_command_command.texte = @name
            @window_command_command.x = @x
            @window_command_command.y = @y
            @window_command_command.refresh
            @window_command_command.activate
            @window_command_command_coord_variables.close
            @window_command_command_coord.close
          end
        end
        def creation_variables_texte2
          system("cls")
          puts "### Variables"
          puts ""
          puts "Entrer le nom de la nouvelle variable"
          puts ""
          @window_console.show
          @window_console.opacity = 0
          @window_console.z = 200
          while @window_console.opacity < 250
            @window_console.opacity += 10
            update
          end
          @texte = ""
          loop do
            @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
            if @texte=="@exit"
              puts ""
              puts "EXIT OK"
              puts ""
              break
            elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
              puts ""
              puts "Variable : "
              puts ""
              puts @texte
              puts ""
              $game_editor.variable_new(@texte,"Str")
              break
            end
          end
          puts "Ok vous pouvez retourner a l'éditeur"
          @window_console.hide
        end
        def list_variable_pict_cancel
          @window_command_command_coord_variables.close
          @window_command_command_coord.activate
        end
  
  #=====================================================#
  #               COMMANDE 5 : VARIABLE                 #
  #=====================================================#
  
  #Ajout Variable
  def Com5
    @type = "Variable"
    @name = ""
    @op = "="
    @param = [0]
    @commande_window.hide
    @window_command_variable_description = Window_VariableWindowDescription.new
    @window_command_variable= Window_List_Variable_All.new
    @window_command_variable.set_handler(:ok,      method(:variable_ok))
    @window_command_variable.set_handler(:cancel,  method(:variable_cancel))
    @window_command_variable.refresh
    @window_command_variable.select(0)
    @window_command_variable.activate
  end
  
    def variable_cancel
      array = [@type,@name,@op,@param]
      $game_editor.commande_new(array) if @name != ""
      @window_command_variable.close
      @window_command_variable_description.close
      @commande_list_window.refresh
      @commande_list_window.activate
    end
        def creation_variables
          system("cls")
          puts "### Variables"
          puts ""
          puts "Entrer le nom de la nouvelle variable"
          puts ""
          @window_console.show
          @window_console.opacity = 0
          @window_console.z = 200
          while @window_console.opacity < 250
            @window_console.opacity += 10
            update
          end
          @texte = ""
          loop do
            @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
            if @texte=="@exit"
              puts ""
              puts "EXIT OK"
              puts ""
              break
            elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
              puts ""
              puts "Variable : "
              puts ""
              puts @texte
              puts ""
              @name = @texte
              break
            end
          end
          puts "Ok vous pouvez retourner a l'éditeur"
          @window_console.hide
        end
    def variable_ok
      @window_command_variable.deactivate
      if $game_editor.take_variable_list.length == @window_command_variable.index
        creation_variables
        @variable = "1"
        @window_command_variable_type = Window_TypeVariableSelect.new
        @window_command_variable_type.set_handler(:CV1,      method(:Var_Int))
        @window_command_variable_type.set_handler(:CV2,      method(:Var_Str))
        @window_command_variable_type.set_handler(:CV3,      method(:Var_Arr))
        @window_command_variable_type.set_handler(:cancel,   method(:var_cancel))
      else
        @name = $game_editor.take_variable_list[@window_command_variable.index]
        @window_command_variable_modif = Window_ModifVariableSelect.new(@name)
        @window_command_variable_modif.set_handler(:CVV1,      method(:Var_Value))
        @window_command_variable_modif.set_handler(:CVV2,      method(:Var_Name))
        @window_command_variable_modif.set_handler(:CVV3,      method(:Var_Type))
        @window_command_variable_modif.set_handler(:CVV4,      method(:Var_Supr))
        @window_command_variable_modif.set_handler(:cancel,   method(:var_modif_cancel))
      end
    end
      def Var_Int
        $game_editor.variable_new(@texte,"Int")
        var_cancel
      end
      def Var_Str
        $game_editor.variable_new(@texte,"Str")
        var_cancel
      end
      def Var_Arr
        $game_editor.variable_new(@texte,"Arr")
        var_cancel
      end
      def var_cancel
        @window_command_variable_type.hide
        @window_command_variable.refresh
        if @variable == "1"
          @window_command_variable.activate
        else
          @window_command_variable_modif.activate
        end
      end
      
      def Var_Value
        @window_command_variable_modif.deactivate
        @type2 = $game_editor.variable[@name]
        @window_command_variable_modif_2 = Window_ModifVariableSelect2.new
        @window_command_variable_modif_2.set_handler(:CVVV1,      method(:Var_Assignation))
        @window_command_variable_modif_2.set_handler(:CVVV2,      method(:Var_Ajout))
        @window_command_variable_modif_2.set_handler(:CVVV3,      method(:Var_Retrait))
        @window_command_variable_modif_2.set_handler(:cancel,   method(:var_modif_value_cancel))
      end ### Commande a faire
      
      ##########
      
        def Var_Assignation # Assignation
          @op = "="
          @window_command_variable_modif_2.deactivate
          @window_command_variable_modif_type = Window_CommandTextCoordSelect.new
          @window_command_variable_modif_type.set_handler(:CTT1,         method(:ComVariCoord1))
          @window_command_variable_modif_type.set_handler(:CTT2,         method(:ComVariCoord2))
          @window_command_variable_modif_type.set_handler(:cancel,       method(:comvaricoord3))
          @window_command_variable_modif_type.activate
        end
          def comvaricoord3
            @window_command_variable_modif_type.close
            @window_command_variable_modif_2.activate
          end
          def ComVariCoord1
            if @type2 == "Int"
              @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
              @window_command_command_coord_define.number = 0
              loop do
                break if @window_command_command_coord_define.update_2
                update
              end
              @param[0] = @window_command_command_coord_define.number
              @window_command_command_coord_define.hide
              comvaricoord3
            elsif @type2 == "Str"
              system("cls")
              puts "### Texte"
              puts ""
              puts "Entrer un texte à assigner"
              puts ""
              @window_console.show
              @window_console.opacity = 0
              @window_console.z = 200
              while @window_console.opacity < 250
                @window_console.opacity += 10
                update
              end
              @texte = ""
              loop do
                @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
                if @texte=="@exit"
                  puts ""
                  puts "EXIT OK"
                  puts ""
                  break
                elsif @texte != ""
                  puts ""
                  puts "Texte : "
                  puts ""
                  puts @texte
                  puts ""
                  break
                end
              end
              puts "Ok vous pouvez retourner a l'éditeur"
              @window_console.hide
              @param[0] = @texte
              comvaricoord3
            elsif @type2 == "Arr"
              system("cls")
              puts "### Tableaux"
              puts ""
              puts "Entrer les valeur du nouveau tableau"
              puts "Pour finir entrer @exit"
              puts ""
              @window_console.show
              @window_console.opacity = 0
              @window_console.z = 200
              while @window_console.opacity < 250
                @window_console.opacity += 10
                update
              end
              @texte = ""
              array = []
              loop do
                @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
                if @texte=="@exit"
                  puts ""
                  puts "EXIT OK"
                  puts ""
                  break
                elsif @texte != ""
                  array.push(@texte)
                  puts ""
                  puts "Tableau : "
                  puts ""
                  puts array
                  puts ""
                  break
                end
              end
              puts "Ok vous pouvez retourner a l'éditeur"
              @window_console.hide
              @param[0] = array
              comvaricoord3
            end
          end
          def ComVariCoord2
            @window_command_variable_modif_type.close
            @window_command_command_coord_variables = Window_List_Variable_Int.new if @type2 == "Int"
            @window_command_command_coord_variables = Window_List_Variable_Str.new if @type2 == "Str"
            @window_command_command_coord_variables = Window_List_Variable_Arr.new if @type2 == "Arr"
            @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_variable_ok))
            @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_variable_cancel))
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.select(0)
            @window_command_command_coord_variables.activate
          end
            def list_variable_variable_ok
              if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length && @type2 == "Int"
                creation_variables_texte
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:str).length && @type2 == "Str"
                creation_variables_texte2
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:arr).length
                creation_variables_texte3
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              else
                @param[0] = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @type2 == "Int"
                @param[0] = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index]  if @type2 == "Str"
                @param[0] = $game_editor.take_variable_list(:arr)[@window_command_command_coord_variables.index]  if @type2 == "Arr"
                list_variable_variable_cancel
              end
            end
            def creation_variables_texte3
              system("cls")
              puts "### Variables"
              puts ""
              puts "Entrer le nom de la nouvelle variable"
              puts ""
              @window_console.show
              @window_console.opacity = 0
              @window_console.z = 200
              while @window_console.opacity < 250
                @window_console.opacity += 10
                update
              end
              @texte = ""
              loop do
                @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
                if @texte=="@exit"
                  puts ""
                  puts "EXIT OK"
                  puts ""
                  break
                elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
                  puts ""
                  puts "Variable : "
                  puts ""
                  puts @texte
                  puts ""
                  $game_editor.variable_new(@texte,"Arr")
                  break
                end
              end
              puts "Ok vous pouvez retourner a l'éditeur"
              @window_console.hide
            end
            def list_variable_variable_cancel
              @window_command_command_coord_variables.close
              @window_command_variable_modif_2.activate
            end
          
        ########
            
        def Var_Ajout
          @op = "+"
          @window_command_variable_modif_2.deactivate
          @window_command_variable_modif_type = Window_CommandTextCoordSelect.new
          @window_command_variable_modif_type.set_handler(:CTT1,         method(:ComVariAjout1))
          @window_command_variable_modif_type.set_handler(:CTT2,         method(:ComVariAjout2))
          @window_command_variable_modif_type.set_handler(:cancel,       method(:comvariajout3))
          @window_command_variable_modif_type.activate
        end
          def comvariajout3
            @window_command_variable_modif_type.close
            @window_command_variable_modif_2.activate
          end
          def ComVariAjout1 # Ajout
            @op = "+"
            if @type2 == "Int"
              @window_command_variable_modif_2.deactivate
              @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
              @window_command_command_coord_define.number = 0
              loop do
                break if @window_command_command_coord_define.update_2
                update
              end
              @param[0] = @window_command_command_coord_define.number
              @window_command_command_coord_define.hide
              comvariajout3
            elsif @type2 == "Str"
              system("cls")
              puts "### Texte"
              puts ""
              puts "Entrer un texte à ajouter"
              puts ""
              @window_console.show
              @window_console.opacity = 0
              @window_console.z = 200
              while @window_console.opacity < 250
                @window_console.opacity += 10
                update
              end
              @texte = ""
              loop do
                @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
                if @texte=="@exit"
                  puts ""
                  puts "EXIT OK"
                  puts ""
                  break
                elsif @texte != ""
                  puts ""
                  puts "Texte : "
                  puts ""
                  puts @texte
                  puts ""
                  break
                end
              end
              puts "Ok vous pouvez retourner a l'éditeur"
              @window_console.hide
              @param[0] = @texte
              comvariajout3
            elsif @type2 == "Arr"
              system("cls")
              puts "### Tableaux"
              puts ""
              puts "Entrer les valeur du tableau a ajouter"
              puts "Pour finir entrer @exit"
              puts ""
              @window_console.show
              @window_console.opacity = 0
              @window_console.z = 200
              while @window_console.opacity < 250
                @window_console.opacity += 10
                update
              end
              @texte = ""
              array = []
              loop do
                @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
                if @texte=="@exit"
                  puts ""
                  puts "EXIT OK"
                  puts ""
                  break
                elsif @texte != ""
                  array.push(@texte)
                  puts ""
                  puts "Tableau : "
                  puts ""
                  puts array
                  puts ""
                  break
                end
              end
              puts "Ok vous pouvez retourner a l'éditeur"
              @window_console.hide
              @param[0] = array
              comvariajout3
            end
          end
          def ComVariAjout2
            @window_command_variable_modif_type.close
            @window_command_command_coord_variables = Window_List_Variable_Int.new if @type2 == "Int"
            @window_command_command_coord_variables = Window_List_Variable_Str.new if @type2 == "Str"
            @window_command_command_coord_variables = Window_List_Variable_Arr.new if @type2 == "Arr"
            @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_ajout_ok))
            @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_ajout_cancel))
            @window_command_command_coord_variables.refresh
            @window_command_command_coord_variables.select(0)
            @window_command_command_coord_variables.activate
          end
            def list_variable_ajout_ok
              if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length && @type2 == "Int"
                creation_variables_texte
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:str).length && @type2 == "Str"
                creation_variables_texte2
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:arr).length
                creation_variables_texte3
                @window_command_command_coord_variables.refresh
                @window_command_command_coord_variables.activate
              else
                @param[0] = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @type2 == "Int"
                @param[0] = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index]  if @type2 == "Str"
                @param[0] = $game_editor.take_variable_list(:arr)[@window_command_command_coord_variables.index]  if @type2 == "Arr"
                list_variable_ajout_cancel
              end
            end
            def list_variable_ajout_cancel
              @window_command_command_coord_variables.close
              @window_command_variable_modif_2.activate
            end
        
        ##########
        
        def Var_Retrait
          @op = "-"
          @window_command_variable_modif_2.deactivate
          @window_command_variable_retrait = Window_ModifVariableSelectRetrait.new
          @window_command_variable_retrait.set_handler(:CVR1,         method(:retrait1))
          @window_command_variable_retrait.set_handler(:CVR2,         method(:retrait2))
          @window_command_variable_retrait.set_handler(:cancel,         method(:retrait3))
        end
          
        def retrait1
          @variable = "deb"
          retrait
        end
        def retrait2
          @variable = "fin"
          retrait
        end
        def retrait3
          @window_command_variable_modif_2.activate
          @window_command_variable_retrait.close
        end
          
          def retrait
            @window_command_variable_retrait.deactivate
            @window_command_variable_modif_type = Window_CommandTextCoordSelect.new
            @window_command_variable_modif_type.set_handler(:CTT1,         method(:ComVariRetrait1))
            @window_command_variable_modif_type.set_handler(:CTT2,         method(:ComVariRetrait2))
            @window_command_variable_modif_type.set_handler(:cancel,       method(:comvariretrait3))
            @window_command_variable_modif_type.activate
          end
            def ComVariRetrait1
              if @type2 == "Int"
                @window_command_variable_modif_type.deactivate
                @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
                @window_command_command_coord_define.number = 0
                loop do
                  break if @window_command_command_coord_define.update_2
                  update
                end
                @param[0] = @window_command_command_coord_define.number
                @window_command_command_coord_define.hide
                comvariretrait3
              elsif @type2 != "Int"
                @window_command_variable_modif_type.deactivate
                @window_command_command_coord_define = Window_CommandTextCoordSelect_Number.new
                @window_command_command_coord_define.number = 0
                loop do
                  break if @window_command_command_coord_define.update_2
                  update
                end
                @param[0] = @window_command_command_coord_define.number if @variable == "deb"
                @param[1] = @window_command_command_coord_define.number if @variable == "fin"
                @window_command_command_coord_define.hide
                comvariretrait3
              end
            end
            def comvariretrait3
              @window_command_variable_modif_type.close
              @window_command_variable_retrait.activate
            end
            def ComVariRetrait2
              @window_command_variable_modif_type.close
              @window_command_command_coord_variables = Window_List_Variable_Int.new if @type2 == "Int"
              @window_command_command_coord_variables = Window_List_Variable_Str.new if @type2 == "Str"
              @window_command_command_coord_variables = Window_List_Variable_Arr.new if @type2 == "Arr"
              @window_command_command_coord_variables.set_handler(:ok,      method(:list_variable_retrait_ok))
              @window_command_command_coord_variables.set_handler(:cancel,  method(:list_variable_retrait_cancel))
              @window_command_command_coord_variables.refresh
              @window_command_command_coord_variables.select(0)
              @window_command_command_coord_variables.activate
            end
              def list_variable_retrait_ok
                if @window_command_command_coord_variables.index == $game_editor.take_variable_list(:int).length && @type2 == "Int"
                  creation_variables_texte
                  @window_command_command_coord_variables.refresh
                  @window_command_command_coord_variables.activate
                elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:str).length && @type2 == "Str"
                  creation_variables_texte2
                  @window_command_command_coord_variables.refresh
                  @window_command_command_coord_variables.activate
                elsif @window_command_command_coord_variables.index == $game_editor.take_variable_list(:arr).length
                  creation_variables_texte3
                  @window_command_command_coord_variables.refresh
                  @window_command_command_coord_variables.activate
                else
                  @param[0] = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @type2 == "Int" && @variable == "deb"
                  @param[0] = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index]  if @type2 == "Str" && @variable == "deb"
                  @param[0] = $game_editor.take_variable_list(:arr)[@window_command_command_coord_variables.index]  if @type2 == "Arr" && @variable == "deb"
                  @param[1] = $game_editor.take_variable_list(:int)[@window_command_command_coord_variables.index]  if @type2 == "Int" && @variable == "fin"
                  @param[1] = $game_editor.take_variable_list(:str)[@window_command_command_coord_variables.index]  if @type2 == "Str" && @variable == "fin"
                  @param[1] = $game_editor.take_variable_list(:arr)[@window_command_command_coord_variables.index]  if @type2 == "Arr" && @variable == "fin"
                  list_variable_retrait_cancel
                end
              end
              def list_variable_retrait_cancel
                @window_command_command_coord_variables.close
                @window_command_variable_retrait.activate
              end
              
              
        def var_modif_value_cancel # Cancel
          @window_command_variable_modif_type.close
          @window_command_variable_modif_2.hide
          @window_command_variable_modif.activate
        end
        
      ###########
        
      def Var_Name
        @window_command_variable_modif.deactivate
        creation_variables
        type = $game_editor.variable[@name]
        delete_variable(@name)
        $game_editor.variable_new(@texte,type)
        @window_command_variable_modif.activate
      end
      def Var_Type
        @window_command_variable_modif.deactivate
        @variable = "2"
        @window_command_variable_type = Window_TypeVariableSelect
        @window_command_variable_type.set_handler(:CV1,      method(:Var_Int))
        @window_command_variable_type.set_handler(:CV2,      method(:Var_Str))
        @window_command_variable_type.set_handler(:CV3,      method(:Var_Arr))
        @window_command_variable_type.set_handler(:cancel,   method(:Var_Cancel))
      end
      def Var_Supr
        $game_editor.delete_variable(@name)
        var_modif_cancel
      end
      def var_modif_cancel
        @window_command_variable_modif.hide
        @window_command_variable.refresh
        @window_command_variable.activate
        variable_cancel
      end
  
        def creation_variables
          system("cls")
          puts "### Variables"
          puts ""
          puts "Entrer le nom de la nouvelle variable"
          puts ""
          @window_console.show
          @window_console.opacity = 0
          @window_console.z = 200
          while @window_console.opacity < 250
            @window_console.opacity += 10
            update
          end
          @texte = ""
          loop do
            @texte = Vincent_26_Scene_Editor_Console::REPL.instance.start(binding)
            if @texte=="@exit"
              puts ""
              puts "EXIT OK"
              puts ""
              break
            elsif @texte != "" && !$game_editor.take_variable_list.include?(@texte)
              puts ""
              puts "Variable : "
              puts ""
              puts @texte
              puts ""
              break
            end
          end
          puts "Ok vous pouvez retourner a l'éditeur"
          @window_console.hide
        end
        
  #=====================================================#
  #              COMMANDE 6 : RECUP INFO                #
  #=====================================================#
      
  
  def Com6 # Recuperation Info
    
  end
#~   def Com6 # Modification Window
#~     @type = "Window_Modif"
#~     @name = ""
#~     @param = [0]
#~     @commande_window.hide
#~     @window_command_variable_description = Window_VariableWindowDescription.new
#~     @window_command_variable= Window_List_Variable_All.new
#~     @window_command_variable.set_handler(:ok,      method(:variable_ok))
#~     @window_command_variable.set_handler(:cancel,  method(:variable_cancel))
#~     @window_command_variable.refresh
#~     @window_command_variable.select(0)
#~     @window_command_variable.activate
#~   end
        
  def update
    super
    @description_window.print_description(@commande_list_window.index)
    if @window_command_command_face_define
      id = @window_command_command_face_define.index
      @window_command_face_view.name = @array_face[id]
      @window_command_face_view.draw_item
    end
    if @window_command_variable
      @window_command_variable_description.print_description(@window_command_variable.index)
    end
  end
  
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_ModifVariableSelectRetrait < Window_Command
  def initialize
    super(56, 160)
  end
  def window_width
    return 272
  end
  def make_command_list
    add_command("Début",    :CVR1, true)
    add_command("Fin",      :CVR2,  true)
  end
  def refresh
    super
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Variable_Arr           Liste commande window                 ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Variable_Arr < Window_Selectable
  def initialize
    super(136, 160-24,272,24*6)
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
    @data = $game_editor.take_variable_list(:arr)
    @data.push("NEW VARIABLE")
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
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_ModifVariableSelect2 < Window_Command
  def initialize
    super(56, 160)
  end
  def window_width
    return 272
  end
  def make_command_list
    add_command("Assigner",    :CVVV1, true)
    add_command("Ajout",       :CVVV2,  true)
    add_command("Retrait",      :CVVV3,  true)
  end
  def refresh
    super
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_ModifVariableSelect < Window_Command
  def initialize(name)
    @name = name
    super(56, 160)
  end
  def window_width
    return 272
  end
  def make_command_list
    add_command("Modifier Value",    :CVV1,  true)
    add_command("Modifier Nom",      :CVV2,  can_delete?)
    add_command("Modifier Type",     :CVV3,  can_delete?)
    add_command("Supprimer",         :CVV4,  can_delete?)
  end
  def refresh
    super
  end
  def can_delete?
    array = ["x","y","z","w","h","opacity_back","opacity_window","opacity_contents"]
    if array.include?(@name)
      return false
    end
    return true
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_TypeVariableSelect < Window_Command
  def initialize
    super(56, 160)
  end
  def window_width
    return 272
  end
  def make_command_list
    add_command("Nombre",         :CV1,        true)
    add_command("Texte",          :CV2,        true)
    add_command("Tableau",        :CV3,        true)
  end
  def refresh
    super
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_EditorDescription              Description window                 ║
#║    Fenetre de description generale                                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_VariableWindowDescription  < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    if $game_editor.take_variable_list.length == id
      draw_text_ex(0, 0, "Ajout d'une nouvelle\nvariable")
    else
      var = $game_editor.take_variable_list[id]
      type = $game_editor.variable[var]
      type = "Nombre" if type == "Int"
      type = "Texte" if type == "Str"
      type = "Tableau" if type == "Arr"
      draw_text_ex(0, 0, "Name : " + var)
      draw_text_ex(0, 24, "Type : " + type)
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Variable_Str           Liste commande window                 ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Variable_All < Window_Selectable
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
    @data = $game_editor.take_variable_list
    @data.push("NEW VARIABLE")
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
#║    Window_List_Variable_Str           Liste commande window                 ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Variable_Str < Window_Selectable
  def initialize
    super(136, 160-24,272,24*6)
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
    @data = $game_editor.take_variable_list(:str)
    @data.push("NEW VARIABLE")
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
#║    Window_List_Face              Liste commande window                      ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Pict < Window_Selectable
  def initialize(array)
    super(0, 0,272,416)
    @array = array
    @sprite = Sprite.new
    @sprite.bitmap = Cache.picture(@array[0])
    @sprite.z = 200
    self.z = 201
    @old_index = 0
    @data = []
  end
  def dispose
    @sprite.dispose
    super
  end
  def hide
    @sprite.dispose
    super
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
    @data = @array.clone
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
  
  def update
    super
    if @old_index != index
      @sprite.bitmap = Cache.picture(@array[index])
      @old_index = index
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect     Fenêtre secondaire type                     ║
#║    Selecteur Différent attribut de fenêtre                                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandFaceSelectId < Window_Base
  
  attr_accessor :number
  
  def initialize(name)
    super(0, 0,408,216)
    @number = 0
    @bitmap = Cache.face(name)
    @rect = Rect.new(0,0,384,192)
    @bitmap2 = Bitmap.new(96,96)
    @bitmap2.fill_rect(0,0,96,96, Color.new(255,255,0,100))
    @rect2 = Rect.new(0,0,96,96)
    draw_item
  end
  
  def dispose
    super
    @sprite.dispose
    @sprite2.dispose
  end
  
  def draw_item
    contents.clear
    contents.blt(0,0,@bitmap,@rect)
    contents.blt((@number % 4)*96,@number/4*96,@bitmap2,@rect2)
  end
  def update_2
    if Input.trigger?(:UP)
      @number = (@number-4) % 8
    elsif Input.trigger?(:DOWN)
      @number = (@number+4)%8
    elsif Input.trigger?(:LEFT)
      @number = (@number-1)%8
    elsif Input.trigger?(:RIGHT)
      @number = (@number+1)%8
    elsif Input.trigger?(:B)
      return @number
    elsif Input.trigger?(:C)
      return @number
    end
    draw_item
    return false
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_TypeSec_LHEC     Fenêtre secondaire type                          ║
#║    Selecteur Différent attribut de fenêtre                                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_FaceSelectorView < Window_Base
  
  attr_accessor :name
  
  def initialize
    super(0, 200,408,216)
    @name = "Actor1"
    @rect = Rect.new(0,0,384,192)
  end
  def draw_item
    contents.clear
    bitmap = Cache.face(@name)
    contents.blt(0,0,bitmap,@rect)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Face              Liste commande window                      ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Face < Window_Selectable
  def initialize(array)
    super(0, 0,272,192)
    @array = array
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
    @data = @array.clone
    puts @data
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
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandFaceSelect < Window_Command
  attr_accessor :name
  attr_accessor :id
  attr_accessor :x
  attr_accessor :y
  def initialize(name,id,x,y)
    @name = name
    @id = id
    @x = x
    @y = y
    super(56, 160)
    draw_icon(@id,272-60,0)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("name: "+@name.to_s,     :CF1,        true)
    add_command("id: "+@id.to_s,         :CF2,        true)
    add_command("x : "+@x.to_s,          :CF3,        true)
    add_command("y : "+@y.to_s,          :CF4,        true)
  end
  def refresh
    super
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect     Fenêtre secondaire type                     ║
#║    Selecteur Différent attribut de fenêtre                                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandIconIconSelect < Window_Base
  
  attr_accessor :number
  
  def initialize
    super(0, 0,408,96)
    @number = 0
    @bitmap = Cache.system("Iconset")
    @rect = Rect.new(0,0,384,3*24)
    @bitmap2 = Bitmap.new(24,24)
    @bitmap2.fill_rect(0,0,24,24, Color.new(255,255,0,100))
    @rect2 = Rect.new(0,0,24,24)
    @timer = 0
    draw_item
  end
  
  def dispose
    super
    @sprite.dispose
    @sprite2.dispose
  end
  
  def draw_item
    contents.clear
    @rect.y = (@number/16)*24-24
    contents.blt(0,0,@bitmap,@rect)
    contents.blt((@number % 16)*24,24,@bitmap2,@rect2)
  end
  def update_2
    if Input.trigger?(:UP) || (@timer > 10 && Input.press?(:UP) && (Graphics.frame_count % 5) == 0)
      @number -= 16
      @number = @number % 16 if (@number<0)
    elsif ((Input.trigger?(:DOWN) || (@timer > 10 && Input.press?(:DOWN) && (Graphics.frame_count % 5) == 0)) && (@number+16)/16 < (@bitmap.height/24) )
      @number += 16
    elsif Input.trigger?(:LEFT) || (@timer > 10 && Input.press?(:LEFT) && (Graphics.frame_count % 5) == 0)
      @number -= 1
      @number = @number % 16 if (@number<0)
    elsif Input.trigger?(:RIGHT) || (@timer > 10 && Input.press?(:RIGHT) && (Graphics.frame_count % 5) == 0)
      @number += 1
    elsif Input.trigger?(:B)
      return @number
    elsif Input.trigger?(:C)
      return @number
    end
    @timer = 0 if Input.trigger?(:UP) || Input.trigger?(:DOWN) ||Input.trigger?(:LEFT) ||Input.trigger?(:RIGHT)
    @timer += 1 if Input.press?(:UP) || Input.press?(:DOWN) ||Input.press?(:LEFT) ||Input.press?(:RIGHT)
    draw_item
    return false
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandIconSelect          Fenêtre secondaire commande            ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandIconSelect < Window_Command
  attr_accessor :id
  attr_accessor :x
  attr_accessor :y
  def initialize(id,x,y)
    @id = id
    @x = x
    @y = y
    super(56, 160)
    draw_icon(@id,272-60,0)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("id: "+@id.to_s,         :CT1,        true)
    add_command("x : "+@x.to_s,          :CT2,        true)
    add_command("y : "+@y.to_s,          :CT3,        true)
  end
  def refresh
    super
    if @id.is_a?(Integer)
      draw_icon(@id,272-60,0)
    end
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_TypeSec_LHEC     Fenêtre secondaire type                          ║
#║    Selecteur Différent attribut de fenêtre                                  ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandTextCoordSelect_Number < Window_Base
  
  attr_accessor :number
  
  def initialize
    super(272, 0,544-272,72)
    @number = 0
    draw_item
  end
  def draw_item
    contents.clear
    draw_text_ex(0,0,@number.to_s)
  end
  def update_2
    if Input.trigger?(:UP)
      @number += 1
    elsif Input.trigger?(:DOWN)
      @number -= 1
      @number = 0   if (@number<0)
    elsif Input.trigger?(:LEFT)
      @number -= 10
      @number = 0   if (@number<0)
    elsif Input.trigger?(:RIGHT)
      @number += 10
    elsif Input.trigger?(:B)
      return @number
    elsif Input.trigger?(:C)
      return @number
    end
    draw_item
    return false
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Window              Liste commande window                    ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Variable_Int < Window_Selectable
  def initialize
    super(136, 160-24,272,24*6)
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
    @data = $game_editor.take_variable_list(:int)
    @data.push("NEW VARIABLE")
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
#║    Window_CommandTextSelect     Fenêtre secondaire commande                 ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandTextCoordSelect < Window_Command
  def initialize
    super(216, 160)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("Définir",                 :CTT1,        true)
    add_command("Variables",               :CTT2,        true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandTextSelect     Fenêtre secondaire commande                 ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandTextSelect < Window_Command
  
  attr_accessor :texte
  attr_accessor :x
  attr_accessor :y
  
  def initialize(text,x,y)
    @texte = text
    @x = x
    @y = y
    super(56, 160)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    @texte = @texte[0..20] + "..." if @texte.length > 23
    add_command(@texte,                  :CT1,        true)
    add_command("x : "+@x.to_s,          :CT2,        true)
    add_command("y : "+@y.to_s,          :CT3,        true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandSelect     Fenêtre secondaire commande                     ║
#║    Selecteur d'ajout de commande                                            ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandSelect < Window_Command
  def initialize
    super(0, 0)
  end
  def window_width
    return 544-272
  end
  def make_command_list
    add_command("Afficher Texte",                 :C1,        true)
    add_command("Afficher Icon",                  :C2,        true)
    add_command("Afficher Face",                  :C3,        true)
    add_command("Afficher Image",                 :C4,        true)
    add_command("Creer/Ajuster Variables",        :C5,        true)
    add_command("Récuperer Info",                 :C6,        true)
    add_command("Lancer une fonction",            :C7,        true)
    add_command("Définir Liste",                  :C8,        true)
    add_command("Condition",                      :C9,       true)
    add_command("Boucle",                         :C10,       true)
    add_command("Executer un script",             :C11,       true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandSongSelect     Fenêtre secondaire caractéristique          ║
#║    Selecteur de ton de fenêtre                                              ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandSongSelect < Window_Command
  def initialize
    super(50, 100)
  end
  def window_width
    return 100
  end
  def make_command_list
    add_command("SE",      :SE,        true)
    add_command("ME",      :ME,        true)
    add_command("BGM",     :BGM,       true)
    add_command("BGS",     :BGS,       true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_CommandSongSelect     Fenêtre secondaire caractéristique          ║
#║    Selecteur de ton de fenêtre                                              ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandModifSelect < Window_Command
  def initialize
    super(0, 416-120)
  end
  def window_width
    return 272
  end
  def window_height
    return 120
  end
  def make_command_list
    add_command("Modifier",      :Modif,        true)
    add_command("Inserer",       :Inser,        true)
    add_command("Déplacer",      :Depla,        true)
    add_command("Supprimer",     :Suppr,        true)
  end
end
#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Window_List_Window              Liste commande window                    ║
#║    Liste des commande lié a une window selectionné                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_List_Command < Window_Selectable
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
    for command in $game_editor.fonction_command
      case command[0]
      when "Texte";
        texte = command[1].to_s
        texte = texte[0..12] + "..." if texte.length > 15
        @data.push("Texte : "+texte.to_s)
      when "Icon";
        @data.push("Icon : "+command[1].to_s)
      when "Face";
        @data.push("Face : "+command[1].to_s)
      when "Picture";
        @data.push("Picture : "+command[1].to_s)
      when "Variable"; #[@type,@name,@op,@param]
        @data.push("Variable : "+command[1].to_s + command[2])
      when 6;
        @data.push("Modifier Window")
      when 7;
        @data.push("Récuperer Info")
      when 8;
        @data.push("Lancer une fonction")
      when 9;
        @data.push("Définir Liste")
      when 10;
        @data.push("Condition")
      when 11;
        @data.push("Boucle")
      when 12;
        @data.push("Executer un script")
      end
    end
    @data.push("New commande")
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
#║    Window_EditorDescription              Description window                 ║
#║    Fenetre de description generale                                          ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Window_CommandeWindowDescription  < Window_Base
  def initialize
    super(272,0,544-272,416)
  end
  def print_description(id)
    contents.clear
    if $game_editor.fonction_command.length == id
      draw_text_ex(0, 0, "Ajout d'une nouvelle\ncommande")
    else
      commande = $game_editor.fonction_command[id]
      case commande[0]
      when "Texte";
        draw_text_ex(0, 0, "Affichage Texte")
        draw_text_ex(0, 24, "x:"+commande[2].to_s)
        draw_text_ex(0, 48, "y:"+commande[3].to_s)
        desc = commande[1]
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
        draw_text_ex(0, 72, final)
      when "Icon";
        draw_text_ex(0, 0, "Affichage Icon")
        draw_text_ex(0, 24, "x:"+commande[2].to_s)
        draw_text_ex(0, 48, "y:"+commande[3].to_s)
        draw_text_ex(0, 72, "id:"+commande[1].to_s)
        draw_icon(commande[1],272-60,72) if commande[1].is_a?(Integer)
      when "Face";
        draw_text_ex(0, 0, "Affichage Face")
        draw_text_ex(0, 24, "x:"+commande[3].to_s)
        draw_text_ex(0, 48, "y:"+commande[4].to_s)
        draw_text_ex(0, 72, "name:"+commande[1].to_s)
        draw_text_ex(0, 96, "id:"+commande[2].to_s)
        if commande[2].is_a?(Integer)
          draw_face(commande[1],commande[2],272-92-24,120) rescue true
        end
      when "Picture";
        draw_text_ex(0, 0, "Affichage Picture")
        draw_text_ex(0, 24, "x:"+commande[2].to_s)
        draw_text_ex(0, 48, "y:"+commande[3].to_s)
        draw_text_ex(0, 72, "name:"+commande[1].to_s)
      when "Variable";
        draw_text_ex(0, 0, "Modifier Variable")
        draw_text_ex(0, 24, "name:"+commande[1])
        draw_text_ex(0, 48, "operation:"+commande[2])
        draw_text_ex(0, 72, "parametre:")
        draw_text_ex(0, 96, commande[3].to_s)
      end
    end
  end
end
