import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["show", "availableToggle"];

  isVisible = false;
  calculatorPath = "/ventas/calculator";

  connect() {
    const currentPath = window.location.pathname;
    if (currentPath === this.calculatorPath) {
      this.isVisible = true;
      this.showTarget.style.display = "block";
      this.showTarget.style.display = this.isVisible ? "block" : "none";
      this.availableToggleTarget.style.display = "none";
    } else {
      this.availableToggleTarget.style.display = "block";
    }
  }

  toggleVisibility() {
    const currentPath = window.location.pathname;
    if (currentPath === this.calculatorPath) {
      this.isVisible = true;
      this.showTarget.style.display = "block";
      this.availableToggleTarget.style.display = "none";
    } else {
      this.isVisible = !this.isVisible;
      this.showTarget.style.display = this.isVisible ? "block" : "none";
      this.availableToggleTarget.style.display = "block";
    }
  }
}
