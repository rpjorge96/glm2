import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "input"];

  connect() {
    this.toggleInputs();
  }

  toggleInputs() {
    this.inputTargets.forEach((input) => {
      if (this.selectTarget.value === "No aplica") {
        input.value = "";
        input.disabled = true;
      } else {
        input.disabled = false;
      }
    });
  }
}
