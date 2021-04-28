"""
1.
    a.
        [
            [1, 2, 3],
            [8, 0, 4],
            [7, 6, 5]
        ]

        Posición del espacio en blanco (i, j)

        La matriz pertenece a {0-8}^(3x3)


        estado incial: [
            [2, 8, 3],
            [1, 6, 4],
            [7, 0, 5]
        ]

        (3, 2)

        mover-derecha: 
            (i, j) con j < 3 => (i, j+1)
            M(i, j) => M(i, j+1)
            M(i, j+1) => M(i, j)

        mover-izquierda:
            análogo con -1

    
    b.
        3 pilas
        Cada pila tiene los tamaños de los discos en 
        orden ascendente

        [
            [64, 63, ..., 2, 1],
            [],
            []
        ]

        Estados finales:
        [
            [],
            [64, 63, ..., 2, 1],
            []
        ] o
        [
            [],
            [],
            [64, 63, ..., 2, 1]
        ]

        mover-disco: 
            (pila-origen, pila-destino) 
            con pila-origen.last() < pila-destino.last() => 
            push (pop (pila-origen), pila-destino)

    c.
        M = {1, 2, 3}^(3x3)

        Estado inicial: matriz vacía

        escribir:
            (i, j, valor) tal que
            valor in {1, 2, 3}
            valor != M(i, k) forall k
            valor != M(k, j) forall k
            i, j in {1, 2, 3}
                => M(i, j)

        Estados finales:
            M sin espacios vacíos
            Será necesario agregar las condiciones?
            Si siempre usamos escribir, nunca llegaríamos a un error

2. 
    búsqueda_general():
        nodos :: lista
        nodos <- estado inicial
        bucle:
            si nodos es vacío:
                retornar Falla

            nodo <- head(nodos)
            nodos <- tail(nodos)

            si nodo es meta:
                retornar nodo

            nodos agregar expansión(nodo)


    BFS():
        nodos :: lista
        nodos <- estado inicial
        bucle:
            si nodos es vacío:
                retornar Falla

            nodo <- head(nodos)
            nodos <- tail(nodos)

            si nodo es meta:
                retornar nodo

            nodos agregar hijos(nodo) atrás

        DFS():
        nodos :: lista
        nodos <- estado inicial
        bucle:
            si nodos es vacío:
                retornar Falla

            nodo <- head(nodos)
            nodos <- tail(nodos)

            si nodo es meta:
                retornar nodo

            nodos agregar hijos(nodo) adelante

        Evolución de la Lista de Espera de Nodos:
        BFS:
            [I]
            [A, B]
            [B, C, D]
            [C, D, E, F]
            [D, E, F, G, H]
            [E, F, G, H]
            [F, G, H, M, J]
            [G, H, M, J]
            [H, M, J]
            [M, J]              meta!

        DFS:
            [I]
            [A, B]
            [C, D, B]
            [G, H, D, B]
            [H, D, B]
            [D, B]
            [B]
            [E, F]
            [M, J, F]           meta!

3. 
    2 tuplas, 1 para cada orilla y 
    (canibales, misioneros)
    un índice de en qué orilla está la canoa (0 izquierda, 1 derecha)
    
    Restricción de estados:
        i <= j en las tuplas (i canibales y j misioneros)

    Estado incial:
        ((3, 3), (0, 0), 0)

    Estado meta:
        ((0, 0), (3, 3), 1)
    
    cruzar:
        (i, j)
        i + j <= 2
        i + j >= 1
        i, j >= 0
        i <= canibales en orilla 
        j <= misioneros en orilla 
            =>
        estado en orilla actual -= (i, j)
        orilla actual = !orilla actual  (cruza la canoa, cambia la orilla)
        estado en orilla actual += (i, j)

        sólo si el estado resultante cumple la restricción de estado 
        y no se repiten otros estados anteriores

    BFS:
        [((3, 3), (0, 0), 0)]
        [
            ((2, 3), (1, 0), 1), 
            ((1, 3), (2, 0), 1),
            ((2, 2), (1, 1), 1),
        ]
        [
            // ((2, 3), (1, 0), 1), 
            ((1, 3), (2, 0), 1),
            ((2, 2), (1, 1), 1),
        ]       
        [
            // ((1, 3), (2, 0), 1),
            ((2, 2), (1, 1), 1),
            ((2, 3), (1, 0), 0),
        ]   
        [
            // ((2, 2), (1, 1), 1),
            ((2, 3), (1, 0), 0),
        ]
        [
            // ((2, 3), (1, 0), 0),
            ((0, 3), (3, 0), 1),
        ]
        [
            // ((0, 3), (3, 0), 1),
            ((1, 3), (2, 0), 0),
        ]
        [
            // ((1, 3), (2, 0), 0),
            ((1, 1), (2, 2), 1),
        ]
        [
            // ((1, 1), (2, 2), 1),
            ((2, 2), (1, 1), 0),
        ]
        [
            // ((2, 2), (1, 1), 0),
            ((2, 0), (1, 3), 1),
        ]
        [
            // ((2, 0), (1, 3), 1),
            ((3, 0), (0, 3), 0),
        ]
        [
            // ((3, 0), (0, 3), 0),
            ((1, 0), (2, 3), 1),
        ]
        [
            // ((1, 0), (2, 3), 1),
            ((1, 1), (2, 2), 0),
            ((2, 0), (1, 3), 0),
        ]
        [
            // ((1, 1), (2, 2), 0),
            ((2, 0), (1, 3), 0),
            ((0, 0), (3, 3), 1),        meta!
            ... faltan expansiones
        ]

4.

a.
Ver imagen
b.
Ver imagen. preguntar a ana sobre la conclusion ya que nos quedó el mismo desarrollo pero
con otros nros.



Nota: Si h coincide, tenemos que anotar el criterio de elección.

5. 
Ver imagen

6.
a_ h no es admisible pues h(E) = 14 > G2(E) = 13 
(hacer cuadro completo con todos los casos e ir eligiendo el mínimo)

b_

7.
rep estados:
((x_robot,y_robot),orientación_robot)

rotar:
	(x, y), O -> (x, y), f(O)

	f(N) =...


avanzar:
	(x, y), O -> (x + fx(O), y + fy(O)), O

	fx(N) = 1
	fy(N) = 0

	/ el estado final no pertenezca al conjunto de las celdas prohibidas
    
Posición	Orientación	f	h	total

(1, 1) N 0 10 10
	(1, 1) E 1 10 11
	(2, 1) N 2 8  10
		(2, 1) E 3 8 11
		(3, 1) N 4 6 10
			(3, 1) E 5 6 11
				(3, 1) S 6 6 12
				(3, 2) E 7 4 11
					(3, 2) S 8 4 12
					(3, 3) E 9 2 11
						(3, 4) E 11 0 11 --> meta!
			(4, 1) N 6 8 14

"""

