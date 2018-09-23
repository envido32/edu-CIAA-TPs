/* FreeRTOS.org includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

/* Demo includes. */
#include "basic_io.h"

void vTareaAntirebote (void *pvParameters);
void vTareaLED (void *pvParameters);
char boton = 0;

/*-----------------------------------------------------------*/

int main( void )
{
	/* Init the semi-hosting. */
	printf( "\n" );

	xTaskCreate(
			vTareaAntirebote,			/* Pointer to the function that implements the task. */
			"ANTIREB",					/* Text name for the task.  This is to facilitate debugging only. */
			configMINIMAL_STACK_SIZE,	/* Stack depth in words. */
			(void*) 0,					/* gTestParamas[0] */
			1,							/* Prioridad */
			NULL );						/* Task handle. */

	xTaskCreate(
			vTareaLED,					/* Pointer to the function that implements the task. */
			"LED",						/* Text name for the task.  This is to facilitate debugging only. */
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

#define ON	1
#define OFF	0

#define PB_PORT 	0
#define PB_BIT 		(1UL << 18)

#define PULSADOR (!((GPIO_ReadValue(PB_PORT)) & PB_BIT))
#define TIEMPO 25


// Tarea vTareaOndaCuadrada: Cada 500ms chequea si está presionado
// el boton WAKEUP SW_4 de la base board. Si lo encuentra pulsado
// Genera un pulso de 500ms en el led del stick.
// No hace debounce del pulsador.
void vTareaAntirebote (void *pvParameters)
{
	GPIO_SetDir(PB_PORT, PB_BIT, ENTRADA);
	for ( ; ; ) {
		if (PULSADOR){
			vTaskDelay(MS(TIEMPO));
			if (PULSADOR){
				boton = ON;
			}
		}
		else {
			vTaskDelay(MS(TIEMPO));
			if (!PULSADOR){
				boton = OFF;
			}
		}
	}
}

void vTareaLED (void *pvParameters)
{
	GPIO_SetDir(LED_PORT, LED_BIT, SALIDA);
	for ( ; ; )
	{
		if (boton){
		GPIO_SetValue(LED_PORT, LED_BIT);
		}
		else {
			GPIO_ClearValue(LED_PORT, LED_BIT);
		}
	}
}
