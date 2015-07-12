################################################################################
#                   FAST_EVENT BY VINCENT_26                                   #
################################################################################
=begin
Crédit : Vincent_26
Version 1.0

Ce script permet de creer des raccourci d'event ou de creer des events 
identiques avec un seul events comportant la programation de tous les events

Utilisation :
Il vous faut creer une map contenant les diverse event parent et renseigner ci-
après l'id de cette map
ensuite :
2 Cas possiblies :

Si vous voulez une copie simple d'un event metter juste dans ça première page un
Commantaire contenant ceux-ci :
    Be : NOM
Ou NOM est le nom de l'event a copier (de base par exemple : EV001)

Si vous voulez integrer la prog d'un event dans un autre metter a l'emplacement 
ou vous voulez l'ajouter un commentaire contenant ceux_ci :
    Call : NOM
Ou NOM est le nom de l'event a copier
################################################################################
Contact : zeludtnecniv@gmail.com

          http://www.rpgmakervx-fr.com/t18482-fast_events_making#211353
   
=end
module FAST_EVENT
  #map contenant les events :
  ID_MAP = 5
end

$map_event_rapide = load_data(sprintf("Data/Map%03d.rvdata2", FAST_EVENT::ID_MAP))
class Game_Event
  
  alias initialize_vincent_26 initialize
  def initialize(map_id, event)
    if event.pages[0].list[0].code == 108
      if event.pages[0].list[0].parameters[0] =~ /Be :/
        name =  event.pages[0].list[0].parameters[0][5..-1]
        $map_event_rapide.events.each do |id , ev|
          if ev.name == name
            @event = ev
            @event.x = event.x
            @event.y = event.y
            @event.id = event.id
            @event.name = event.name
            break
          end
        end
      else
        @event = event
      end
    else
      @event = event
    end
    initialize_vincent_26(map_id,@event)
  end
  
  alias setup_page_settings_vincent_26 setup_page_settings
  def setup_page_settings
    setup_page_settings_vincent_26
    @list               = @page.list
    @list = []
    indent = 0
    for com in @page.list
      if com.code == 108
        if com.parameters[0] =~ /Call :/
          indent = com.indent
          name = com.parameters[0][7..-1]
          @list2 = []
          $map_event_rapide.events.each do |id , ev|
            if ev.name == name
              @list2 = ev.pages[0].list
              break
            end
          end
          for co in @list2
            co.indent += indent
            @list.push(co)
          end
        else
          indent = com.indent
          @list.push(com)
        end
      else
        @list.push(com)
      end
    end
  end
end
