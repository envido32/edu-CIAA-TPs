/* FreeRTOS.org includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

/* Demo includes. */
#include "basic_io.h"

void vTareaOndaCuadrada (void *pvParameters);
void Pulso (long tiempo_ms);

/*-----------------------------------------------------------*/

int main( void )
{
	/* Init the semi-hosting. */
	printf( "\n" );

	xTaskCreate(
			vTareaOndaCuadrada,			/* Pointer to the function that implements the task. */
			"UART_TX",					/* Text name for the task.  This is to facilitate debugging only. */
			configMINIMAL_STACK_SIZE,	/* Stack depth in words. */
			(void*) 0,					/* gTestParamas[0] */
			1,							/* Prioridad */
			NULL );						/* Task handle. */

	/* Start the scheduler so our tasks start executing. */
	vTaskStartScheduler();

	/* If all is well we will never reach here as the scheduler will now be
	running.  If we do reach here then it is likely that there was insufficient
	heap available for the idle task to be created. */
	for( ;; );
	return 0;
}
/*-----------------------------------------------------------*/
#define SALIDA	1
#define ENTRADA 0

#define LED_PORT	0
#define LED_BIT		(1UL << 22)

#define PASIVO 1
#define ACTIVO 0

#define PB_PORT 	1
#define PB_BIT 		(1UL << 31)

#define PULSADOR (!((GPIO_ReadValue(PB_PORT)) & PB_BIT))
#define TIEMPO 250
#define PERIODO 1000
// Tarea vTareaOndaCuadrada: Cada 500ms chequea si está presionado
// el boton WAKEUP SW_4 de la base board. Si lo encuentra pulsado
// Genera un pulso de 500ms en el led del stick.
// No hace debounce del pulsador.
void vTareaOndaCuadrada (void *pvParameters)
{
	GPIO_SetDir(LED_PORT,	LED_BIT,SALIDA);
	GPIO_SetDir(PB_PORT,	PB_BIT,	ENTRADA);
	portTickType xLastWakeTime;
	xLastWakeTime = xTaskGetTickCount();
	for ( ; ; ) {
//		if(PULSADOR){
			Pulso(TIEMPO);
//		}
		vTaskDelayUntil(&xLastWakeTime, MS(PERIODO));
	}
}

// Funcion Pulso: Genera un pulso de tiempo_ms en el led del stick.
void Pulso (long tiempo_ms)
{
	portTickType xLastWakeTime;
	xLastWakeTime = xTaskGetTickCount();
	GPIO_SetValue	(LED_PORT, LED_BIT);
		vTaskDelayUntil(&xLastWakeTime, MS(tiempo_ms));
	GPIO_ClearValue	(LED_PORT, LED_BIT);
}
