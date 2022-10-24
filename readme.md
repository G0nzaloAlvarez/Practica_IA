Copyright 2021 Gonzalo Álvare Moreno, Pablo Muñoz
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Modo de Empleo: 

Para ejecutar el programa, se requiere tener instalado el programa `SWI_Prolog`. Para su ejecución, ejecutamos desde una terminal de linux el comando:
~~~
>swipl practica1.pl 
~~~

Posteriormente, comenzamos a formular las consultas que necesitemos. A continuación, se adjuntan el objetivo y el método de uso de todos los predicados disponibles. Además se adjuntan ejemplo para cada uno de los predicados,

# Planteamiento:

Dada una baraja de 40 cartas (4 palos con 10 cartas por palo) se quiere conocer las diferentes probabilidades de ganar las diferentes categorias del MUS.
Se desea llevar a cabo con exito las siguientes consultas a lo largo de la práctica

    1. Generar una Mano de 4 cartas totalmente aleatoria y SIN repetición.
    2. Ordenar la Mano generada de 4 cartas por oden numerico de menor a mayor
    3. Probabilidad de ganar la Categoria Grande con o sin farol
    4. Probabilidad de ganar la Categoria Chica con o sin farol
    5. Identificar si una mano posee parejas
    6. Identificar si una mano posee trios
    7. Identificar si una mano posee poker (4 cartas iguales)
    8. Probabilidad de gananr la categoria de "Parejas"

