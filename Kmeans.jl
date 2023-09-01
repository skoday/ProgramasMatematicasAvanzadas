using Random
using Statistics

# Definimos una estructura de datos para representar un punto 2D
struct Point
    x::Float64
    y::Float64
end

# Función para calcular la distancia euclidiana entre dos puntos
function distance(p1::Point, p2::Point)
    return sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)
end

# Función para generar puntos aleatorios en el plano 2D
function generate_points(num_points::Int)
    points = [Point(rand(), rand()) for _ in 1:num_points]
    return points
end

# ... (Código anterior) ...

# Función para implementar el algoritmo K-Means con límite máximo de iteraciones
function kmeans(points::Vector{Point}, k::Int, max_iterations::Int, stop_with_tolerance::Bool=false, tolerance::Float64=0.001)
    centroids = [Point(rand(), rand()) for _ in 1:k]
    groups = Dict{Int, Vector{Point}}() 
    
    for iteration in 1:max_iterations
        groups = Dict{Int, Vector{Point}}()
        
        for point in points
            min_dist = Inf
            closest_centroid_idx = 0
            
            for (i, centroid) in enumerate(centroids)
                dist = distance(point, centroid)
                if dist < min_dist
                    min_dist = dist
                    closest_centroid_idx = i
                end
            end
            
            if !haskey(groups, closest_centroid_idx)
                groups[closest_centroid_idx] = [point]
            else
                push!(groups[closest_centroid_idx], point)
            end
        end
        
        new_centroids = [Point(mean([p.x for p in group]), mean([p.y for p in group])) for group in values(groups)]
        max_centroid_change = maximum([distance(centroids[i], new_centroids[i]) for i in 1:k])
        centroids = new_centroids
        
        if stop_with_tolerance && max_centroid_change < tolerance
            break
        end
    end
    
    return centroids, groups
end

# Ejemplo de uso:
num_points = 100
k = 3
max_iterations = 100  # Límite máximo de iteraciones
points = generate_points(num_points)
centroids, groups = kmeans(points, k, max_iterations, true)

# Imprimir los resultados
for (i, centroid) in enumerate(centroids)
    println("Centroide $i: x = $(centroid.x), y = $(centroid.y)")
    println("Puntos en el grupo $i:")
    for point in groups[i]
        println("  x = $(point.x), y = $(point.y)")
    end
end
