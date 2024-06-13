import osmnx as ox
import folium
import random
import numpy as np
import time

# Fonction pour trouver un itinéraire entre deux points en passant par des points de passage
def find_route(graph, start, waypoints, end):
    route = []
    previous_node = start
    
    # Itérer sur les waypoints et trouver le chemin entre chaque paire de points consécutifs
    for waypoint in waypoints:
        route_segment = ox.shortest_path(graph, previous_node, waypoint, weight='length')
        if route_segment:
            route.extend(route_segment[:-1])
            previous_node = waypoint
        else:
            print(f"Impossible de trouver un chemin entre {previous_node} et {waypoint}.")
            return None
    
    # Trouver le dernier segment de chemin entre le dernier waypoint et le point final
    route_segment = ox.shortest_path(graph, previous_node, end, weight='length')
    if route_segment:
        route.extend(route_segment)
    else:
        print(f"Impossible de trouver un chemin entre le dernier waypoint {previous_node} et le point final {end}.")
        return None
    
    return route

# Fonction pour calculer la distance totale du chemin
def calculate_distance(route, graph):
    if route is None:
        return float('inf')  # Retourner une distance infinie si aucun chemin n'a été trouvé
    total_distance = 0
    for i in range(len(route) - 1):
        node1 = route[i]
        node2 = route[i + 1]
        # Ajouter la longueur de chaque segment au total
        total_distance += graph[node1][node2][0]['length']
    return total_distance 
# Algorithme de recuit simulé
# Algorithme de recuit simulé
def simulated_annealing(graph, start, end, target_distance, initial_temperature=1000, cooling_rate=0.995, max_time=300):
    start_time = time.time()
    waypoints = generate_waypoints(graph, start, end)
    current_route = find_route(graph, start, waypoints, end)
    current_distance = calculate_distance(current_route, graph)  # Correction de cette ligne
    
    best_route = current_route
    best_distance = current_distance
    
    temperature = initial_temperature
    
    while time.time() - start_time < max_time:
        new_waypoints = generate_waypoints(graph, start, end)
        new_route = find_route(graph, start, new_waypoints, end)
        new_distance = calculate_distance(new_route, graph)
        
        if abs(new_distance - target_distance) < abs(best_distance - target_distance):
            best_route = new_route
            best_distance = new_distance
        else:
            probability = np.exp(-(new_distance - current_distance) / temperature)
            if random.uniform(0, 1) < probability:
                current_route = new_route
                current_distance = new_distance
        
        temperature *= cooling_rate
    
    return best_route, best_distance

# Fonction pour tracer le chemin sur une carte
def plot_route_on_map(route, graph):
    route_map = folium.Map(location=(graph.nodes[route[0]]['y'], graph.nodes[route[0]]['x']), zoom_start=14)
    route_coordinates = [(graph.nodes[node]['y'], graph.nodes[node]['x']) for node in route]
    folium.PolyLine(locations=route_coordinates, color='blue').add_to(route_map)
    return route_map

# Coordonnées de Paris La Défense Arena et l'arrivée de la dernière étape du Tour de France
paris_la_defense_arena = (48.8966, 2.2345)
tour_de_france_finish = (48.8738, 2.2950)

# Cible de distance en km
target_distance = 100 * 1000  # Distance cible en mètres

# Créer un graphe de rue couvrant une zone suffisamment grande pour inclure les deux points
center_point = ((paris_la_defense_arena[0] + tour_de_france_finish[0]) / 2, (paris_la_defense_arena[1] + tour_de_france_finish[1]) / 2)
distance = 15000  # Distance en mètres pour couvrir suffisamment de routes entre les points
graph = ox.graph_from_point(center_point, dist=distance, network_type='drive')

# Générer des points de passage aléatoires autour du centre, en s'assurant qu'ils sont éloignés des points de départ et d'arrivée
def generate_waypoints(graph, start, end, num_waypoints=5, min_distance=5000, max_distance=10000):
    waypoints = []
    while len(waypoints) < num_waypoints:
        angle = random.uniform(0, 2 * np.pi)
        distance = random.uniform(min_distance, max_distance)
        lat_offset = distance * np.cos(angle) / 111320  # Approximation pour latitude (1 deg ≈ 111.32 km)
        lon_offset = distance * np.sin(angle) / (40075000 * np.cos(np.radians(center_point[0])) / 360)  # Approximation pour longitude
        new_point = (center_point[0] + lat_offset, center_point[1] + lon_offset)
        new_node = ox.distance.nearest_nodes(graph, new_point[1], new_point[0])
        if new_node is not None and new_node not in waypoints:
            waypoints.append(new_node)
    return waypoints

# Trouver les nœuds les plus proches des points de départ et d'arrivée
start_node = ox.distance.nearest_nodes(graph, paris_la_defense_arena[1], paris_la_defense_arena[0])
end_node = ox.distance.nearest_nodes(graph, tour_de_france_finish[1], tour_de_france_finish[0])

# Trouver le meilleur chemin en utilisant le recuit simulé
best_route, best_distance = simulated_annealing(graph, start_node, end_node, target_distance)

# Tracer le chemin sur une carte
map = plot_route_on_map(best_route, graph)
map.save("paris_tdf_route.html")

print(f"Final path length: {best_distance / 1000} km")