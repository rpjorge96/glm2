import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["notUpdatableField"];
  static values = {
    disabled: Boolean,
  };

  connect() {
    if (this.disabledValue) {
      this.notUpdatableFieldTargets.forEach((field) => {
        field.setAttribute("readonly", true);
        field.classList.add("cursor-not-allowed", "bg-gray-100");
      });
    }
  }

  checkEditable(event) {
    if (this.disabledValue) {
      event.preventDefault();
      event.stopPropagation();
      this.showToast();
    }
  }

  showToast() {
    this.createToast(
      "error",
      "Este campo no es editable porque el proyecto tiene unidades de control relacionadas.",
    );
  }
}
