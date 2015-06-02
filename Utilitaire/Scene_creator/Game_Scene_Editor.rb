module SCENE_CREATOR
  
  ACTIVE_SCENE_EDITOR = true
  
  EMPLACEMENT_RTP = "C:/Program Files (x86)/Common Files/Enterbrain/RGSS3/RPGVXAce"
  
end
#~     @type = 1 if type == "normal"
#~     @type = 2 if type == "selecteur"
#~     @type = 3 if type == "commande"
#~     @type = 4 if type == "commande hor"

#╔═════════════════════════════════════════════════════════════════════════════╗
#║    Game_Scene_Editor              Gestion donnée Scene                      ║
#║    Gere les différente donnée pour les scene                                ║
#╚═════════════════════════════════════════════════════════════════════════════╝
class Game_Scene_Editor
  
  attr_accessor :scene_actuel
  attr_accessor :window_actuel
  attr_accessor :commande_actuel
  attr_accessor :coordonnée_type
  attr_accessor :fonction_actuel
  attr_accessor :commande_actuel
  
  
  ################
  # Initialisation
  def initialize
    @scene_actuel = nil
    @window_actuel = nil
    @commande_actuel = nil
    @fonction_actuel = nil
    @commande_actuel = nil
    @coordonnée_type = 0
    @scene_hash = {}
  end
  
  #######
  # Reset
  def reset
    @scene_hash = {}
  end
  
  #############################
  # Lancement Editeur Generale
  def start
    SceneManager.call(Scene_Editor_Start)
  end
  
  
  ##############################################################################
  #GESTION SCENE                                                               #
  ##############################################################################
  
  #############
  # Ajout scene
  def scene_new(name)
    if @scene_hash.include?(name.to_sym)
      msgbox("Cette Scene existe déjà.")
      return false
    else
      @scene_hash[name.to_sym] = {}
      @scene_hash[name.to_sym][:window] = {}
      @scene_hash[name.to_sym][:commande] = {}
      @scene_hash[name.to_sym][:back] = 0
      return true
    end
  end
  
  ###################
  # Suppression scene
  def scene_delete(name)
    @scene_hash.delete(name.to_sym)
  end
  
  ############################
  # Modification du background
  def modif_background_scene(name)
    @scene_hash[@scene_actuel][:back] = name
  end
  
  ######################################
  # Recupere la liste de toute les scene
  def take_scene_list
    @scene_hash.keys.sort!
  end
  
  ##########################
  # Recupere la scene actuel
  def take_scene
    @scene_hash[@scene_actuel].clone
  end
  
  ###################
  # Définit une scene
  def scene_define(name,scene)
    @scene_hash[name.to_sym] = scene
  end
  
  ##############################################################################
  #GESTION WINDOW                                                              #
  ##############################################################################
  
  ##############
  # Ajout window
  def new_window(name)
    if @scene_hash[@scene_actuel][:window].include?(name.to_sym)
      msgbox("Cette Window existe déjà.")
      return false
    else
      #definition du ton standard
      tone_s = $data_system.window_tone
      tone_w = {:red => tone_s.red ,:green => tone_s.green ,:blue => tone_s.blue ,:gray => tone_s.gray}
      #definition commande standard
      update_c      = {:name => "update" ,:commande_list => [],:description => "Fonction de mise a jour"}
      initialize_c  = {:name => "initialize" ,:commande_list => [],:description => "Fonction d'initialisation"}
      refresh_c     = {:name => "refresh" ,:commande_list => [],:description => "Fonction de rafraichissement"}
      #definition variable normal
      var = {"x"=>"Int","y"=>"Int","z"=>"Int","w"=>"Int","h"=>"Int",
             "opacity_back"=>"Int","opacity_window"=>"Int","opacity_contents"=>"Int"}
      #creation hash window
      window = {:x=>0 ,:y=>0 ,:z=>0 ,:w=>160 ,:h=>-1,
                :type => "normal",
                :nbr_commande => 1,
                :commande_name => [""],
                :commande_type => 0,
                :colonne => 2,
                :espace => 19,
                :back_opacity => 192,
                :window_opacity => 255,
                :contents_opacity => 255,
                :hide => false,
                :windowskin => nil,
                :tone => tone_w,
                :commande => [initialize_c,update_c,refresh_c],
                :variable => var
                }
      #assignation window
      @scene_hash[@scene_actuel][:window][name.to_sym] = window
      return true
    end
  end
  
  ###############
  # Delete window
  def delete_window(name)
    @scene_hash[@scene_actuel][:window].delete(name.to_sym)
  end
  
  #############
  # Take window
  def take_window
    @scene_hash[@scene_actuel][:window][@window_actuel].clone
  end
  
  ###################
  # Définit une window
  def window_define(name,window)
    @scene_hash[@scene_actuel][:window][name.to_sym] = window
  end
  
  #############################
  # Recupere le Hash des window
  def get_window
    return @scene_hash[@scene_actuel][:window].clone
  end
  
  #######################################
  # Recupere la liste de toute les window
  def take_window_list
    @scene_hash[@scene_actuel][:window].keys.sort!
  end
  
  def x=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:x] = value
  end
  def y=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:y] = value
  end
  def z=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:z] = value
  end
  def w=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:w] = value
  end
  def h=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:h] = value
  end
  def type=(value) 
    @scene_hash[@scene_actuel][:window][@window_actuel][:type] = value
  end
  def nbr_commande=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:nbr_commande] = value
  end
  def commande_name=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande_name] = value
  end
  def colonne=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:colonne] = value
  end
  def espace=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:espace] = value
  end
  def back_opacity=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:back_opacity] = value
  end
  def window_opacity=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:window_opacity] = value
  end
  def contents_opacity=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:contents_opacity] = value
  end
  def hide=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:hide] = value
  end
  def windowskin=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:windowskin] = value
  end
  def tone=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:tone] = value
  end
  def commande=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande] = value
  end
  def variable=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:variable] = value
  end
  
  def x
    @scene_hash[@scene_actuel][:window][@window_actuel][:x]
  end
  def y
    @scene_hash[@scene_actuel][:window][@window_actuel][:y]
  end
  def z
    @scene_hash[@scene_actuel][:window][@window_actuel][:z]
  end
  def w
    @scene_hash[@scene_actuel][:window][@window_actuel][:w]
  end
  def h
    @scene_hash[@scene_actuel][:window][@window_actuel][:h]
  end
  def type
    @scene_hash[@scene_actuel][:window][@window_actuel][:type]
  end
  def nbr_commande
    @scene_hash[@scene_actuel][:window][@window_actuel][:nbr_commande]
  end
  def commande_name
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande_name]
  end
  def colonne
    @scene_hash[@scene_actuel][:window][@window_actuel][:colonne]
  end
  def espace
    @scene_hash[@scene_actuel][:window][@window_actuel][:espace]
  end
  def back_opacity
    @scene_hash[@scene_actuel][:window][@window_actuel][:back_opacity]
  end
  def window_opacity
    @scene_hash[@scene_actuel][:window][@window_actuel][:window_opacity]
  end
  def contents_opacity
    @scene_hash[@scene_actuel][:window][@window_actuel][:contents_opacity]
  end
  def hide
    @scene_hash[@scene_actuel][:window][@window_actuel][:hide]
  end
  def windowskin
    @scene_hash[@scene_actuel][:window][@window_actuel][:windowskin]
  end
  def tone
    @scene_hash[@scene_actuel][:window][@window_actuel][:tone]
  end
  def commande
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande]
  end
  def variable
    @scene_hash[@scene_actuel][:window][@window_actuel][:variable].clone
  end
  
  def variable_new(name,type)
    @scene_hash[@scene_actuel][:window][@window_actuel][:variable][name] = type
  end
  
  def delete_variable(name)
    @scene_hash[@scene_actuel][:window][@window_actuel][:variable].delete(name.to_sym)
  end
  
  ##############################################################################
  #GESTION FONCTION WINDOW                                                     #
  ##############################################################################
  
  def fonction_new(name,description)
    if take_fonction_list.include?(name.to_sym)
      msgbox("Cette Fonction existe déjà.")
      return false
    else
      fonction = {:name => name ,:commande_list => [],:description => description}
      @scene_hash[@scene_actuel][:window][@window_actuel][:commande].push(fonction)
      return true
    end
  end
  
  def supprimer_fonction(index)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande].delete_at(index)
  end
  
  def fonction_name
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:name]
  end
  def fonction_command
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:commande_list]
  end
  def fonction_description
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:description]
  end
  
  def fonction_name=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:name] = value
  end
  def fonction_command=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:commande_list] = value
  end
  def fonction_description=(value)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:description] = value
  end
  
  def take_fonction_list
    data = []
    for i in 0..commande.length-1
      data.push(commande[i][:name])
    end
    return data
  end
  
  ##############################################################################
  #GESTION COMMANDE WINDOW                                                     #
  ##############################################################################
  
  def commande_new(fonc)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:commande_list].push(fonc)
    return true
  end
  
  def commande_insert(fonc,index)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:commande_list].insert(index,fonc)
    return true
  end
  
  def supprimer_commande(index)
    @scene_hash[@scene_actuel][:window][@window_actuel][:commande][@fonction_actuel][:commande_list].delete_at(index)
  end
  
  def take_commande_list
    data = []
    for i in 0..commande.length-1
      data.push(commande[i][:name])
    end
    return data
  end
  
  def take_variable_list(type = :all)
    case type
    when :all;
      variable.keys.sort!
    when :int;
      result = []
      variable.each do |key, value|
        result.push(key) if value == "Int"
      end
      result.sort!
    when :str;
      result = []
      variable.each do |key, value|
        result.push(key) if value == "Str"
      end
      result.sort!
    when :arr;
      result = []
      variable.each do |key, value|
        result.push(key) if value == "Arr"
      end
      result.sort!
    end
  end
  
  
