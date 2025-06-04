import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { attempt: Number };
  attemptValue = 3; // Número de intentos antes de detenerse
  connect() {
    console.log("Scroll controller is connected!");
  }

  scrollToEnd() {
    let attemptsLeft = this.attemptValue;
    const interval = setInterval(() => {
      const nearBottom =
        window.innerHeight + window.scrollY >= document.body.offsetHeight - 100;

      if (nearBottom) {
        if (attemptsLeft <= 0) {
          clearInterval(interval); // Detiene el intervalo si no quedan intentos
          console.log("Detenido porque se asume que se alcanzó el final.");
        } else {
          attemptsLeft--; // Decrementa el contador de intentos
          console.log(`Cerca del final. Intentos restantes: ${attemptsLeft}`);
        }
      } else {
        attemptsLeft = this.attemptValue; // Restablece los intentos cuando aún no estamos cerca del fondo
        window.scrollBy(0, 100); // Continúa el desplazamiento hacia abajo
        console.log("Scrolling...");
      }
    }, 50); // Ajusta el tiempo de espera según sea necesario para permitir la carga de datos
  }
}