# Predicados

  ## cartas_diferenciadas
      El predicado "cartas_diferencias([A,B,C,D])" se encarga de comrpobar si la mano que le pasamos cumple con la regla de que todas las cartas sean diferentes entre si donde:

      - [A,B,C,D] son las cartas

      Ejemplo: se quiere saber si la siguiente mano tiene cartas repetidas.
      
      ~~~
      ?- cartas_diferenciadas([carta(o,9),carta(c,9),carta(e,10),carta(e,7)]).
       true.

      ?- cartas_diferenciadas([carta(o,9),carta(c,9),carta(e,10),carta(e,10)]).
       false.
      ~~~


 ## carta random

      El predicado de "carta_random(carta(N,P))" se devolver una carta aleatoria entrelas 40 posibles. 
      Para ello genera un numero aleatorio del 0-40 con la función random (lo alamacena en R), extrae la carta que tenga ese numero en la lista.

      Ejemplo: Se quiere generar una carta aleatoria

      ~~~~
      1 ?- carta_random(X).
        X = carta(b, 9).
      ~~~~


 ## Mano Random

      El predicado "mano_random([A,B,C,D])" se encarga de generar cuatro cartas random a partir del predicado
      anterior (carta_random).

      Ejemplo: Se quiere generar una mano Aleatoria, que no evite la repeticion.

      ~~~~
      ?- mano_random(X).
        X = [carta(c, 6), carta(b, 4), carta(b, 3), carta(c, 6)].
      ~~~~

 ## Generar Mano

      El predicado "generar_mano(Mano)" se encarga de generarnos una mano asegurando que no hay repetición
      de cartas. 
      Si se cumple el predicado "cartas_diferenciadad" muestra la mano y sino volvemos a generar mano hasta que
      se cumpla.

      Ejemplo: Generar una mano de cartas sin repetición.

      ~~~~~
      ?- generar_mano(X).
        X = [carta(o, 3), carta(c, 5), carta(b, 8), carta(c, 4)] .
      ~~~~

 ## Sumar Cartas

     El predicado "sumar_cartas([carta(P,N)| Resto],Suma)" Recibe una lista de cartas y se encargar
     de suamr las N's de las cartas obteniendo asi el sumatorio del valor total de la mano. Este predicado
     lo usaremos para ver el valor de nuestra mano en las diferentes categorias.

     Ejemplo: Queremos consultar el valor total de nuestra mano.

     ~~~~~
     ?- sumar_cartas([carta(o, 3), carta(c, 5), carta(b, 8), carta(c, 4)],Suma).
        Suma = 16.
     ~~~~

 ## Categoria Grande

    El predicado "categoria_grande(Mano,P_victoria,P_ganar_con_farol):-" recibe la mano con la que queremos jugar la categoria y muestra por pantalla la Probabilidad de ganar con y sin farol. Para ello primero sumamos el valor total de nuestras cartas y vemos que puntuacion obtenermos respecto al total posible.
     
     -Suma in N-1 +S1. (N-1) porque en caso de tener 1,1,1,1 de cartas en la que tenemos un 0% de posibilidades de ganar por lo que sumamos 0+0+0+0 = 0/36 = 0, si lo dejasemos como N seria 
     1+1+1+1= 4/36 = 0,1 % de ganar y este resultado no es real.

     Ejemplo: Probabilidad de ganar con una mano determinada.

     ~~~~
     ?- categoria_grande([carta(o,1),carta(e,4),carta(c,10), carta(b,5)],Prob_Victoria). 
        Prob_Victoria = 44.44444444444444.

     ?- categoria_grande([carta(o,1),carta(e,1),carta(c,1), carta(b,1)],Prob_Victoria).  
        Prob_Victoria = 0.

     ?- categoria_grande([carta(o,10),carta(e,10),carta(c,10), carta(b,10)],Prob_Victoria). 
        Prob_Victoria = 100.

     ~~~~


 ## Categoria Chica

    el predicado "categoria_chica(Mano,P_victoria)" es igual que la mano grande lo unico que cambia es como calcular la probabilidad.

    Ahora al resultado del sumatorio se le resta 100, por lo que van a obtener resultados mas altos las cartas mas pequeñas, si sacamaos un 2,2,2,2 el sumatorio es 1+1+1+1=4 por lo que el resultado final será 100-4=96
    una puntuacion bastante alta.

    Ejemplo:Probabilidad de ganar categoria con mano existente.

    ~~~~
    ?- categoria_chica([carta(o,10),carta(e,8),carta(c,2), carta(b,1)],Prob_Victoria).    
        Prob_Victoria = 52.77777777777778.

    ?- categoria_chica([carta(o,10),carta(e,10),carta(c,10), carta(b,10)],Prob_Victoria). 
        Prob_Victoria = 0.

    ?- categoria_chica([carta(o,1),carta(e,1),carta(c,1), carta(b,1)],Prob_Victoria).     
        Prob_Victoria = 100.
    ~~~~

 ## Trasponer

    El predicado "trasponer([carta(P, N) | Resto], [carta(N, P) | RestoTras]) :-" se encarga de darle la vuelta al formato de la carta (Palo, Numero) por (Numero, Palo) para usarlo posteriormente para ordenar la lista.

    Ejemplo: Trasponer una lista de cartas existente

    ~~~~

    ?- trasponer([carta(o,10),carta(e,6),carta(c,2), carta(b,8)],Lista_Traspuesta).   
        Lista_Traspuesta = [carta(10, o), carta(6, e), carta(2, c), carta(8, b)].

    ~~~~

 ## Ordenar Lista
 
  
   Con el predicado "ordenar_lista([carta(P,N)|Resto],Resultado)" buscamos que nos ordene la lista de menor a mayor cartas, esto será útil par el usuario, para ver las combinaciones. Es necesario trasponer primero porque la funcion sort sino ordena las cartas por Palos y no por Numeros.
   Finalmente volvemo a trasponer para mostrar por pantalla el formato inicial.

   Ejemplo: Ordena de menor a 

   ~~~~
   ?- ordenar_lista([carta(o,10),carta(e,6),carta(c,2), carta(b,8)],Resultado).    
        Resultado = [carta(c, 2), carta(e, 6), carta(b, 8), carta(o, 10)].
   ~~~~

   ## Parejas

      Este predicado "parejas([carta(P1,N), carta(P2,M)|Resto],X):-" recibe la lista de las 4 cartas
      y muestra una lista con el valor que se repetido 2 veces, si hay doble pareja, muestra 2 valores en 
      la lista. Hay que tener en cuenta 3 cosas.

      Que no encuentre ninguna pareja, debe mostrar [0].
      Que encuentre pareja pero que pertenezca a un trio , debe mostrar [0].
      Que encuentre pareja pero que pertenezca a un poker, debe mostrar [0].

    Comprobamos que cumple todas las condicones.

    ~~~~
    ?- parejas([carta(o,10),carta(e,10),carta(c,3), carta(b,2)],X).  
        X = [10, 0] .

    ?- parejas([carta(o,10),carta(e,10),carta(c,2), carta(b,2)],X).  
        X = [10, 2, 0] .

    ?- parejas([carta(o,10),carta(e,10),carta(c,10), carta(b,2)],X). 
        X = [0].

    ?- parejas([carta(o,10),carta(e,10),carta(c,10), carta(b,10)],X). 
        X = [0].


 ## Trio

      Para saber si hay trios en nuestra mano hay que tener en cuenta los 3 casos en los que puede haber 
      un trio
         - Las tres primeras son iguales.
         - Las tres ultimas son iguales.
         - Hay trio pero pertenece a un poker (no se puede contar).
         - No hay trios.  
    
      Para ello creamos dos predicados condicionando la entrada de la lista y los valores de las cartas
      para dar una salida

    -trio([carta(P1,N),carta(P2,N),carta(P3,N),carta(P4,M)|Resto],[N]):-    Primer caso 
    -trio([carta(P1,M),carta(P2,N),carta(P3,N),carta(P4,N)|Resto],[N]):-    Segundo caso
    -trio(Mano,[0]).                                                        Si no se cumple es porque no hay.

    Ejemplo: Identificar los trios de las siguientes manos
    
    ~~~~ 

    ?- trio([carta(o,10),carta(e,10),carta(c,10), carta(b,2)],X).  
        X = [10].

    ?- trio([carta(o,10),carta(e,10),carta(c,8), carta(b,2)],X).  
        X = [0].

    ?- trio([carta(o,10),carta(e,10),carta(c,10), carta(b,10)],X). 
        X = [0].   

    ~~~~


 ## Poker

    Para este predicado "poker([carta(P1,N),carta(P2,N),carta(P3,N),carta(P4,N) |Resto],[N])" es la misma mecanica que con el trio solo que en este caso solo hay dos opciones a nalizar.

    - Hay Poker.
    - No hay Poker

    Si se cumple, muestra N y sino muestra [0] en la lista.

    Ejemplo: Identificar el Poker en las siguientes Manos

    ~~~~

    ?- poker([carta(o,10),carta(e,10),carta(c,10), carta(b,10)],X). 
        X = [10].

    ?- poker([carta(o,10),carta(e,10),carta(c,10), carta(e,2)],X).  
        X = [0].

    ~~~~


 ## Categoria Parejas
    
    Este predicado "categoria_parejas(Mano,N):" involucra a la mayoria de los anteriores para saber si una mano tiene pareja, trio o poker y en base a esto asignar una puntuacion para calcular la Porbabilidad de Vcitoria.

    primero ordenamos la lista, buscamos los valores de parejas,trios y poker y obtenemos el valor de N en base a que poker gana a trio y trio a parejas.

    Ejemplo: Cuantas posibilidades hay de ganar la categoria de parejas con las siguientes manos.

    ~~~~

    ?- categoria_parejas([carta(o,10),carta(b,10),carta(c,10), carta(e,10)],X). 
        X = 100.

    ?- categoria_parejas([carta(o,10),carta(b,10),carta(c,10), carta(e,8)],X).  
        X = 9.90990990990991.

    ?- categoria_parejas([carta(o,10),carta(b,10),carta(c,8), carta(e,8)],X).  
        X = 1.6216216216216217 .

    ?- categoria_parejas([carta(o,1),carta(b,1),carta(c,1), carta(e,1)],X).   
        X = 10.0.

    ~~~~




      