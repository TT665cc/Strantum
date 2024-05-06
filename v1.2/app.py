
import toga
from toga.style import Pack
from toga.style.pack import COLUMN, ROW
from toga.style.pack import BOLD
import folium
from pyroutelib3 import Router
import requests
import os

color = toga.colors.rgb(212, 218, 220)

def meteo(c):
    latitude, longitude = c
    base_url = "https://api.openweathermap.org/data/2.5/weather"
    params = {
        "lat": latitude,
        "lon": longitude,
        "appid": "1c0335d4b300e187cb7017cffe01f6e1",
        "units": "metric"  # Utilisez "imperial" pour les unités impériales
    }
    response = requests.get(base_url, params=params)
    data = response.json()
    return data

def itineraire(Depart, Arrivee, mode):
    """
    génère une carte représentant un itinéraire avec :
    Depart : coordonnées GPS du point de départ
    Arrivee : coordonnées GPS du point d'arrivée
    mode : mode de transport ("car","cycle","foot","horse","tram","train")
    """

    # Calcul des coordonnées du point central de la carte
    # (au milieu du segment joignant Depart et Arrivee)

    Vue = ((Depart[0] + Arrivee[0]) / 2, (Depart[1] + Arrivee[1]) / 2)

    # Réglage du zoom initial
    zoom = 15

    # Génération de la carte
    Carte = folium.Map(Vue, tiles="Cartodb Positron", zoom_start=zoom)

    # Placement des marqueurs des points de Départ et d'Arrivée
    folium.Marker(Depart, popup="Départ").add_to(Carte)
    folium.Marker(Arrivee, popup="Arrivée").add_to(Carte)

    try:
        # Génération de l'itinéraire avec le mode de transport choisi
        router = Router(mode)
        D = router.findNode(*Depart)
        A = router.findNode(*Arrivee)

        routeLatLons = [Depart, Arrivee]
        status, route = router.doRoute(D, A)
        print(status)
        print(route)
        if status == 'success':
            routeLatLons = list(map(router.nodeLatLon, route))
            print(routeLatLons)

        # Tracé de l'itinéraire sur la carte
        folium.PolyLine(routeLatLons, color="magenta", weight=2.5, opacity=1).add_to(Carte)

    except:
        # Si l'itinéraire ne peut pas être généré: affichage d'un message d'erreur
        print("La carte a été créée mais impossible de générer l'itinéraire demandé")

    # La fonction renvoie la carte créée
    return routeLatLons, Carte

class ParcousPage(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))

        self.input_box = toga.Box(style=Pack(direction=ROW, padding=(15,5,5)))
        self.input_box.style.background_color = color

        self.depart_input = toga.TextInput(style=Pack())
        self.depart_input_text = toga.Label("Départ:", style=Pack(padding=(4,5,1),font_family="Square",background_color = color))

        self.arrivee_input = toga.TextInput(style=Pack())
        self.arrivee_input_text = toga.Label("Arrivée:", style=Pack(padding=(4,5,1),font_family="Square",background_color = color))

        self.distance_input = toga.NumberInput()
        self.distance_input_text = toga.Label("Distance souhaitée:", style=Pack(padding=(4,5,1),font_family="Square",background_color = color))

        self.input_box.add(self.depart_input_text)
        self.input_box.add(self.depart_input)
        self.input_box.add(self.arrivee_input_text)
        self.input_box.add(self.arrivee_input)
        self.input_box.add(self.distance_input_text)
        self.input_box.add(self.distance_input)

        button = toga.Button(
            "C'est parti !",
            on_press=self.new_itineraire,
            style=Pack(padding=5, font_family="Square",background_color = color)
        )

        self.input_box.add(button)


        main_box.add(self.input_box)
        main_box.style.background_color = color
        
        ma_carte = folium.Map([48.121348, -1.654567], tiles="Cartodb Positron", zoom_start=3)
        
        # Convertir la carte Folium en HTML
        self.carte_html = ma_carte.get_root().render()

        # Créer un WebView pour afficher la carte Folium
        self.webview = toga.WebView(style=Pack(direction=COLUMN, flex=1, padding=(10,10,10)))
        self.webview.set_content('www.example.com',self.carte_html)
        
        main_box.add(self.webview)

        self.second_page_window = toga.MainWindow(title="Second Page")
        self.second_page_window.content = main_box
        self.second_page_window.show()

    def new_itineraire(self, widget):
        if self.depart_input.value != "" and self.arrivee_input.value != "":
            dep_str, ar_str = self.depart_input.value.strip("()").split(","), self.arrivee_input.value.strip("()").split(",")   
            dep = [float(dep_str[0]), float(dep_str[1])]
            ar = [float(ar_str[0]), float(ar_str[1])]
            list_pt, carte = itineraire(dep, ar, "car")
            self.carte_html = carte.get_root().render()
            self.webview.set_content('www.example.com', self.carte_html)  # Refresh WebView content
        else:
            self.second_page_window.info_dialog(
                "Strantum a un problème",
                "Les positions de départs et d'arrivées sont des couples de flottants. Par exemple: (48.121348, -1.654567) et (48.115176, -1.679909). De plus veuillez attedre et ne pas spam-clic, l'api met du temps à répondre."
            )


