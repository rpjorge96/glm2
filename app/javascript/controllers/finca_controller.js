import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="finca"
export default class extends Controller {
  static targets = ["finca", "propietario"];

  // connect() {
  //   this.updatePropietario()
  // }

  updatePropietario() {
    const selectedOption =
      this.fincaTarget.options[this.fincaTarget.selectedIndex];
    const propietario = selectedOption.dataset.propietario;
    this.propietarioTarget.value = propietario ? propietario : "";
  }
}
