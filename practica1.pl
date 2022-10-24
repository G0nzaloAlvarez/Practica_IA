/*Copyright 2022 Gonzalo Álvarez Moreno, Pablo Muñoz De Lorenzo
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
% Práctica 1 de Inteligencia Artificial
% Universidad CEU San Pablo, Escuela Politécnica Superior
% Grado en Ingeniería de Sistemas de Información
% Autores: Gonzalo Álvarez Moreno, Pablo Muñoz De Lorenzo

/*Funcionamiento del MUS*/

/*El MUS es un juego de cartas en el que originalmente se juega por equipos de 2 vs 2 con 4 cartas cada uno de los participantes. 
En base a las cartas que te dan se juegan diferentes categorias, la Grande, la Chica , Parejas y unas especie de blackjack. Aqui
vamos a simular el reparto de cartas a un jugador para ver que posibilidades tienen de ganar la categoria.

Hay 4 palos con 10 cartas cada uno (1-10). 

El la Categoria de la Grande gana el que tenga las cartas más altas, la mejor opcion en este caso seria tener 10,10,10,10. Si dos
jugadores tienen la misma carta más alta gana el que tenga la segunda más alta. Por ejemplo 1,1,9,10 gana a 1,1,8,10.

La Categortia de la Chica es lo mismo pero con cartas pequeñas, gana el que tenga menores cartas, la mejor opcion para ganar esta 
categoria sería tener como mano 1,1,1,1. Sin embargo es importante saber que se juega a todas las categorias con las MISMA MANO, por 
lo que con una mano de 1,1,1,1 ganamos seguro la Chic apero perdemos seguro la Grande.

Por último esta la categoria de Parejas donde solo puedes jugar (jugar se entiende por apostar inicialmente) si tienes como mínimo
una pareja. Gana el que mejor combinacion tenga, poker gana a trio y trio gana a parejas.

Por último es importante conocer los faroles que se pueden hacer, solo disponibles en la categorías Chica y Grande ya que en parejas
si no tienes parejas no puedes apostar. En la Chica y Grande aunque tengamos una mala mano puedes apostar y jugar la categoría, esto
condiconará las probabilidades de victoria.
*/


%RULES

/*Predicado que oblica que las 4 cartas que se generen sean diferentes entre sí, de esta manera se evita la repeticion de cartas. 
  Usamos metodo dif para todas las posibles combinaciones de cartas*/

cartas_diferenciadas([A,B,C,D]) :-			
        dif(A, B),              % A no puede ser igual que B
        dif(A, C),              % A no puede ser igual que C
        dif(A, D),              % A  ""  ""   ""   ""   "" D
		dif(B, C),
		dif(B, D),
        dif(C, D).

/* El predicado generar_mano(Mano), otorga al usuario una mano de 4 cartas aleatorias
 * entre las 40 posibles (4 palos, 10 cartas por palo)
 * hay que tener en cuenta que no pueden repetirse ninguna e las cartas de la mano por lo que tenemos que incluir un predicado en 
 * el que en caso de que se repita, genere una mano nueva.  
 */

generar_mano(Mano) :- 
        mano_random(Mano),
        cartas_diferenciadas(Mano).

generar_mano(Mano) :-			    	   % el caso que salgan cartas repetidas, vuelve a ejecutar
		mano_random(Mano1),        		   % Generamos 4 cartas random
		\+(cartas_diferenciadas(Mano1)),   % No se cumple que sean diferentes enre si las 4 cartas  
		generar_mano(Mano).         	   % Volvemos a ejecutar una nueva mano

carta_random(carta(N,P)):-          % Predicado que obtiene una carta random de las 40 posibles
  random(0, 40, R),                 % Generamos numero entre 0-40 y lo almacenamos en R
  numero(R, carta(N,P)).            % sacamos la carta que se encuentr ene la posicion de R
  

mano_random([A,B,C,D]) :-          % Genera4 cartas Random pero NO tienen porque ser difernetes entre sí.
    carta_random(A),                % Usamos el predicado random_carta() para generar cada una de las cartas.
    carta_random(B),
    carta_random(C),
	carta_random(D).

