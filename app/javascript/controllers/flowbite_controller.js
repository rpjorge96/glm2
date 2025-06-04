import { Controller } from "@hotwired/stimulus";

//This is for enable the datepicker when the page doesn't enable it automatically

export default class extends Controller {
  connect() {
    initFlowbite();
    this.initDatePicker();
    this.initDateRangePicker();
  }

  initDatePicker() {
    // Seleccionar todos los elementos con el atributo datepicker="true"
    const datePickers = this.element.querySelectorAll('[datepicker="true"]');
    datePickers.forEach((datepicker) => {
      // Verificar si el datepicker ya ha sido inicializado
      if (!datepicker.datepicker) {
        new Flowbite.default.Datepicker(datepicker, {
          format: "dd/mm/yyyy",
        });
        // Marcar el datepicker como inicializado
      }
    });
  }

  initDateRangePicker() {
    const dateRangePickers = this.element.querySelectorAll(".daterangepicker");
    dateRangePickers.forEach((daterangepicker) => {
      new Flowbite.default.DateRangePicker(daterangepicker, {
        format: "dd/mm/yyyy",
      });
    });
  }
}
