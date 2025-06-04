import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["propietario"];

  update(event) {
    // const index = event.target.dataset.index;
    const newValue = event.target.value;

    this.propietarioTargets.forEach((target, idx) => {
      if (idx > 0) {
        // Solo actualiza los campos siguientes
        target.value = newValue;
      }
    });
  }
}