/*Una vez tenemos las manos generadas comenzamos con las categorias, en cada uno de los predicados de las categorias
 * recibe la Mano actual y te indica la Prob de Victoria real y con Farol. El farol simplemnete es porque aunque tengamos
 * una mano mala podemos fingir que es muy buena para hacer que el oponente no juegue la categoria sin importar el valor de las
 * cartas. La probabilidad de que te vea un farol pongamos que es del 50%
 */


/* Predicado que suma el valor de las cartas y en base a ese valor calcula si tienes buena mano para la victoria. la mejor mano seria tener
   10,10,10,10.  Predicado que recibe la Mano tal que [carta(o, 8), carta(o, 9), carta(o, 3), carta(c, 9)] por ejemplo y que usa el predicado
   suma_cartas para sumaer los valores de N (numero). 
*/

sumar_cartas([],0).
sumar_cartas([carta(P,N)| Resto],Suma) :-
	sumar_cartas(Resto,S1),
	Suma is N -1 + S1.                         				% N - 1, esto se hace porque si tienes la mano 1,1,1,1 tienes 0% posibilidad de ganar la categoria.

categoria_grande(Mano,P_victoria) :-
	sumar_cartas(Mano,Suma),
	P_victoria is (Suma/36)*100.                     		% se divide entre 36 devido al (N-1), el valor maximo es la mano 10,10,10,10 = 9+9+9+9 = 36.
	
	

/* Para el predicado de la Mano Chica es lo mismo pero solamente que aqui ganan las cartas más bajas, por lo que le restamos 100, de manera que cuanta más
 * puntuacion sumen tus cartas, menos puntos tienes en la categoria, beneficiando asi a las cartas más bajas. La máxima puntuación sería la mano de 1,1,1,1
 * con el valore es N-1 definido en el predicado sumar_valores 1,1,1,1 = 0, por lo que 100-0 = 100% posibilidades de ganar la categoria.
 */

categoria_chica(Mano,P_victoria) :-   
	sumar_cartas(Mano,Suma),
	P_victoria is 100- (Suma/36)*100.                


/*Predicado para cambiar la lista de cartas (P,N) por (N,P). recibe la lista de cartas y traspone el valor de N Y P devolviendo la lista idéntica
 * pero con los valores cambiados
 */

trasponer([], []).
trasponer([carta(P, N) | Resto], [carta(N, P) | RestoTras]) :-
	trasponer(Resto, RestoTras).

/*Una vez tenermo el formato (N,P) lo ordenamos con el metodo sort para que el jugador, pueda ver sus cartas ordenadas de menor a mayor.
 *NOTA: NO es necesario para el desarrollo del juego tenerlas ORDENADAS pero es algo que se suele hacer cuando se juega
 *Primero trasponemos los valores porque la funcion sort sino ordena las cartas por Palos (ordena alfabeticamente) y una vez esta ordenada
 * la vlvemos a trasponer para devolver al usuario la misma interfaz iniciar de la mano pero y aordenada
 */

ordenar_lista([],[]).
ordenar_lista([carta(P,N)|Resto],Resultado):-
trasponer([carta(P, N)|Resto],Traspuesta), 
sort(Traspuesta,Ordenada),
trasponer(Ordenada,Resultado).



/*Comenzamos la ultima categoria, la de parejas.
 * Hay que te tener en cuenta varias cosas: 
 * El orden de victoria es Poker gana a Trio, y Trio gana a  Doble Pareja y Pareja
 *  * Si encuentra un Poker no puede contar que hay Trio también y lo mismo si es un sólo Trio, no se puede contar una pareja
 */



/* El predicado de parejas Recibe la lista de cartas y devuelve una lista vacia inicialmente, este será el caso en el que no hay parejas [0]
 * 
 */
parejas([],[0]).
parejas([carta(P,N)|[]],[0]).   
/* Estos predicados  son para excluir la posibilidad de que si el predicado trio o pker devuelven un valor de N diferente de 0 es porque ha encopntrado uno.
 * Por lo que no puede haber parejas, por eso el predicado devuelve [0] y hacemos un corte.
 */

parejas(Mano,[0]):-
  trio(Mano,[N]),
   N =\= 0,
   !.

parejas(Mano,[0]):-
  poker(Mano,[N]),
   N =\= 0,
   !.
