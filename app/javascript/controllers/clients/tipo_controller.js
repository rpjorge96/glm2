import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["juridico", "individual"];

  connect() {
    this.toggleDivs();
  }

  toggleDivs() {
    const tipoDeCliente = document.getElementById(
      "client_tipo_de_cliente",
    ).value;

    // Condición para el primer div
    if (tipoDeCliente === "Individual") {
      this.individualTarget.classList.remove("hidden");
      this.juridicoTarget.classList.add("hidden");
    }
    // Condición para el segundo div
    else if (tipoDeCliente === "Jurídico") {
      this.juridicoTarget.classList.remove("hidden");
      this.individualTarget.classList.add("hidden");
    }
  }
}