end
class Scene_Base
  alias update_scene_editeur update
  def update
    DataManager.save_editor_file if Input.trigger?(:F5)
    update_scene_editeur
  end
end
################################################################################
# CREATION FICHIER SAVE EDITOR
################################################################################
module DataManager
  class << self
    alias :create_game_objects_scene_editor :create_game_objects
    def create_game_objects
      create_game_objects_scene_editor 
      $game_editor      = Game_Scene_Editor.new if $game_editor == nil
    end
    alias :load_normal_database_scene_editor :load_normal_database
    def load_normal_database
      load_normal_database_scene_editor
      puts "Load ok"
      $game_editor      = load_data("Data/Scene_Editor.rvdata2") if FileTest.exist?("Data/Scene_Editor.rvdata2")
    end
  end
  
  #-------------- ------------------------------------------------------------
  # * Execute Save
  #--------------------------------------------------------------------------
  def self.save_editor_file
    File.open("Data/Scene_Editor.rvdata2","w") do |file|
      puts "Saving OK"
      Marshal.dump($game_editor, file)
    end
  end
end

module Vincent_26_Scene_Editor_Console
    class REPL
      attr_accessor :running
      TEMP_PATH = "#{ENV["TEMP"]}\\temp-alex"
      INDENT_SPACES = 2
      INDENT_FIRST = %w[def class module while until begin if unless]
      INDENT_LAST = %w[do]
      def initialize
        @running = false
        @temp_file = File.new(TEMP_PATH, "w")
      end
      def start(context)
        @running = true
        loop do
          puts "Pour annuler entrer : @exit"
          print "Texte :"
          input = get_input_until_valid
          if input == "@exit"
            @input = input
            puts "Exit OK"
            @running = false
            break
          end
          begin
            @running = false
            @input = input
            break
          end
        end
        return @input
      end
      def get_input_until_valid
        buffer = ""
        indent = ""
        loop do
          line = gets
          buffer << line
          break if is_valid_syntax?(buffer)
          print "Texte :"
          #if increases_indent_level?(line)
          #  indent.concat(" " * INDENT_SPACES)
          #  print indent
          #elsif decreases_indent_level?(line)
          #  indent[-INDENT_SPACES..-1] = ""
          #  print indent
          #else
            print indent
          #end
        end
        buffer.chomp
      end
      def is_valid_syntax?(string)
        begin
          begin
            surpress_stdout { eval(string) }
            rescue SyntaxError
            return false
          end
          rescue Exception
        end
        true
      end
      def surpress_stdout
        stdout_orig = $stdout
        $stdout = @temp_file
        begin
          yield
          ensure
          $stdout = stdout_orig
        end
      end
      def increases_indent_level?(input)
        first_token = input[/\A([\w\d]+?)\s/, 1]
        last_token = input.chomp[/[\w\d]+\z/]
        result_first = first_token && INDENT_FIRST.include?(first_token)
        result_last = last_token && INDENT_LAST.include?(last_token)
        result_first || result_last
      end
      def decreases_indent_level?(input)
        last_token = input.chomp[/[\w\d]+\z/]
        last_token == "end"
      end
      @@instance = REPL.new
      def self.instance
        @@instance
      end
      private_class_method :new
    end
end