class SecondPage(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))

        self.input_box = toga.Box(style=Pack(direction=ROW, padding=(15,5,5)))
        self.input_box.style.background_color = color

        self.depart_input = toga.TextInput(style=Pack())
        self.depart_input_text = toga.Label("Départ:", style=Pack(padding=(4,5,1),font_family="Square",background_color = color))

        self.arrivee_input = toga.TextInput(style=Pack())
        self.arrivee_input_text = toga.Label("Arrivée:", style=Pack(padding=(4,5,1),font_family="Square",background_color = color))

        self.input_box.add(self.depart_input_text)
        self.input_box.add(self.depart_input)
        self.input_box.add(self.arrivee_input_text)
        self.input_box.add(self.arrivee_input)

        button = toga.Button(
            "C'est parti !",
            on_press=self.new_itineraire,
            style=Pack(padding=5, font_family="Square",background_color = color)
        )

        self.input_box.add(button)


        main_box.add(self.input_box)
        main_box.style.background_color = color
        
        ma_carte = folium.Map([48.121348, -1.654567], tiles="Cartodb Positron", zoom_start=3)
        
        # Convertir la carte Folium en HTML
        self.carte_html = ma_carte.get_root().render()

        # Créer un WebView pour afficher la carte Folium
        self.webview = toga.WebView(style=Pack(direction=COLUMN, flex=1, padding=(10,10,10)))
        self.webview.set_content('www.example.com',self.carte_html)
        
        main_box.add(self.webview)

        self.second_page_window = toga.MainWindow(title="Second Page")
        self.second_page_window.content = main_box
        self.second_page_window.show()

    def new_itineraire(self, widget):
        if self.depart_input.value != "" and self.arrivee_input.value != "":
            dep_str, ar_str = self.depart_input.value.strip("()").split(","), self.arrivee_input.value.strip("()").split(",")   
            dep = [float(dep_str[0]), float(dep_str[1])]
            ar = [float(ar_str[0]), float(ar_str[1])]
            list_pt, carte = itineraire(dep, ar, "car")
            self.carte_html = carte.get_root().render()
            self.webview.set_content('www.example.com', self.carte_html)  # Refresh WebView content
        else:
            self.second_page_window.info_dialog(
                "ARRETES DE FAIRE N'IMPORTE QUOI",
                "Les positions de départs et d'arrivées sont des couples de flottants FDP"
            )

