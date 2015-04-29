#~ class Execute_Custom_Scene_Manager
#~   
#~   attr_reader :scene
#~   attr_reader :window_list
#~   
#~   
#~   ################
#~   # Initialisation
#~   def initialize
#~     @scene_actuel = nil
#~     @window_actuel = nil
#~     @commande_actuel = nil
#~     @fonction_actuel = nil
#~     @commande_actuel = nil
#~     @coordonnée_type = 0
#~     @scene_hash = {}
#~     @scene = {}
#~     @window_list = {}
#~   end
#~   
#~   def call(scene)
#~     @scene = @scene_hash[scene].clone
#~     @window_list = @scene[:window].clone
#~     SceneManager.call(Scene_Custom)
#~   end
#~   
#~   
#~   
#~   
#~ end
#~ #╔═════════════════════════════════════════════════════════════════════════════╗
#~ #║    Scene_Editor_Start              Menu Start                               ║
#~ #║    Creation/Modification/Suppression de scene                               ║
#~ #╚═════════════════════════════════════════════════════════════════════════════╝
#~ class Scene_Custom < Scene_Base
#~   #--------------------------------------------------------------------------
#~   # * Start Processing
#~   #--------------------------------------------------------------------------
#~   def start
#~     super
#~     @scene = $game_custom_scene.scene
#~     @window = $game_custom_scene.window_list
#~     create_background
#~     create_window
#~     create_command_window
#~     create_description_window
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Termination Processing 
#~   #--------------------------------------------------------------------------
#~   def terminate
#~     super
#~     dispose_background
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Free Background
#~   #--------------------------------------------------------------------------
#~   def dispose_background
#~     @background_sprite.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Create Background
#~   #--------------------------------------------------------------------------
#~   def create_background
#~     @back = @scene[:back]
#~     @background_sprite = Sprite.new
#~     if @back == "0"
#~       @background_sprite.bitmap = SceneManager.background_bitmap
#~       @background_sprite.color.set(16, 16, 16, 128)
#~     else
#~       @background_sprite.bitmap = Cache.picture(@back).clone
#~       @background_sprite.bitmap.blur
#~       @background_sprite.color.set(16, 16, 16, 128)
#~     end
#~   end
#~   
#~   def create_window
#~     @window_array = {}
#~     @window.each do |key,value|
#~       case value[:type]
#~       when "normal";
#~         @window_array[key] = Window_Custom_Normal.new(value)
#~       when "selecteur";
#~         @window_array[key] = Window_Custom_Selecteur.new(value)
#~       when "commande";
#~         @window_array[key] = Window_Custom_Commande.new(value)
#~       when "commande hor";
#~         @window_array[key] = Window_Custom_Commande_Hor.new(value)
#~       end
#~     end
#~   end
#~   
#~   def update
#~     super
#~   end
#~ end
#~ ################################################################################
#~ #          NORMAL  WINDOW                                                      #
#~ ################################################################################
#~ class Window_Custom_Normal  < Window_Base
#~   def initialize(param)
#~     @x = param[:x]
#~     @y = param[:y]
#~     @z = param[:z]
#~     @h = param[:h]
#~     @w = param[:w]
#~     @back_opacity = param[:back_opacity]
#~     @window_opacity = param[:window_opacity]
#~     @contents_opacity = param[:contents_opacity]
#~     @hide = param[:hide]
#~     @windowskin = param[:windowskin]
#~     @tone = param[:tone]
#~     @commande = param[:commande]
#~     @variable = param[:variable]
#~     super(@x,@y,@w,@h)
#~     self.windowskin = Cache.system(@windowskin) if @windowskin
#~     self.active = false
#~     self.visible = @hide
#~     self.z = @z
#~     self.opacity = @window_opacity
#~     self.back_opacity = @back_opacity
#~     self.contents_opacity = @contents_opacity
#~     self.tone = @tone
#~   end
#~ end
#~ ################################################################################
#~ #          SELECTEUR  WINDOW                                                   #
#~ ################################################################################
#~ class Window_Custom_Selecteur < Window_Selectable
#~   def initialize(param)
#~     @x = param[:x]
#~     @y = param[:y]
#~     @z = param[:z]
#~     @h = param[:h]
#~     @w = param[:w]
#~     @back_opacity = param[:back_opacity]
#~     @window_opacity = param[:window_opacity]
#~     @contents_opacity = param[:contents_opacity]
#~     @hide = param[:hide]
#~     @windowskin = param[:windowskin]
#~     @tone = param[:tone]
#~     @commande = param[:commande]
#~     @variable = param[:variable]
#~     super(@x,@y,@w,@h)
#~     self.windowskin = Cache.system(@windowskin) if @windowskin
#~     self.active = false
#~     self.visible = @hide
#~     self.z = @z
#~     self.opacity = @window_opacity
#~     self.back_opacity = @back_opacity
#~     self.contents_opacity = @contents_opacity
#~     self.tone = @tone
#~   end
#~   def col_max
#~     return 1
#~   end
#~   def item_max
#~     @data ? @data.size : 1
#~   end
#~   def item
#~     @data && index >= 0 ? @data[index] : nil
#~   end
#~   def make_item_list
#~     @data = []
#~   end
#~   def draw_item(index)
#~     rect = item_rect(index)
#~     draw_text(rect.x, rect.y, rect.width,rect.height,@data[index])
#~   end
#~   def refresh
#~     make_item_list
#~     create_contents
#~     draw_all_items
#~   end
#~ end
#~ ################################################################################
#~ #          COMMANDE WINDOW                                                     #
#~ ################################################################################
#~ class Window_Custom_Commande < Window_Command
#~   def initialize(param)
#~     @x = param[:x]
#~     @y = param[:y]
#~     @z = param[:z]
#~     @h = param[:h]
#~     @w = param[:w]
#~     @back_opacity = param[:back_opacity]
#~     @window_opacity = param[:window_opacity]
#~     @contents_opacity = param[:contents_opacity]
#~     @hide = param[:hide]
#~     @windowskin = param[:windowskin]
#~     @tone = param[:tone]
#~     @commande = param[:commande]
#~     @variable = param[:variable]
#~     super(@x,@y)
#~     self.windowskin = Cache.system(@windowskin) if @windowskin
#~     self.active = false
#~     self.visible = @hide
#~     self.z = @z
#~     self.opacity = @window_opacity
#~     self.back_opacity = @back_opacity
#~     self.contents_opacity = @contents_opacity
#~     self.tone = @tone
#~   end
#~   def window_width
#~     return @w
#~   end
#~   def make_command_list
#~     add_command("SE",      :SE,        true)
#~   end
#~ end
#~ ################################################################################
#~ #          HOR COMMANDE WINDOW                                                 #
#~ ################################################################################
#~ class Window_Custom_Commande_Hor < Window_Command_Hor
#~   def initialize(param)
#~     @x = param[:x]
#~     @y = param[:y]
#~     @z = param[:z]
#~     @h = param[:h]
#~     @w = param[:w]
#~     @back_opacity = param[:back_opacity]
#~     @window_opacity = param[:window_opacity]
#~     @contents_opacity = param[:contents_opacity]
#~     @hide = param[:hide]
#~     @windowskin = param[:windowskin]
#~     @tone = param[:tone]
#~     @commande = param[:commande]
#~     @variable = param[:variable]
#~     super(@x,@y)
#~     self.windowskin = Cache.system(@windowskin) if @windowskin
#~     self.active = false
#~     self.visible = @hide
#~     self.z = @z
#~     self.opacity = @window_opacity
#~     self.back_opacity = @back_opacity
#~     self.contents_opacity = @contents_opacity
#~     self.tone = @tone
#~   end
#~   def window_width
#~     return @w
#~   end
#~   def make_command_list
#~     add_command("SE",      :SE,        true)
#~   end
#~ end
#~ ################################################################################
#~ # CREATION FICHIER SAVE EDITOR
#~ ################################################################################
#~ module DataManager
#~   class << self
#~     alias :create_game_objects_scene_custom :create_game_objects
#~     def create_game_objects
#~       create_game_objects_scene_custom 
#~       $game_custom_scene      = Execute_Custom_Scene_Manager.new
#~     end
#~     alias :load_normal_database_scene_custom :load_normal_database
#~     def load_normal_database
#~       load_normal_database_scene_custom
#~       puts "Load ok"
#~       $game_custom_scene      = load_data("Data/Scene_Editor.rvdata2") if FileTest.exist?("Data/Scene_Editor.rvdata2")
#~     end
#~   end
#~   
#~ end
