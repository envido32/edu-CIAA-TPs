/* FreeRTOS.org includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

/* Demo includes. */
#include "basic_io.h"

void vTareaEstadoBoton (void *pvParameters);
void vTareaLED (void *pvParameters);
char boton = 0;

/*-----------------------------------------------------------*/

#define SALIDA	1
#define ENTRADA 0

xSemaphoreHandle xSemaforo;

int main( void )
{
	/* Init the semi-hosting. */
	printf( "\n" );
	GPIO_SetDir(2,1UL << 2, SALIDA);
	GPIO_ClearValue(2,1UL << 2);
	GPIO_SetDir(2,1UL << 3, SALIDA);
	GPIO_ClearValue(2,1UL << 3);
	GPIO_SetDir(2,1UL << 4, SALIDA);
	GPIO_ClearValue(2,1UL << 4);

	vSemaphoreCreateBinary( xSemaforo );

	xTaskCreate(
			vTareaEstadoBoton,			/* Pointer to the function that implements the task. */
			"BOTON",					/* Text name for the task.  This is to facilitate debugging only. */
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

#define LED_PORT	0
#define LED_BIT		(1UL << 22)

#define PASIVO 1
#define ACTIVO 0

#define ON	1
#define OFF	0

#define PB_PORT 	0
#define PB_BIT 		(1UL << 18)

#define PULSADOR	(!((GPIO_ReadValue(PB_PORT)) & PB_BIT))
#define TIEMPO	25
#define DELAY	MS(1000)


// Tarea vTareaOndaCuadrada: Cada 500ms chequea si está presionado
// el boton WAKEUP SW_4 de la base board. Si lo encuentra pulsado
// Genera un pulso de 500ms en el led del stick.
// No hace debounce del pulsador.
void vTareaEstadoBoton (void *pvParameters)
{
	char aux = 0;
	GPIO_SetDir(PB_PORT, PB_BIT, ENTRADA);
	for ( ; ; ) {
		if (PULSADOR){
			vTaskDelay(MS(TIEMPO));
			if (PULSADOR){
				aux = boton;
				boton = ON;
				xSemaphoreGive (xSemaforo);
			}
		}
		else {
			vTaskDelay(MS(TIEMPO));
			if (!PULSADOR){
				aux = boton;
				boton = OFF;
			}
		}
		if ((aux == ON) && (boton == OFF))
		{
			xSemaphoreGive (xSemaforo);

		}
	}
}

void vTareaLED (void *pvParameters)
{
	GPIO_SetDir(LED_PORT, LED_BIT, SALIDA);
	for ( ; ; )
	{
		xSemaphoreTake(xSemaforo, portMAX_DELAY);
		GPIO_SetValue(LED_PORT, LED_BIT);
		vTaskDelay(DELAY);
		GPIO_ClearValue(LED_PORT, LED_BIT);
	}
}
