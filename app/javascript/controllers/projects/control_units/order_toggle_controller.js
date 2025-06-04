import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["icon"];

  toggleOrder() {
    const currentOrder = this.element.dataset.order || "asc";
    const newOrder = currentOrder == "asc" ? "desc" : "asc";
    // this.element.dataset.order = newOrder;
    this.iconTarget.classList.toggle("rotate-180", newOrder === "desc");

    // Envía el nuevo orden al controlador Rails utilizando Turbo Native
    const projectId = this.element.dataset.projectId; // Asegúrate de que el ID del proyecto esté disponible en el HTML
    const url = `/projects/${projectId}/control_units/?order=${newOrder}`; // Ruta a la acción del controlador Rails para actualizar el orden
    Turbo.visit(url, { frame: "control_units" });
  }
}