class Meteo(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))
        input_box = toga.Box(style=Pack(direction=ROW))
        input_text = toga.Label("Coordonnées:", style=Pack(padding=(30,30,30), font_family="Square"))
        self.input = toga.TextInput(style=Pack(padding=(30,30,30)))

        input_box.add(input_text)
        input_box.add(self.input)

        button = toga.Button(
            "Regarder la météo!",
            on_press=self.print_meteo,
            style=Pack(padding=(30,30,30), font_family="Square",background_color = color)
        )

        input_box.add(button)

        main_box.add(input_box)
        self.meteo_window = toga.MainWindow(title="Météo")
        self.meteo_window.content = main_box
        self.meteo_window.show()
    
    def print_meteo(self, widget):
        if self.input.value != "":
            str = self.input.value.strip("()").split(",")
            c = (float(str[0]), float(str[1]))
            m = meteo(c) 
            self.meteo_window.info_dialog(
                "Bulletin météo",
                f"Aux coordonnées{c}, le temps est {m['weather'][0]['main']}. Le ciel est {m['weather'][0]['description']}. La température est de {m['main']['temp']}°C. Cependant, la pression étant de {m['main']['pressure']}Pa, l'humidité de {m['main']['humidity']}% et le vent souflant à {m['wind']['speed']}km/h et faisant un angle de {m['wind']['deg']}° avec le méridien local, la température ressenti est de {m['main']['feels_like']}°C."
            )
        else:
            self.meteo_window.info_dialog(
                "Strantum a un problème",
                "Veuillez rentrer un couple de nombre flottant, par exemple: (48.121348, -1.654567) pour avoir la météo à Maurepas"
            )

class Contact(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))

        instructions = toga.Label("Pour nous contacter, tenez 2min. Bonne chance ! (Cliquez sur le carré rouge)", style=Pack(font_size=15))
        main_box.add(instructions)
        webview = toga.WebView(style=Pack(direction=COLUMN, flex=1, padding=(10,10,10)))
        webview.url = "http://jolouvet.free.fr/fichiers/jeucarre.htm"
        main_box.add(webview)

        self.contact_page_window = toga.MainWindow(title=self.formal_name)
        self.contact_page_window.content = main_box
        self.contact_page_window.show()

class GPX(toga.App):
    def startup(self):
        main_box = toga.Box()

        image = toga.ImageView("C:/Users/jpand/Desktop/test_multi_page/helloworld/src/helloworld/resources/unavailable.jpg")
        main_box.add(image)

        self.gpx_page_window = toga.MainWindow(title="Second Page")
        self.gpx_page_window.content = main_box
        self.gpx_page_window.show()

class HelloWorld(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))
        toga.Font.register("Square", "resources/Square.ttf")
        new_itineraire_button = toga.Button('Nouvel itinéraire', on_press=self.go_to_second_page, style=Pack(padding=(30,60,30),font_family="Square",background_color = color))
        main_box.add(new_itineraire_button)
        new_parcours_button = toga.Button('Nouveau parcourt', on_press=self.go_to_parcours_page, style=Pack(padding=(30,60,30),font_family="Square",background_color = color))
        main_box.add(new_parcours_button)
        new_gpx_button = toga.Button('Etudier fichier GPX', on_press=self.go_to_gpx_page, style=Pack(padding=(30,60,30),font_family="Square",background_color = color))
        main_box.add(new_gpx_button)
        meteo_button = toga.Button('Météo', on_press=self.go_to_meteo_page, style=Pack(padding=(30,60,30),font_family="Square",background_color = color))
        main_box.add(meteo_button)
        saving_parcourt_button = toga.Button('Contactez-nous', on_press=self.go_to_contact_page, style=Pack(padding=(30,60,30),font_family="Square",background_color = color))
        main_box.add(saving_parcourt_button)
        

        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

    def go_to_second_page(self, widget):
        second_page = SecondPage()
        second_page.startup()

    def go_to_contact_page(self, widget):
        contact_page = Contact()
        contact_page.startup()
    
    def go_to_parcours_page(self, widget):
        parcours_page = ParcousPage()
        parcours_page.startup()
    
    def go_to_gpx_page(self, widget):
        gpx_page = GPX()
        gpx_page.startup()

    def go_to_meteo_page(self, widget):
        meteo_page = Meteo()
        meteo_page.startup()

def main():
    return HelloWorld()
