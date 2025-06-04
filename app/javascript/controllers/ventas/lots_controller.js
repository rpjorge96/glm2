import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["mergedLotsList", "availableHousesList"];

  static values = {
    availableHouses: Object,
  };

  modal = null;
  lots = [];
  projectCode = null;
  controlUnits = null;

  connect() {
    this.instantiateCustomPaymentsModal();
  }

  instantiateCustomPaymentsModal() {
    const $targetEl = document.getElementById("mergeLotsModal");
    const options = {
      placement: "center",
      backdrop: "dynamic",
      backdropClasses: "bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40",
      closable: true,
      onHide: () => {},
      onShow: () => {},
      onToggle: () => {},
    };

    this.modal = new Modal($targetEl, options);
  }

  closeModal() {
    this.mergedLotsListTarget.innerHTML = "";
    this.availableHousesListTarget.innerHTML = "";
    this.modal.hide();
  }

  openModal({ detail: { lots, controlUnits } }) {
    this.lots = lots;
    this.controlUnits = controlUnits;

    if (lots.length === 0) {
      alert("No se puede unificar lotes si no hay lotes seleccionados.");
      return;
    }
    if (!this.validateLots()) return;

    lots.forEach((lot) => {
      this.mergedLotsListTarget.innerHTML += `<li>${lot}</li>`;
    });

    if (this.availableHousesValue[this.projectCode] === undefined) {
      alert("No hay casas disponibles para el proyecto seleccionado");
      return;
    }

    this.availableHousesValue[this.projectCode].forEach((house) => {
      const radioInput = `
        <div class="flex items-center gap-x-3">
          <input type="radio" id="house_${house.control_unit_sub_type_project_id}" name="house" value="${house.name}">
          <label for="house_${house.control_unit_sub_type_project_id}">${house.name} - ${house.minimum_lots} lotes - 
          [${this.formatAsCurrency(house.price, "Q", 2)} | ${this.formatAsCurrency(house.price_dollar, "$", 2)}] 
          </label>
        </div>`;
      this.availableHousesListTarget.innerHTML += radioInput;
    });

    this.modal.show();
  }

  validateLots() {
    this.projectCode = this.lots[0].split("-")[1];

    const invalidLots = this.lots.filter((lot) => {
      return lot.split("-")[1] !== this.projectCode;
    });

    if (invalidLots.length > 0) {
      alert(
        "Los lotes seleccionados no pertenecen al mismo proyecto: \n" +
          invalidLots.join(", "),
      );
      return false;
    }

    return true;
  }

  mergeLots() {
    const selectedHouse = document.querySelector('input[name="house"]:checked');
    if (!selectedHouse) {
      return alert("Seleccione una casa para fusionar los lotes");
    }

    const selectedHouseSubTypeProjectId = parseInt(
      selectedHouse.id.split("_")[1],
    );
    const house = this.availableHousesValue[this.projectCode].find(
      (house) =>
        house.control_unit_sub_type_project_id ===
        selectedHouseSubTypeProjectId,
    );

    if (!house) {
      return alert("Error al encontrar la casa seleccionada");
    }

    let customHouse = {
      id: house.id.toString(),
      name: house.name,
      price: house.price,
      price_dollar: house.price_dollar,
      lots: this.lots,
      types: [house.name],
      subtype_project_hash: { [house.name]: selectedHouseSubTypeProjectId },
    };

    let confirmation = confirm(
      `¿Está seguro que la casa entra dentro de las dimensiones de los lotes seleccionados?`,
    );

    if (confirmation) {
      const url = `/ventas/quotations/new?control_unit_codes[]=${this.controlUnits.join("&control_unit_codes[]=")}&custom_house=${JSON.stringify(customHouse)}`;
      window.location.href = url;
    }
  }
}
