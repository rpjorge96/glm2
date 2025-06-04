import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "fieldsContainer",
    "extraPaymentsContainer",
    "downPaymentsContainer",
    "monthlyPaymentsContainer",
    "latePaymentsContainer",
    "capitalPaymentsContainer",
    "totalPaymentsContainer",
    "addButton",
  ];

  connect() {
    console.log("IdentificacionRegistralController connected");
  }

  addIdentificacionRegistral(event) {
    event.preventDefault();

    const newField = `
      <div class="identificacion_registral_field">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="descripcion">Descripción</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="text" name="control_unit[identificacion_registral][][descripcion]" id="descripcion">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="numero_de_finca">Número de Finca</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="text" name="control_unit[identificacion_registral][][numero_de_finca]" id="numero_de_finca">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="numero_de_folio">Número de Folio</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[identificacion_registral][][numero_de_folio]" id="numero_de_folio">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="numero_de_libro">Número de Libro</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[identificacion_registral][][numero_de_libro]" id="numero_de_libro">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="de_donde_es_el_libro">De Dónde es el Libro</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[identificacion_registral][][de_donde_es_el_libro]" id="de_donde_es_el_libro">
        </div>
          <a href="#" class="remove_fields" data-action="click->control-unit#removeIdentificacionRegistral" style="display: flex; align-items: center;">
            <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
            </svg>
            <span class="text-red-800 dark:text-red-300">Eliminar</span>
          </a>
      </div>
    `;
    this.fieldsContainerTarget.insertAdjacentHTML("beforeend", newField);
  }

  addExtraPayments(event) {
    event.preventDefault();
    const fieldCount = this.extraPaymentsContainerTarget.children.length;

    const newField = `
      <div class="extra_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][extra_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][extra_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][extra_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][extra_payments][][quantity]" id="quantity">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeExtraPayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.extraPaymentsContainerTarget.insertAdjacentHTML("beforeend", newField);
  }
  addDownPayments(event) {
    event.preventDefault();
    const fieldCount = this.downPaymentsContainerTarget.children.length;

    const newField = `
      <div class="down_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][down_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][down_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][down_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][down_payments][][quantity]" id="quantity">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeDownPayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.downPaymentsContainerTarget.insertAdjacentHTML("beforeend", newField);
  }
  addMonthlyPayments(event) {
    event.preventDefault();
    const fieldCount = this.monthlyPaymentsContainerTarget.children.length;

    const newField = `
      <div class="monthly_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][quantity]" id="quantity">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="late_payment">Mora</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][late_payment]" id="late_payment">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="interest">Interés</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][interest]" id="interest">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="capital">Capital</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][capital]" id="capital">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="others">Otros</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][monthly_payments][][others]" id="others">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeMonthlyPayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.monthlyPaymentsContainerTarget.insertAdjacentHTML(
      "beforeend",
      newField,
    );
  }
  addLatePayments(event) {
    event.preventDefault();
    const fieldCount = this.latePaymentsContainerTarget.children.length;

    const newField = `
      <div class="late_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][late_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][late_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][late_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][late_payments][][quantity]" id="quantity">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeLatePayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.latePaymentsContainerTarget.insertAdjacentHTML("beforeend", newField);
  }
  addCapitalPayments(event) {
    event.preventDefault();
    const fieldCount = this.capitalPaymentsContainerTarget.children.length;

    const newField = `
      <div class="capital_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][capital_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][capital_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][capital_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][capital_payments][][quantity]" id="quantity">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeCapitalPayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.capitalPaymentsContainerTarget.insertAdjacentHTML(
      "beforeend",
      newField,
    );
  }
  addTotalPayments(event) {
    event.preventDefault();
    const fieldCount = this.totalPaymentsContainerTarget.children.length;

    const newField = `
      <div class="total_payments_field grid gap-2 grid-cols-1 sm:grid-cols-2 xl:grid-cols-5">
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="num">No.</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="number" name="control_unit[control_unit_payment_detail_attributes][total_payments][][num]" id="num" value="${fieldCount + 1}" disabled>
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="date">Fecha</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500' type="date" name="control_unit[control_unit_payment_detail_attributes][total_payments][][date]" id="date">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="receipt_number">No. Recibo</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="number" name="control_unit[control_unit_payment_detail_attributes][total_payments][][receipt_number]" id="receipt_number">
        </div>
        <div>
          <label class='block mb-2 text-sm font-medium text-gray-900 dark:text-white' for="quantity">Cantidad</label>
          <input class='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'  type="text" name="control_unit[control_unit_payment_detail_attributes][total_payments][][quantity]" id="quantity">
        </div>
        <a href="#" class="remove_fields" data-action="click->control-unit#removeTotalPayments" style="display: flex; align-items: center;">
          <svg class="w-6 h-6 text-red-800 dark:text-red-300" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" viewBox="0 0 24 24">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"/>
          </svg>
          <span class="text-red-800 dark:text-red-300">Eliminar</span>
        </a>
      </div>
    `;
    this.totalPaymentsContainerTarget.insertAdjacentHTML("beforeend", newField);
  }

  removeIdentificacionRegistral(event) {
    event.preventDefault();
    event.target.closest(".identificacion_registral_field").remove();
  }
  removeExtraPayments(event) {
    event.preventDefault();
    event.target.closest(".extra_payments_field").remove();
  }
  removeDownPayments(event) {
    event.preventDefault();
    event.target.closest(".down_payments_field").remove();
  }
  removeMonthlyPayments(event) {
    event.preventDefault();
    event.target.closest(".monthly_payments_field").remove();
  }
  removeLatePayments(event) {
    event.preventDefault();
    event.target.closest(".late_payments_field").remove();
  }
  removeCapitalPayments(event) {
    event.preventDefault();
    event.target.closest(".capital_payments_field").remove();
  }
  removeTotalPayments(event) {
    event.preventDefault();
    event.target.closest(".total_payments_field").remove();
  }
}
