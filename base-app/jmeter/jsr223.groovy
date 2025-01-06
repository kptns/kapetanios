/*
  JSR223 PreProcessor (Groovy)
  - Configura "total_threads" como una propiedad (props) según franjas horarias en CDMX.
  - Configura "on_hold_t" (tiempo aleatorio entre 300-600).
*/

import java.time.LocalDateTime
import java.time.ZoneId
import java.util.Random

// Tomamos la fecha/hora local en CDMX
def now = LocalDateTime.now(ZoneId.of("America/Mexico_City"))
def hour = now.getHour()
def minute = now.getMinute()

// Generador random
def random = new Random()

// Inicializa totalThreads
int totalThreads = 1

// Determina el número de threads según la hora
if (hour == 14) {
    if (minute >= 18 && minute < 23) {
        // 2:18 pm a 2:23 pm => 20 a 30 threads
        totalThreads = 20 + random.nextInt(11)   // [20..30]
    } else if (minute >= 23 && minute < 28) {
        // 2:23 pm a 2:28 pm => 30 a 50 threads
        totalThreads = 30 + random.nextInt(21)  // [30..50]
    } else if (minute >= 28 && minute < 33) {
        // 2:28 pm a 2:33 pm => 3 a 5 threads
        totalThreads = 3 + random.nextInt(3)   // [3..5]
    } else if (minute >= 33 && minute < 38) {
        // 2:33 pm a 2:38 pm => 2 a 3 threads
        totalThreads = 2 + random.nextInt(2)   // [2..3]
    } else {
        // Otros minutos => 1 a 2 threads
        totalThreads = 1 + random.nextInt(2)   // [1..2]
    }
} else {
    // Otras horas => 1 a 2 threads
    totalThreads = 1 + random.nextInt(2)   // [1..2]
}

// Determina el hold time aleatorio entre 300 y 600
def onHold = 180     // [300..600]

// Ponemos estos valores en las PROPIEDADES de JMeter
props.put("total_threads", totalThreads.toString())
props.put("on_hold_t", onHold.toString())

// [Opcional] Log para depurar
log.info("Hora local en CDMX: ${hour}:${minute} - total_threads=${totalThreads}, on_hold_t=${onHold}") 

// ${__P(total_threads, 5)}
// ${__P(on_hold_t, 5)}