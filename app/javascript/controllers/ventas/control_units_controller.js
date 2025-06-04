import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "list"];

  activeControlUnits = [];
  controlUnitsIds = {};

  static values = {
    controlUnitsTypes: Object,
  };

  toggle(event) {
    const controlUnit = event.target.name;
    if (event.target.checked) {
      this.activeControlUnits.push(controlUnit);
    } else {
      this.activeControlUnits = this.activeControlUnits.filter(
        (unit) => unit !== controlUnit,
      );
    }

    this.refreshList();
  }

  refreshList() {
    this.listTarget.innerHTML = this.activeControlUnits
      .map(
        (unit) => `<li>${unit} 
                <button data-action="click->ventas--control-units#removeFromList"
                        class="font-medium text-red-600 dark:text-red-500 hover:underline"
                        name="${unit}"
                >
                Eliminar
                </button></li>`,
      )
      .join("");
  }

  removeFromList(event) {
    this.activeControlUnits = this.activeControlUnits.filter(
      (unit) => unit !== event.target.name,
    );
    this.checkboxTargets.find(
      (checkbox) => checkbox.name === event.target.name,
    ).checked = false;

    this.refreshList();
  }

  cotizar() {
    if (this.activeControlUnits.length === 0) {
      alert("Debe seleccionar al menos una unidad de control para cotizar.");
      return;
    }

    const url = `/ventas/quotations/new?control_unit_codes[]=${this.activeControlUnits.join("&control_unit_codes[]=")}`;
    window.location.href = url;
  }

  mergeLots() {
    const activeLots = this.activeControlUnits.filter((unit) => {
      return this.controlUnitsTypesValue[unit] === "Lote";
    });

    const controlUnits = this.activeControlUnits.filter((unit) => {
      return this.controlUnitsTypesValue[unit] !== "Lote";
    });

    this.dispatch("openMergeLotsModal", {
      detail: { lots: activeLots, controlUnits: controlUnits },
    });
  }
}
