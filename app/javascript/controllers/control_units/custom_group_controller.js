import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.disableFields();
  }

  disableFields() {
    // Busca todos los elementos input, select y textarea dentro del elemento controlador
    const fields = this.element.querySelectorAll("input, select, textarea");
    // Deshabilita cada campo y añade la clase 'cursor-not-allowed'
    fields.forEach((field) => {
      field.disabled = true;
      field.classList.add("cursor-not-allowed");
    });
  }
}