/* Predicado que devuelve una lista de N de las cartas que coinciden, es importante diferenciar los Palos y Resto con Resto2 para saber que estamos
 * comparando cartas diferentes pero con el mismo numero
*/

parejas([carta(P,N), carta(P2,N)|Resto],[N|Resto2]):-
	parejas(Resto,Resto2).




 /* En el caso de que las Ns no coincidan (M =\= N) se invoca al predicado otra vez para que vuelva al predicado anterior a buscar una carta del mismo valor. 
 */  
parejas([carta(P1,N), carta(P2,M)|Resto],X):-  % Caso en el que NO hay pareja
  M =\= N,
  parejas([carta(P2,M)|Resto],X).





/*El predicado de trios recibe la mano de cartas y devuelve la lista con el valor de la carta que se repite 3 veces
 * Simplemente hay que tener en cuenta las 3 posibilidades, que las 3 primeras cartas sean las que se repiten, que sean las ultimas 3
 * o que no haya trio.
 */

trio([carta(P1,N),carta(P2,N),carta(P3,N),carta(P4,M)|Resto],[N]):-   % Primer caso, las 3 primeras cartas se repiten, diferenciar palos para evitar manos no válidas
 N =\= M,
 !.

trio([carta(P1,M),carta(P2,N),carta(P3,N),carta(P4,N)|Resto],[N]):-   % Segundo caso, el trio se encuentra en las 3 ultimas cartas, M en la primera
 N =\= M,
 !.

 trio(Mano,[0]).   													  % Si no hay trio devuelve la lista con valor 0



/*Para el predicado del Poker es el más simple porque lo hay o no. Por lo que el valor de N en las 4 cartas debe ser el mismo.
*/

poker([carta(P1,N),carta(P2,N),carta(P3,N),carta(P4,N)|Resto],[N]):-
 !.
poker(Mano,[0]). 													  % En caso contrario (no hay poker, la lista pasa a valer 0)


/*Para obtener la puntuacion de esta categoria obtenemos el valor (si existe) de parejas, trio o poker, y dependiendo del que se
 * le asignaremos un valor u otro. Una vez tenemos el valor sobre el total de puntos que podemos conseguir, ese será nuestra 
 * probabilidad de victoria
*/

categoria_parejas(Mano,N):-
	ordenar_lista(Mano,Mano_ordenada),
	parejas(Mano_ordenada,Lp),
	trio(Mano_ordenada,[Valor_trio]),
	poker(Mano_ordenada,[Valor_poker]),
	sumar_valores(Lp,Valor_parejas),
	N is (((Valor_trio *11 + Valor_poker *111 + Valor_parejas) /1110)*100).

sumar_valores([],0).
sumar_valores([N| Resto],Suma) :-
	sumar_valores(Resto,S1),
	Suma is N + S1.




	





%FACTS
numero(1, carta(o,1)).
numero(2, carta(o,2)).
numero(3, carta(o,3)).
numero(4, carta(o,4)).
numero(5, carta(o,5)).
numero(6, carta(o,6)).
numero(7, carta(o,7)).
numero(8, carta(o,8)).
numero(9, carta(o,9)).
numero(10, carta(o,10)).

numero(11, carta(e,1)).
numero(12, carta(e,2)).
numero(13, carta(e,3)).
numero(14, carta(e,4)).
numero(15, carta(e,5)).
numero(16, carta(e,6)).
numero(17, carta(e,7)).
numero(18, carta(e,8)).
numero(19, carta(e,9)).
numero(20, carta(e,10)).

numero(21, carta(b,1)).
numero(22, carta(b,2)).
numero(23, carta(b,3)).
numero(24, carta(b,4)).
numero(25, carta(b,5)).
numero(26, carta(b,6)).
numero(27, carta(b,7)).
numero(28, carta(b,8)).
numero(29, carta(b,9)).
numero(30, carta(b,10)).

numero(31, carta(c,1)).
numero(32, carta(c,2)).
numero(33, carta(c,3)).
numero(34, carta(c,4)).
numero(35, carta(c,5)).
numero(36, carta(c,6)).
numero(37, carta(c,7)).
numero(38, carta(c,8)).
numero(39, carta(c,9)).
numero(40, carta(c,10)).