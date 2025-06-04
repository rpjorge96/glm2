import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["modalTitle", "toPay", "paymentsTotal", "missingTotal"];

  static values = {
    showView: Boolean,
  };

  modal = null;
  customPayments = {};
  financialEntity = null;
  controlUnit = null;
  monthlyPayment = null;
  finalPrice = null;
  currency = null;

  connect() {
    this.instantiateCustomPaymentsModal();
  }

  instantiateCustomPaymentsModal() {
    const $targetEl = document.getElementById("customPaymentsModal");
    const options = {
      placement: "center",
      backdrop: "dynamic",
      backdropClasses: "bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40",
      closable: true,
      onHide: () => {
        this.clearTable();
        this.monthlyPayments = {};
      },
      onShow: () => {},
      onToggle: () => {},
    };

    this.modal = new Modal($targetEl, options);
  }

  closeModal() {
    this.modal.hide();
  }

  clearTable() {
    let table = document.getElementById("custom_payments_table");
    for (let i = table.rows.length - 1; i >= 0; i--) {
      table.deleteRow(i);
    }
  }

  openModal({
    detail: {
      financialEntity,
      controlUnit,
      monthlyPayment,
      finalPrice,
      currency,
      withInterest,
      monthsToCession,
      paymentDay,
    },
  }) {
    this.financialEntity = financialEntity;
    this.controlUnit = controlUnit;
    this.monthlyPayment = monthlyPayment;
    this.finalPrice = finalPrice.toFixed(2);
    this.currency = currency;
    this.withInterest = withInterest;
    this.monthsToCession = monthsToCession;

    if (controlUnit.custom_payments) {
      this.customPayments =
        controlUnit.custom_payments[financialEntity.id] || {};
    } else {
      this.customPayments = {};
    }

    let table = document.getElementById("custom_payments_table");

    const months = this.getMonthsFromFinancialEntity(
      financialEntity,
      controlUnit,
      withInterest,
      monthsToCession,
    );

    for (let i = 1; i <= months; i++) {
      let row = table.insertRow(-1);
      row.className =
        "odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700";
      let paymentNumberCell = row.insertCell(0);
      let paymentDateCell = row.insertCell(1);
      let paymentValueCell = row.insertCell(2);

      paymentNumberCell.className = "px-3 whitespace-nowrap";
      paymentDateCell.className = "px-3 whitespace-nowrap";
      paymentValueCell.className = "px-3 w-1/3";

      let date = new Date();
      date.setMonth(date.getMonth() + i);
      date.setDate(1);

      let value = this.customPayments[i] || monthlyPayment;

      let input = document.createElement("input");
      input.className =
        "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500";
      input.type = "number";
      input.value = value;
      input.min = 0;
      input.onkeypress = (event) => {
        return event.charCode >= 48 && event.charCode <= 57;
      };

      input.addEventListener("change", (event) => {
        if (event.target.value < 0 || event.target.value === "") {
          event.target.value = 0;
        }

        event.target.value = Math.ceil(event.target.value);

        this.formatValue(event);

        this.setCustomPayment(
          i,
          event.target.value,
          controlUnit.code,
          financialEntity.id,
        );
        this.setModalValues(
          controlUnit.code,
          finalPrice,
          currency,
          monthlyPayment,
          months,
        );
      });

      const month = (date.getMonth() + 1).toString().padStart(2, "0"); // Ensure two digits
      const year = date.getFullYear();

      // if payment day is 31, make sure to set the last day of the month
      const day =
        paymentDay === 31
          ? new Date(year, date.getMonth() + 1, 0).getDate()
          : paymentDay;

      paymentDateCell.innerHTML = `${day}/${month}/${year}`;
      paymentNumberCell.innerHTML = i;

      if (this.showViewValue) {
        paymentValueCell.innerHTML = value;
      } else {
        paymentValueCell.appendChild(input);
      }
    }

    this.setModalValues(
      controlUnit.code,
      finalPrice,
      currency,
      monthlyPayment,
      months,
    );
    this.modal.show();
  }

  setModalValues(
    controlUnitCode,
    finalPrice,
    currency,
    monthlyPayment,
    months,
  ) {
    this.modalTitleTarget.textContent = `Pagos personalizados - ${controlUnitCode}`;
    this.toPayTarget.textContent =
      currency === "USD"
        ? this.formatAsCurrency(finalPrice, "$", 2)
        : this.formatAsCurrency(finalPrice, "Q", 2);

    let customPaymentsTotal = 0;
    for (let i = 1; i <= months; i++) {
      customPaymentsTotal +=
        this.customPayments[i] !== undefined
          ? parseFloat(this.customPayments[i])
          : parseFloat(monthlyPayment);
    }

    this.paymentsTotalTarget.textContent =
      currency === "USD"
        ? this.formatAsCurrency(customPaymentsTotal, "$", 2)
        : this.formatAsCurrency(customPaymentsTotal, "Q", 2);
    this.missingTotalTarget.textContent =
      currency === "USD"
        ? this.formatAsCurrency(customPaymentsTotal - finalPrice, "$", 2)
        : this.formatAsCurrency(customPaymentsTotal - finalPrice, "Q", 2);

    if (this.withInterest) this.updateDownPayment(customPaymentsTotal);

    if (customPaymentsTotal > finalPrice) {
      this.missingTotalTarget.className = "text-primary-500 basis-1/2";
    } else if (customPaymentsTotal < finalPrice) {
      this.missingTotalTarget.className = "text-red-500 basis-1/2";
    } else {
      this.missingTotalTarget.className =
        "text-gray-700 dark:text-gray-400 basis-1/2";
    }
  }

  clearValues() {
    let table = document.getElementById("custom_payments_table");
    for (let i = 0; i < table.rows.length; i++) {
      let row = table.rows[i];
      let cell = row.cells[2];
      let input = cell.children[0];
      input.value = 0;
      input.dispatchEvent(new Event("change"));
    }
  }

  resetValues() {
    let table = document.getElementById("custom_payments_table");
    for (let i = 0; i < table.rows.length; i++) {
      let row = table.rows[i];
      let cell = row.cells[2];
      let input = cell.children[0];
      input.value = this.monthlyPayment;
      input.dispatchEvent(new Event("change"));
    }

    this.dispatch("resetCustomPayments", {
      detail: {
        controlUnitCode: this.controlUnit.code,
        financialEntityId: this.financialEntity.id,
      },
    });
  }

  setCustomPayment(month, value, controlUnitCode, financialEntityId) {
    this.updateCustomPaymentsHash();
    this.dispatch("setCustomPayment", {
      detail: {
        customPayments: this.customPayments,
        controlUnitCode: controlUnitCode,
        financialEntityId: financialEntityId,
      },
    });
  }

  updateDownPayment(downPayment) {
    this.dispatch("updateDownPayment", {
      detail: {
        downPayment: downPayment,
        financialEntityId: this.financialEntity.id,
        controlUnitCode: this.controlUnit.code,
      },
    });
  }

  updateCustomPaymentsHash() {
    const table = document.getElementById("custom_payments_table");
    for (let i = 0; i < table.rows.length; i++) {
      const row = table.rows[i];
      const input = row.cells[2].children[0];
      const month = i + 1;
      this.customPayments[month] = parseFloat(input.value).toFixed(2);
    }
  }

  getMonthsFromFinancialEntity(
    financialEntity,
    controlUnit,
    withInterest,
    monthsToCession,
  ) {
    if (
      financialEntity?.custom_hash?.[controlUnit.id]?.months_to_pay &&
      !withInterest
    ) {
      return financialEntity.custom_hash[controlUnit.id].months_to_pay;
    } else if (
      financialEntity.custom_hash?.[controlUnit.id]?.months_to_cession &&
      withInterest
    ) {
      return financialEntity.custom_hash[controlUnit.id].months_to_cession;
    } else {
      return withInterest
        ? monthsToCession
        : financialEntity.months_to_pay_down_payment;
    }
  }
}
