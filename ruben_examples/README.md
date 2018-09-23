Guía de Ejercicios de RTOS.
Los ejercicios 4, 7, 8, 9, 12 y 14 conforman el TP 3 y son de presentación obligatoria.
El resto es de realización opcional.

//---------------------------------------------------------------------------------------------------------------

// 1) Escribir una funcion void Pulso (long tiempo_ms); que prenda un led durante tiempo_ms y una tarea
// 	que usándola genere un tren de pulsos de TOn = 250ms / TOff = 750ms

//	ok	---------------------------------------------------------------------------------------------------------------

// 2) Escribir una tarea que usando la función Pulso genere un tren de pulsos con TOn = 100ms, 200ms, 300ms... y 
//	con período fijo 1s.

//	ok	---------------------------------------------------------------------------------------------------------------

// 3) Escribir una tarea que haga de driver para un pulsador, con anti-rebote de 25ms. Otra tarea reflejará el
//	estado del pulsador en un led.

//	ok	---------------------------------------------------------------------------------------------------------------

// 4) Agregar al ejercicio anterior la funcionalidad de medir el tiempo de presión del pulsador. La otra tarea
//	destellará el led durante el tiempo medido.

//	ok ---------------------------------------------------------------------------------------------------------------

// 5) Una tarea sensa un pulsador y libera un semáforo binario cuando confirma el fin de la pulsación. 
//	La otra tarea destella un led cuando recibe el semáforo. La tarea esperará al semáforo indefinidamente.

//	ok	---------------------------------------------------------------------------------------------------------------

// 6) Instanciar 3 veces la tarea que destella el led, cada una aplicada a un color del led RGB del base board y 
//	hacer que las tres tareas generen el destello cuando se reciba el semáforo. Las tareas esperarán al semáforo 
//	indefinidamente.

//	ok	---------------------------------------------------------------------------------------------------------------

// 7) Una tarea muestrea un pulsador y libera un semáforo cuando confirma su liberación. Otra tarea espera el 
//	semáforo por 1s, encendiendo el led verde al recibir el semáforo y encendiendo en cambio el rojo si expira 
//	el tiempo de bloqueo.

//	ok	---------------------------------------------------------------------------------------------------------------

// 8) Una tarea mide el tiempo de opresión de un pulsador. Cuando lo obtiene lo envía por cola a otra tarea que 
//	destella una led durante el tiempo recibido.

//	ok	---------------------------------------------------------------------------------------------------------------

// 9) Una tarea destella contínuamente un led,con una frecuencia constante y un ciclo de actividad que recibe 
//	de otras tareas mediante una cola. Recuerde el uso de vTaskDelayUntil para mantener la periodicidad. 
//	Nota: La tarea no debe bloquearse, ya que mientras no reciba mensajes debe mantener el led titilando.

//	en teoria	---------------------------------------------------------------------------------------------------------------

// 10) Repetir la tarea del ejemplo anterior, pero en vez de pasar el dato por cola, pasar la direccion del mismo.
//	Recuerde usar variables globales para mantener válido el dato cuando la tarea sale de contexto.

//	en teoria	---------------------------------------------------------------------------------------------------------------

// 11) Repetir el ejercicio 5 (semáforo binario), pero agregue la posibilidad de que se contabilicen hasta 3 
//	pulsaciones del botón, que a su vez generarán 3 destellos del led.

//	ok	---------------------------------------------------------------------------------------------------------------

// 12) Una tarea mide el tiempo de pulsación de un botón. Cuando se suelta el botón genera un pulso de esa misma
//	duración  en un led.
//	Otra tarea mantiene una onda cuadrada de 1s, 50% en el mismo LED.
//	Turnar el acceso al mismo mediante un mutex de modo que ninguna de las ondas se interrumpa.

//	falla medidor de tiempo	---------------------------------------------------------------------------------------------------------------

// 13) Generar un pulso en un led sincronizado a una interrupción. Use un semáforo binario dado en la interrupción.
//	NOTA: Tome como base el Ejemplo 12 de la teoría si necesita ayuda para generar interrupciones.

//---------------------------------------------------------------------------------------------------------------

// 14) Idem anterior, pero usando una cola, de modo de poder hacer el destello de tiempo variable.

//---------------------------------------------------------------------------------------------------------------
