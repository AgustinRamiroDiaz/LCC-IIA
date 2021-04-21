---
title: Admisibilidad y Consistencia de la Heurística
authors: Aldana Zárate y Agustín Díaz
---

<style>
body {
text-align: justify}
</style>

En este trabajo se presenta como posible heurística utilizar el mínimo camino posible para garrar cada una de las frutas (nos inspiramos en el conocido problema *TSP*, *Travelling Salesman Problem*).

$$h(N) := \text{longitud del camino más corto desde N que pasa por todas las frutas}$$

El algoritmo es explicado [aquí](https://www.youtube.com/watch?v=XaXsJJh-Q5Y)

Esta heurística es usada tanto en el *cornersProblem* como en *foodProblem* (solo se manipulan los states de manera de poder tener la posición del pacman y las coordenadas de las frutas) ya que al calcular los caminos mínimos para recorrerlas, resulta indiferente la ubicación en la que estén las frutas.

##### Explicación de admisibilidad

La función de nuestra heurística, al devolver el mínimo camino posible desde la pacman hacia cada una de las frutas (midiendo las distancias como distancias de manhattan),  siempre retorna un número que no subestima el camino más corto desde el estado a la meta del problema, ya que en la realidad el pacman tiene varias limitaciones como ser paredes y otros obstáculos que hacen que el camino para llegar a la meta sea más largo. Además, en el caso de que no tuviera dichos obstáculos, nuestra función devuelve el camino más corto así que en el peor caso, sería igual.
$\therefore$ La heurística es admisible.



##### Demostración de consistencia

Recordamos la definición de heurística consistente, tenemos que ver que: 
$$h(N) <= c(N,S) + h(S)$$ donde h es la función heurística, N es un nodo del grafo, S es un sucesor de N y c(N,S) es el costo de ir desde N a S.

El costo de llegar del nodo N a un sucesor S es c(N, S) = 1 dado que consideramos el costo del camino como su longitud (sin tener en cuenta fantasmas ni premios intermedios). Con lo cual demostrar consistencia será equivalente a verificar
$$h(N) <= h(S) + 1 \tag{$\alpha$}$$


Demostremos por el absurdo, suponiendo que existen N y S (S sucesor de N) tales que 
$$h(N) > h(S) + 1$$
Eso significaría que desde N el camino más corto que recoge todas las frutas es más largo que pasar por S y luego recorrer el camino más corto desde S.
Lo cual es contradictorio ya que entonces el camino más corto desde N sería pasando por S y luego el camino más corto desde S. Esta contradicción parte de suponer h(N) > h(S) + 1 y por lo tanto concluimos $\alpha$


$\therefore$ La heurística es consistente (monótona).

Nota: dejamos un assert en la función de búsqueda A* donde se verifica efectivamente la monotonía en cada paso.
