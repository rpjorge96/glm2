import ApplicationController from "controllers/application_controller";
import CustomPaymentsController from "controllers/quotation/custom_payments_controller";
import CustomFinancialEntityHelper from "custom_financial_entity_helper";

export default class extends ApplicationController {
  static targets = [
    "clientName",
    "downPaymentPercentage",
    "totalDownPayment",
    "durationInYears",
    "financialEntity",
    "monthlyPayment",
    "hiddenMonthlyPayment",
    "interestRate",
    "financingType",
    "yearsToFinance",
    "downPaymentMonths",
    "monthlyDownPayment",
    "totalDownPaymentDiscount",
    "quotationParams",
    "hideIfCashPayment",
    "cashValue",
    "discount",
    "total",
    "financingTitle",
    "remainingBalance",
    "currency",
    "financingCashTable",
    "clientPhoneExtension",
    "monthsToCessionTarget",
    "extrasModalTitle",
    "extrasModalTable",
    "yearsToFinanceDiv",
    "paymentDayDiv",
    "financingFinancedTable",
    "cashEntitiesTable",
    "financedEntitiesTable",
    "paymentDay",
  ];

  static values = {
    showView: Boolean,
    pdfView: Boolean,
    financialEntities: Array,
    paramsYearsToFinance: Array,
    paramsFinancialEntities: Array,
    controlUnits: Array,
    controlUnitCodes: Array,
    quotationParams: String,
    maxAllowedDiscountPercentage: Number,
  };

  preventActionTargets = ["clientName", "paymentDayDiv", "yearsToFinance"];

  financialEntities = [];
  availableFinancialEntities = [];
  lastAddedFinancialEntityId = null;
  yearsToFinance = [];
  isCalculatorPage = false;
  currency = "GTQ";
  priceCurrencyValue = "Q";
  controlUnits = [];
  availableControlUnits = [];
  extrasModal = null;
  hasForm = false;
  customPaymentsController = new CustomPaymentsController();
  monthsToCessionHash = {};
  sale_total = 0;
  discount_total = 0;
  discount_status = null;
  discount_authorization_comment = "";
  calcValues = {};
  minimumDownPaymentError = false;

  connect() {
    this.hasForm =
      window.location.pathname.includes("new") ||
      window.location.pathname.includes("edit");
    this.isCalculatorPage = window.location.pathname === "/ventas/quotations";
    this.fillMonthsToCessionHash();
    if (this.hasForm) {
      this.resetAvailableFinancialEntities();
      this.addGridColsToCashFinancingTable();
      this.addGridColsToInterestFinancingTable();
      this.instantiateExtrasModal();
    } else if (this.showViewValue) {
      this.addGridColsToCashFinancingTable();
      this.addGridColsToInterestFinancingTable();
      this.updateFinancialEntitiesFromParams();
      this.setCashTableContent();
      this.setInterestTableContent();
    }

    this.checkParams();
    this.resetCalculator();
    this.changeCurrency();
    this.triggerCalculations();

    // this fixes bug when updating form not saving the months to cession
    if (this.hasForm) {
      this.controlUnits.forEach((controlUnit) => {
        this.addMonthsToCessionToControlUnit(controlUnit.code);
      });
    }

    this.setPreventAction();
    this.openAndCloseCustomPaymentsModal();
  }

  openAndCloseCustomPaymentsModal() {
    let div = document.getElementById(
      "interest_financing_table_custom_payments_button",
    );
    const button = div.querySelector("button");
    if (!button) return;

    button.dispatchEvent(new Event("click"));
    const closeButton = document.getElementById("closeCustomPaymentsModal");
    closeButton.dispatchEvent(new Event("click"));
  }

  setPreventAction() {
    this.preventActionTargets.forEach((targetName) => {
      const elements = this[`${targetName}Targets`];
      elements.forEach((el) => {
        el.addEventListener("keydown", this.preventActionOnEnter);
      });
    });

    this.yearsToFinanceTarget.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        this.addYearsToFinance();
      }
    });
  }

  preventActionOnEnter(event) {
    if (event.key === "Enter") {
      event.preventDefault();
    }
  }

  checkParams() {
    if (this.quotationParamsValue !== "") {
      const params = JSON.parse(this.quotationParamsValue);
      this.discount_total = params.discount_total;

      if (params.currency) this.currency = params.currency;
      if (params.discount_status !== undefined)
        this.discount_status = params.discount_status;

      if (!this.showViewValue) {
        this.currencyTarget.value = this.currency;
        this.updateFinancialEntitiesFromParams();
        this.updateYearsToFinanceFromParams();
      }

      if (this.showViewValue) {
        this.yearsToFinance = params.years_to_finance;
      }

      this.setFinancingType();
    }
  }

  fillMonthsToCessionHash() {
    if (this.quotationParamsValue === "") return;
    const params = JSON.parse(this.quotationParamsValue);
    params.control_units.forEach((controlUnit) => {
      this.monthsToCessionHash[controlUnit.code] =
        controlUnit.months_to_cession;
    });
  }

  updateYearsToFinanceFromParams() {
    if (this.paramsYearsToFinanceValue.length > 0) {
      this.paramsYearsToFinanceValue.forEach((years) => {
        this.yearsToFinanceTarget.value = years;
        this.addYearsToFinance();
      });
    }
  }

  updateFinancialEntitiesFromParams() {
    if (this.paramsFinancialEntitiesValue.length > 0) {
      // set financing type from the first financial entity
      this.financingTypeTarget.value =
        this.paramsFinancialEntitiesValue[0].financing_type;

      this.paramsFinancialEntitiesValue.forEach((financialEntity) => {
        if (this.hasForm) this.addFinancialEntityToTable(financialEntity);
        this.financialEntities.push(financialEntity);
        this.availableFinancialEntities =
          this.availableFinancialEntities.filter(
            (entityId) => entityId !== financialEntity.id,
          );
      });
      if (this.hasForm) this.updateAvailableFinancialEntities();
    }
  }

  clearFinancialEntitiesTable() {
    let table = document.getElementById("financial_entities_cash_table");
    while (table.rows.length > 1) {
      table.deleteRow(1);
    }

    table = document.getElementById("financial_entities_financed_table");
    while (table.rows.length > 1) {
      table.deleteRow(1);
    }
  }

  setFinancialEntitiesTableContent() {
    this.clearFinancialEntitiesTable();
    this.financialEntities.forEach((financialEntity) => {
      this.addFinancialEntityToTable(financialEntity);
    });
  }

  resetAvailableFinancialEntities() {
    this.clearFinancialEntitiesTable();
    this.financialEntities = [];
    this.availableFinancialEntities = this.financialEntitiesValue.map(
      (financialEntity) => financialEntity.id,
    );
    this.updateAvailableFinancialEntities();
    this.setFinancingType();
    this.resetAllControlUnitCustomPayments();
    this.setControlUnitsTableContent();

    const controlUnitsCashTable = document.getElementById(
      "control_units_cash_table_container",
    );

    const controlUnitsFinancedTable = document.getElementById(
      "control_units_financed_table_container",
    );

    if (this.financingTypeTarget.value === "financed") {
      controlUnitsCashTable.style.display = "none";
      controlUnitsFinancedTable.style.display = "block";
    } else {
      controlUnitsCashTable.style.display = "block";
      controlUnitsFinancedTable.style.display = "none";
    }
  }

  setFinancingType() {
    let financingType = this.financingTypeTarget.value;
    switch (financingType) {
      case "cash":
        this.financingCashTableTarget.style.display = "block";
        this.financingFinancedTableTarget.style.display = "none";
        if (!this.showViewValue) {
          this.cashEntitiesTableTarget.style.display = "block";
          this.financedEntitiesTableTarget.style.display = "none";
          this.yearsToFinanceDivTarget.style.display = "none";
        }
        break;
      case "financed":
        this.financingCashTableTarget.style.display = "none";
        this.financingFinancedTableTarget.style.display = "block";
        if (!this.showViewValue) {
          this.cashEntitiesTableTarget.style.display = "none";
          this.financedEntitiesTableTarget.style.display = "block";
          this.yearsToFinanceDivTarget.style.display = "block";
        }
        break;
      default:
        this.financingCashTableTarget.style.display = "none";
        this.financingFinancedTableTarget.style.display = "none";
        this.cashEntitiesTableTarget.style.display = "none";
        this.financedEntitiesTableTarget.style.display = "none";
        break;
    }
  }

  updateAvailableFinancialEntities() {
    let available = this.financialEntitiesValue.filter((financialEntity) => {
      return (
        financialEntity.financing_type === this.financingTypeTarget.value &&
        this.availableFinancialEntities.includes(financialEntity.id)
      );
    });

    while (this.financialEntityTarget.firstChild) {
      this.financialEntityTarget.removeChild(
        this.financialEntityTarget.firstChild,
      );
    }

    available.unshift({ id: "", name: "Seleccione una" });

    available.forEach((financialEntity) => {
      let option = document.createElement("option");
      option.value = financialEntity.id;
      option.text = financialEntity.name;
      this.financialEntityTarget.appendChild(option);
    });
  }

  addFinancialEntity(event) {
    event.preventDefault();

    let financialEntity = this.financialEntitiesValue.find(
      (financialEntity) => {
        return (
          financialEntity.id === parseInt(this.financialEntityTarget.value)
        );
      },
    );

    if (financialEntity === undefined) return;

    this.addFinancialEntityToTable(financialEntity);
    this.availableFinancialEntities = this.availableFinancialEntities.filter(
      (entityId) => entityId !== financialEntity.id,
    );
    this.financialEntities.push(financialEntity);
    this.updateAvailableFinancialEntities();
    this.lastAddedFinancialEntityId = financialEntity.id;
    this.changeFinancialEntity();
    this.setCashTableContent();
    this.setInterestTableContent();
    this.setControlUnitsTableContent();
  }

  addFinancialEntityToTable(financialEntity) {
    let tableId, fields;

    if (this.financingTypeTarget.value === "cash") {
      tableId = "financial_entities_cash_table";
      fields = [
        { name: "Nombre de Entidad Financiera", value: financialEntity.name },
        {
          name: "Porcentaje de Pago Inicial",
          value: parseFloat(financialEntity.initial_payment_percentage).toFixed(
            2,
          ),
        },
        {
          name: "Meses para Pagar Enganche",
          value: parseInt(financialEntity.months_to_pay_down_payment).toFixed(
            2,
          ),
        },
      ];
    } else if (this.financingTypeTarget.value === "financed") {
      tableId = "financial_entities_financed_table";
      fields = [
        { name: "Nombre de Entidad Financiera", value: financialEntity.name },
        {
          name: "Porcentaje de Pago Inicial",
          value: parseFloat(financialEntity.initial_payment_percentage).toFixed(
            2,
          ),
        },
        {
          name: "Porcentaje de Enganche Mínimo",
          value: parseFloat(financialEntity.down_payment_percentage).toFixed(2),
        },
        {
          name: "Tasa de Interés Anual",
          value: parseFloat(financialEntity.annual_interest_rate).toFixed(2),
        },
        {
          name: "Cuota de Enganche Mínimo",
          value:
            this.currency === "USD"
              ? this.formatAsCurrency(
                  financialEntity.minimum_down_payment_dollar,
                  "$",
                  2,
                )
              : this.formatAsCurrency(
                  financialEntity.minimum_down_payment,
                  "Q",
                  2,
                ),
        },
        {
          name: "Máximo de Años a Financiar",
          value: financialEntity.maximum_years_to_finance,
        },
      ];
    } else {
      return;
    }

    let table = document.getElementById(tableId);
    let row = table.insertRow(-1);
    row.className =
      "odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700";

    fields.forEach((field, index) => {
      let cell = row.insertCell(index);
      cell.textContent = field.value;
      cell.className = "px-3 py-3";
    });

    let deleteCell = row.insertCell(fields.length);
    deleteCell.className = "px-3 py-3";

    let deleteButton = document.createElement("button");
    deleteButton.textContent = "Eliminar";
    deleteButton.className =
      "font-medium text-red-600 dark:text-red-500 hover:underline";

    deleteButton.addEventListener("click", (event) => {
      event.preventDefault();
      this.deleteFinancialEntity(row, financialEntity.id);
    });

    deleteCell.appendChild(deleteButton);
  }

  deleteFinancialEntity(row, financialEntityId) {
    row.remove();
    this.availableFinancialEntities.push(financialEntityId);
    this.updateAvailableFinancialEntities();
    this.financialEntities = this.financialEntities.filter(
      (financialEntity) => {
        return financialEntity.id !== financialEntityId;
      },
    );
    this.setCashTableContent();
    this.setInterestTableContent();
    this.setControlUnitsTableContent();
  }

  addYearsToFinance(event) {
    if (event) event.preventDefault();

    let years = parseInt(this.yearsToFinanceTarget.value);

    if (this.yearsToFinance.length > 2) {
      this.createToast(
        "error",
        "No se puede agregar más de 3 años a financiar.",
      );
      return;
    }

    if (this.yearsToFinance.includes(years) || years < 1) {
      return;
    }

    let list = document.getElementById("years_to_finance_list");
    let listItem = document.createElement("li");
    listItem.textContent = `a ${years} años | `;

    let removeButton = document.createElement("button");
    removeButton.textContent = "Eliminar";
    removeButton.className =
      "font-medium text-red-600 dark:text-red-500 hover:underline";

    removeButton.addEventListener("click", (event) => {
      event.preventDefault();
      this.removeYearsFromFinance(listItem, years);
    });

    listItem.appendChild(removeButton);
    list.appendChild(listItem);
    this.yearsToFinance.push(years);
    this.setInterestTableContent();
  }

  removeYearsFromFinance(listItem, years) {
    listItem.remove();
    this.yearsToFinance = this.yearsToFinance.filter((year) => year !== years);
    this.setInterestTableContent();
  }

  changeFinancialEntity() {
    this.downPaymentPercentageTarget.value = parseFloat(
      this.financialEntity.down_payment_percentage,
    ).toFixed(2);
    this.interestRateTarget.value = parseFloat(
      this.financialEntity.annual_interest_rate,
    ).toFixed(2);

    this.triggerCalculations();
  }

  triggerCalculations() {
    this.calculateTotal();
    this.checkIfCashPayment();
    this.calculateDownPayment();
    this.calculateMonthlyDownPayment();
    this.calculateMonthlyPayment();
    this.calculateRemainingBalance();
  }

  calculateTotal() {
    this.totalTarget.value = this.formatAsCurrency(
      this.total,
      this.priceCurrencyValue,
      2,
    );
  }

  checkIfCashPayment() {
    if (this.downPaymentPercentage === 100) {
      this.hideIfCashPaymentTarget.style.display = "none";
    } else {
      this.hideIfCashPaymentTarget.style.display = "block";
    }
  }

  calculateDownPayment() {
    let downPayment = (this.total * this.downPaymentPercentage) / 100;
    this.totalDownPaymentTarget.value = this.formatAsCurrency(
      downPayment,
      this.priceCurrencyValue,
      2,
    );
  }

  calculateMonthlyDownPayment() {
    let monthlyDownPayment =
      this.downPayment / parseInt(this.downPaymentMonthsTarget.value);
    this.monthlyDownPaymentTarget.value = this.formatAsCurrency(
      monthlyDownPayment,
      this.priceCurrencyValue,
      2,
    );
  }

  calculateMonthlyPayment() {
    let n = parseInt(this.durationInYearsTarget.value) * 12;
    let apr = this.interestRatePercentage / 100;
    let pv = this.total - this.downPayment;

    let pmt = this.pmt(apr / 12, n, pv, 0, 0);

    this.hiddenMonthlyPaymentTarget.value = pmt.toFixed(2);
    this.monthlyPaymentTarget.value = this.formatAsCurrency(
      pmt,
      this.priceCurrencyValue,
      2,
    );
  }

  updateDownPaymentFromMonthly() {
    let monthlyDownPayment = this.monthlyDownPaymentTarget.value.replace(
      /,/g,
      "",
    );
    let newDownPaymentPercentage =
      ((monthlyDownPayment * parseInt(this.downPaymentMonthsTarget.value)) /
        this.total) *
      100;
    this.downPaymentPercentageTarget.value =
      newDownPaymentPercentage.toFixed(2);
    this.calculateDownPayment();
    this.calculateRemainingBalance();
    this.calculateMonthlyPayment();
  }

  updateDownPaymentFromTotal() {
    let downPayment = this.totalDownPaymentTarget.value.replace(/,/g, "");
    let newDownPaymentPercentage = (downPayment / this.total) * 100;
    this.downPaymentPercentageTarget.value =
      newDownPaymentPercentage.toFixed(2);
    this.calculateMonthlyDownPayment();
    this.calculateRemainingBalance();
    this.calculateMonthlyPayment();
  }

  calculateRemainingBalance() {
    let remainingBalance = this.total - this.downPayment;
    this.remainingBalanceTarget.value = this.formatAsCurrency(
      remainingBalance,
      this.priceCurrencyValue,
      2,
    );
  }

  pmt(rate, nper, pv, fv, type) {
    /*
     * rate   - interest rate per month
     * nper   - number of periods (months)
     * pv   - present value
     * fv   - future value
     * type - when the payments are due:
     *        0: end of the period, e.g. end of month (default)
     *        1: beginning of period
     */
    let pmt, pvif;

    fv || (fv = 0);
    type = 1;

    if (rate === 0) return -(pv + fv) / nper;

    pvif = Math.pow(1 + rate, nper);
    pmt = (-rate * (pv * pvif + fv)) / (pvif - 1);

    if (type === 1) pmt /= 1 + rate;
    return pmt * -1;
  }

  changeCurrency() {
    if (this.currencyTarget.value != undefined) {
      this.currency = this.currencyTarget.value;
    }
    switch (this.currency) {
      case "USD":
        this.priceCurrencyValue = "$";
        break;
      case "GTQ":
        this.priceCurrencyValue = "Q";
        break;
    }

    if (window.location.pathname !== "/ventas/calculator") {
      this.resetAvailableControlUnits();
    }

    if (this.hasForm) {
      this.setFinancialEntitiesTableContent();
    }
    this.setCashTableContent();
    this.setInterestTableContent();
    this.triggerCalculations();
  }

  resetAvailableControlUnits() {
    if (this.hasForm) {
      const tableId =
        this.financingTypeTarget.value === "financed"
          ? "control_units_financed_table"
          : "control_units_cash_table";

      let table = document.getElementById(tableId);
      while (table.rows.length > 1) {
        table.deleteRow(1);
      }
    }

    this.availableControlUnits = this.controlUnitsValue.map(
      (controlUnit) => controlUnit.code,
    );

    this.controlUnits = [];
    this.controlUnitCodesValue.forEach((code) => {
      if (code !== "") this.addControlUnit(null, code);
    });

    this.setCashTableContent();
    this.setInterestTableContent();
  }

  setControlUnitsTableContent() {
    const tableId =
      this.financingTypeTarget.value === "financed"
        ? "control_units_financed_table"
        : "control_units_cash_table";

    let table = document.getElementById(tableId);
    while (table.rows.length > 1) {
      table.deleteRow(1);
    }

    this.controlUnits.forEach((controlUnit) => {
      this.addControlUnitToTable(controlUnit);
    });
  }

  // Se comenta porque ya no se usa el dropdown para elegir las unidades de control
  // updateAvailableControlUnits() {
  //   let available = this.controlUnitsValue.filter((controlUnit) => {
  //     return this.availableControlUnits.includes(controlUnit.code);
  //   });
  //
  //   available.unshift({ id: "", code: "Seleccione una" });
  //
  //   while (this.controlUnitTarget.firstChild) {
  //     this.controlUnitTarget.removeChild(this.controlUnitTarget.firstChild);
  //   }
  //
  //   available.forEach((controlUnit) => {
  //     let option = document.createElement("option");
  //     option.value = controlUnit.code;
  //     option.text = controlUnit.code;
  //     this.controlUnitTarget.appendChild(option);
  //   });
  //   this.setCashTableContent();
  //   this.setInterestTableContent();
  // }

  addControlUnit(event, code) {
    if (event) event.preventDefault();

    if (code === undefined) code = this.controlUnitTarget.value;

    let controlUnit = this.controlUnitsValue.find((controlUnit) => {
      return controlUnit.code === code;
    });

    if (controlUnit === undefined) return;

    if (this.hasForm) this.addControlUnitToTable(controlUnit);
    this.controlUnits.push(controlUnit);
    this.availableControlUnits = this.availableControlUnits.filter(
      (unitCode) => unitCode !== controlUnit.code,
    );

    if (controlUnit.lots) {
      controlUnit.lots.forEach((lot) => {
        this.availableControlUnits = this.availableControlUnits.filter(
          (unitCode) => unitCode !== lot.code,
        );
      });
    }
  }

  interest_financing_table_ids = [
    "interest_financing_table_control_unit",
    "interest_financing_table_price",
    "interest_financing_table_extras_total",
    "interest_financing_table_total",
    "interest_financing_table_discount",
    "interest_financing_table_total_after_discount",
    "interest_financing_table_initial_payment_percentage",
    "interest_financing_table_initial_payment_total",
    "interest_financing_table_down_payment_months",
    "interest_financing_table_down_payment_percentage",
    "interest_financing_table_down_payment_total",
    "interest_financing_table_down_payment_monthly_payment",
    "interest_financing_table_to_pay",
    "interest_financing_table_to_finance",
    "interest_financing_table_name",
    "interest_financing_table_annual_interest_rate",
    "interest_financing_table_years",
    "interest_financing_table_custom_payments_button",
    "interest_financing_table_initial_pay",
  ];

  financing_cash_table_ids = [
    "cash_financing_table_control_unit",
    "cash_financing_table_price",
    "cash_financing_table_total",
    "cash_financing_table_months",
    "cash_financing_table_discount",
    "cash_financing_table_total_after_discount",
    "cash_financing_table_to_pay",
    "cash_financing_table_monthly_payment",
    "cash_financing_table_extras_total",
    "cash_financing_table_name",
    "cash_financing_table_custom_payments_button",
    "cash_financing_table_initial_payment_percentage",
    "cash_financing_table_initial_payment_total",
    "cash_financing_table_initial_pay",
  ];

  setCashTableContent() {
    const backgroundColor = this.pdfViewValue
      ? ""
      : " bg-sky-100 dark:bg-sky-950";
    this.resetFinancingTable();
    this.controlUnits.forEach((controlUnit, index) => {
      this.addControlUnitToCashFinancingTable(
        controlUnit,
        index % 2 === 0 ? backgroundColor : "",
      );
    });
    this.checkIfEmptyCustomPayments();
  }

  setInterestTableContent() {
    const backgroundColor = this.pdfViewValue
      ? ""
      : " bg-sky-100 dark:bg-sky-950";
    this.resetInterestTable();
    this.controlUnits.forEach((controlUnit, index) => {
      this.addControlUnitToInterestFinancingTable(
        controlUnit,
        index % 2 === 0 ? backgroundColor : "",
      );
    });
    this.checkIfEmptyCustomPayments();
  }

  checkIfEmptyCustomPayments() {
    if (this.hasForm) return;

    let hasCustomPayments = false;
    this.controlUnits.forEach((controlUnit) => {
      if (
        controlUnit.custom_payments &&
        Object.keys(controlUnit.custom_payments).length > 0
      ) {
        hasCustomPayments = true;
      }
    });

    const cashCustomPaymentsButton = document.getElementById(
      "cash_financing_table_custom_payments_button",
    );

    const interestCustomPaymentsButton = document.getElementById(
      "interest_financing_table_custom_payments_button",
    );

    if (!hasCustomPayments) {
      cashCustomPaymentsButton.style.display = "none";
      interestCustomPaymentsButton.style.display = "none";
    } else {
      cashCustomPaymentsButton.style.display = "";
      interestCustomPaymentsButton.style.display = "";
    }
  }

  resetFinancingTable() {
    this.financing_cash_table_ids.forEach((id) => {
      let row = document.getElementById(id);
      if (row && row.children.length > 1) {
        while (row.children.length > 1) {
          row.removeChild(row.lastChild);
        }
      }
    });
  }

  resetInterestTable() {
    this.interest_financing_table_ids.forEach((id) => {
      let row = document.getElementById(id);
      if (row && row.children.length > 1) {
        while (row.children.length > 1) {
          row.removeChild(row.lastChild);
        }
      }
    });

    // Remove all divs after the one with id='interest_financing_table_monthly_payment'
    let targetDiv = document.getElementById(
      "interest_financing_table_annual_interest_rate",
    );
    let sibling = targetDiv.nextElementSibling;

    while (sibling) {
      let nextSibling = sibling.nextElementSibling;
      sibling.remove();
      sibling = nextSibling;
    }

    // Add the years divs
    let containerDiv =
      this.financingFinancedTableTarget.children[1].children[0];
    this.yearsToFinance.forEach((year) => {
      let div = document.createElement("div");
      div.className =
        "grid grid-flow-col-dense auto-cols-fr text-sm text-gray-700 border-b border-gray-200 dark:border-gray-700";
      div.id = `interest_financing_table_years_${year}`;

      let textDiv = document.createElement("div");
      textDiv.className = "text-gray-500 dark:text-gray-400 p-2";
      textDiv.textContent = `${year} años`;

      div.appendChild(textDiv);
      containerDiv.appendChild(div);
    });
  }

  addGridColsToCashFinancingTable() {
    let gridClass = `grid grid-flow-col-dense auto-cols-fr text-sm text-gray-700 border-b border-gray-200 dark:border-gray-700`;

    this.financing_cash_table_ids.forEach((id) => {
      let row = document.getElementById(id);
      if (row) {
        row.className = gridClass;

        if (id === "cash_financing_table_name") {
          row.className += " border-t-4";
        } else if (id === "cash_financing_table_control_unit") {
          row.className +=
            " font-medium text-gray-900 dark:text-white bg-gray-100 border-t border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700 dark:text-white";
        }
      }
    });
  }

  addGridColsToInterestFinancingTable() {
    let gridClass = `grid grid-flow-col-dense auto-cols-fr text-sm text-gray-700 border-b border-gray-200 dark:border-gray-700`;

    this.interest_financing_table_ids.forEach((id) => {
      let row = document.getElementById(id);
      if (row) {
        row.className = gridClass;

        if (
          id === "interest_financing_table_name" ||
          id === "interest_financing_table_initial_pay" ||
          id === "interest_financing_table_annual_interest_rate"
        ) {
          row.className += " border-t-4";
        } else if (id === "interest_financing_table_control_unit") {
          row.className +=
            " font-medium text-gray-900 dark:text-white bg-gray-100 border-t border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700 dark:text-white";
        }
      }
    });
  }

  addControlUnitToCashFinancingTable(controlUnit, backgroundColor = "") {
    const financingType = this.financingTypeTarget.value;
    if (financingType === "financed") return;

    backgroundColor = backgroundColor + " p-2";

    let extraLength =
      this.financialEntities.length == 0
        ? 0
        : this.financialEntities.length - 1;
    let textContents = [controlUnit.code, ...Array(extraLength).fill("")];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "cash_financing_table_control_unit",
        textContent,
        backgroundColor,
      ),
    );

    let extras = [];

    if (controlUnit.is_custom_house) {
      controlUnit.types.forEach((type) => {
        extras.push(...controlUnit.extras[type]);
      });
    } else {
      extras = controlUnit.extras;
    }

    let extrasTotal = extras.reduce((acc, extra) => {
      if (extra.apply) {
        let extraPrice =
          this.currency === "USD" ? extra.price_dollar : extra.price;
        let extraTotal = extraPrice * (extra.quantity || 1);
        return acc + extraTotal;
      }
      return acc;
    }, 0);
    this.calcValues["extrasTotal"] = extrasTotal;

    let controlUnitPrice =
      this.currency === "USD" ? controlUnit.price_dollar : controlUnit.price;
    this.calcValues["controlUnitPrice"] = controlUnitPrice;
    let finalTotal = controlUnitPrice + extrasTotal;
    this.calcValues["finalTotal"] = finalTotal;

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(extrasTotal, "$", 2)
        : this.formatAsCurrency(extrasTotal, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "cash_financing_table_extras_total",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(controlUnit.price_dollar, "$", 2)
        : this.formatAsCurrency(controlUnit.price, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "cash_financing_table_price",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(finalTotal, "$", 2)
        : this.formatAsCurrency(finalTotal, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "cash_financing_table_total",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    const discountAmount = this.discount_total || 0;
    let priceAfterDiscount = finalTotal - discountAmount;
    this.sale_total = finalTotal;

    if (!controlUnit.discount) {
      controlUnit.discount = discountAmount;
    }

    const discountObject = CustomFinancialEntityHelper.createDiscountField(
      controlUnit,
      backgroundColor,
      this.showViewValue,
      this.setCashTableContent.bind(this),
      this.currency === "USD" ? "$" : "Q",
      finalTotal * (this.maxAllowedDiscountPercentageValue / 100),
      this.discount_status,
      this.openDiscountAuthorizationModal.bind(this),
      this.updateDiscountStatus.bind(this),
    );

    this.calcValues["discountAmount"] = controlUnit.discount;
    this.calcValues["priceAfterDiscount"] = finalTotal - controlUnit.discount;
    if (!this.discount_total) {
      priceAfterDiscount = finalTotal - controlUnit.discount;
    }

    this.createAndAppendDiv(
      "cash_financing_table_discount",
      discountObject,
      backgroundColor.replace(" p-2", ""),
      false,
      true,
      extraLength,
    );

    const formattedPriceAfterDiscount =
      this.currency === "USD"
        ? this.formatAsCurrency(priceAfterDiscount, "$", 2)
        : this.formatAsCurrency(priceAfterDiscount, "Q", 2);

    this.createAndAppendDiv(
      "cash_financing_table_total_after_discount",
      formattedPriceAfterDiscount,
      "text-gray-500 dark:text-gray-400" + backgroundColor,
      false,
      false,
      extraLength,
    );

    this.financialEntities.forEach((financialEntity) => {
      if (financialEntity.custom_hash?.[controlUnit.id]?.initial_payment) {
        priceAfterDiscount -=
          financialEntity.custom_hash?.[controlUnit.id]?.initial_payment;
      }

      const initialPayment = Math.ceil(
        priceAfterDiscount *
          (parseFloat(financialEntity.initial_payment_percentage) / 100),
      );
      this.calcValues[financialEntity.id] = {};
      this.calcValues[financialEntity.id]["initialPayment"] = initialPayment;

      let finalPrice = finalTotal - discountAmount - initialPayment;
      if (financialEntity.custom_hash?.[controlUnit.id]?.initial_payment) {
        const initialCustomPayment =
          financialEntity.custom_hash?.[controlUnit.id]?.initial_payment;
        finalPrice -= initialCustomPayment;
        this.calcValues[financialEntity.id]["initialCustomPayment"] =
          initialCustomPayment;
      }
      this.calcValues[financialEntity.id]["finalPrice"] = finalPrice;

      const monthsToPayDownPayment =
        financialEntity.custom_hash?.[controlUnit.id]?.checked &&
        financialEntity.custom_hash?.[controlUnit.id]?.months_to_pay != null
          ? financialEntity.custom_hash?.[controlUnit.id]?.months_to_pay
          : financialEntity.months_to_pay_down_payment;
      this.calcValues[financialEntity.id]["monthsToPayDownPayment"] =
        monthsToPayDownPayment;

      const monthlyPayment = Math.ceil(
        finalPrice / parseFloat(monthsToPayDownPayment),
      );
      this.calcValues[financialEntity.id]["monthlyPayment"] = monthlyPayment;
      const formattedFinalPrice =
        this.currency === "USD"
          ? this.formatAsCurrency(finalPrice, "$", 2)
          : this.formatAsCurrency(finalPrice, "Q", 2);
      let formattedMonthlyPayment =
        this.currency === "USD"
          ? this.formatAsCurrency(monthlyPayment, "$", 2)
          : this.formatAsCurrency(monthlyPayment, "Q", 2);
      const formattedInitialPayment =
        this.currency === "USD"
          ? this.formatAsCurrency(initialPayment, "$", 2)
          : this.formatAsCurrency(initialPayment, "Q", 2);

      const financialEntityTitleObject =
        CustomFinancialEntityHelper.createTitle(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setCashTableContent.bind(this),
        );

      const monthsToPayObject =
        CustomFinancialEntityHelper.createMonthsToPayCashTable(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setCashTableContent.bind(this),
        );

      const initialPaymentObject =
        CustomFinancialEntityHelper.createInitialPaymentField(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setCashTableContent.bind(this),
          this.currency === "USD" ? "$" : "Q",
        );

      this.createAndAppendDiv(
        "cash_financing_table_name",
        financialEntityTitleObject,
        null,
        false,
        true,
      );

      this.createAndAppendDiv(
        "cash_financing_table_initial_pay",
        initialPaymentObject,
        null,
        false,
        true,
      );

      this.createAndAppendDiv(
        "cash_financing_table_months",
        monthsToPayObject,
        null,
        false,
        true,
      );
      this.createAndAppendDiv(
        "cash_financing_table_initial_payment_percentage",
        `${financialEntity.initial_payment_percentage}%`,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "cash_financing_table_initial_payment_total",
        formattedInitialPayment,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "cash_financing_table_to_pay",
        formattedFinalPrice,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      let customPaymentsButton = document.createElement("button");
      customPaymentsButton.textContent = "Pagos Variables";
      customPaymentsButton.className =
        "font-medium text-blue-600 dark:text-blue-500 hover:underline";

      customPaymentsButton.addEventListener("click", (event) => {
        event.preventDefault();
        this.dispatch("openCustomPaymentsModal", {
          detail: {
            financialEntity: financialEntity,
            controlUnit: controlUnit,
            monthlyPayment: monthlyPayment.toFixed(2),
            finalPrice: finalPrice,
            currency: this.currency,
            paymentDay: this.paymentDay,
          },
        });
      });

      let customPaymentsDiv = document.getElementById(
        "cash_financing_table_custom_payments_button",
      );

      let showButton = false;
      if (
        controlUnit.custom_payments &&
        controlUnit.custom_payments[financialEntity.id] != null
      ) {
        formattedMonthlyPayment = "Tiene Pagos Variables";
        showButton = true;
      }

      if ((!this.showViewValue || showButton) && !this.pdfViewValue) {
        customPaymentsDiv.className =
          "grid grid-flow-col-dense auto-cols-fr text-sm text-gray-700 border-b border-gray-200 dark:border-gray-700";
        this.createAndAppendDiv(
          "cash_financing_table_custom_payments_button",
          customPaymentsButton,
          "text-gray-900 dark:text-white" + backgroundColor,
          false,
          true,
        );
      } else if (this.pdfViewValue) {
        customPaymentsDiv.innerHTML = "";
      } else {
        let hiddenDiv = document.createElement("div");
        hiddenDiv.className = "";
        customPaymentsDiv.appendChild(hiddenDiv);
      }

      this.createAndAppendDiv(
        "cash_financing_table_monthly_payment",
        formattedMonthlyPayment,
        "text-gray-900 dark:text-white" + backgroundColor,
      );
    });
  }

  addControlUnitToInterestFinancingTable(controlUnit, backgroundColor = "") {
    const financingType = this.financingTypeTarget.value;
    if (financingType === "cash") return;

    backgroundColor = backgroundColor + " p-2";

    let extraLength =
      this.financialEntities.length == 0
        ? 0
        : this.financialEntities.length - 1;

    let monthsToCession =
      this.monthsToCessionHash[controlUnit.code] ||
      controlUnit.months_to_cession;

    if (this.financialEntities.length > 0) {
      monthsToCession =
        monthsToCession || this.financialEntities[0].months_to_pay_down_payment;
    }

    let textContents = [controlUnit.code, ...Array(extraLength).fill("")];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "interest_financing_table_control_unit",
        textContent,
        backgroundColor,
      ),
    );

    let extras = [];

    if (controlUnit.is_custom_house) {
      controlUnit.types.forEach((type) => {
        extras.push(...controlUnit.extras[type]);
      });
    } else {
      extras = controlUnit.extras;
    }

    let extrasTotal = extras.reduce((acc, extra) => {
      if (extra.apply) {
        let extraPrice =
          this.currency === "USD" ? extra.price_dollar : extra.price;
        let extraTotal = extraPrice * (extra.quantity || 1);
        return acc + extraTotal;
      }
      return acc;
    }, 0);
    this.calcValues["extrasTotal"] = extrasTotal;

    let controlUnitPrice =
      this.currency === "USD" ? controlUnit.price_dollar : controlUnit.price;
    this.calcValues["controlUnitPrice"] = controlUnitPrice;

    let finalTotal = controlUnitPrice + extrasTotal;
    this.calcValues["finalTotal"] = finalTotal;

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(extrasTotal, "$", 2)
        : this.formatAsCurrency(extrasTotal, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "interest_financing_table_extras_total",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(controlUnit.price_dollar, "$", 2)
        : this.formatAsCurrency(controlUnit.price, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "interest_financing_table_price",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    textContents = [
      this.currency === "USD"
        ? this.formatAsCurrency(finalTotal, "$", 2)
        : this.formatAsCurrency(finalTotal, "Q", 2),
      ...Array(extraLength).fill(""),
    ];
    textContents.forEach((textContent) =>
      this.createAndAppendDiv(
        "interest_financing_table_total",
        textContent,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      ),
    );

    const discountAmount = this.discount_total || 0;
    let priceAfterDiscount = finalTotal - discountAmount;
    this.sale_total = finalTotal;

    if (!controlUnit.discount) {
      controlUnit.discount = discountAmount;
    }

    const discountObject = CustomFinancialEntityHelper.createDiscountField(
      controlUnit,
      backgroundColor,
      this.showViewValue,
      this.setInterestTableContent.bind(this),
      this.currency === "USD" ? "$" : "Q",
      finalTotal * (this.maxAllowedDiscountPercentageValue / 100),
      this.discount_status,
      this.openDiscountAuthorizationModal.bind(this),
      this.updateDiscountStatus.bind(this),
    );

    this.calcValues["discountAmount"] = controlUnit.discount;
    this.calcValues["priceAfterDiscount"] = finalTotal - controlUnit.discount;
    if (!this.discount_total) {
      priceAfterDiscount = finalTotal - controlUnit.discount;
    }

    this.createAndAppendDiv(
      "interest_financing_table_discount",
      discountObject,
      backgroundColor.replace(" p-2", ""),
      false,
      true,
      extraLength,
    );

    const formattedPriceAfterDiscount =
      this.currency === "USD"
        ? this.formatAsCurrency(priceAfterDiscount, "$", 2)
        : this.formatAsCurrency(priceAfterDiscount, "Q", 2);

    this.createAndAppendDiv(
      "interest_financing_table_total_after_discount",
      formattedPriceAfterDiscount,
      "text-gray-500 dark:text-gray-400" + backgroundColor,
      false,
      false,
      extraLength,
    );

    this.financialEntities.forEach((financialEntity) => {
      // Calculate the discount amount and the final price after discount
      const initialPayment = Math.ceil(
        priceAfterDiscount *
          (parseFloat(financialEntity.initial_payment_percentage) / 100),
      );

      let finalPrice = priceAfterDiscount - initialPayment;
      let original_down_payment = Math.ceil(
        finalPrice *
          (parseFloat(financialEntity.down_payment_percentage) / 100),
      );

      let down_payment;

      let final_months_to_cession =
        financialEntity.custom_hash?.[controlUnit.id]?.checked &&
        financialEntity.custom_hash?.[controlUnit.id]?.months_to_cession != null
          ? financialEntity.custom_hash?.[controlUnit.id]?.months_to_cession
          : monthsToCession;
      if (
        controlUnit.custom_down_payment &&
        controlUnit.custom_down_payment[financialEntity.id] !== undefined
      ) {
        down_payment = controlUnit.custom_down_payment[financialEntity.id];
      } else if (
        financialEntity.custom_hash?.[controlUnit.id]?.checked &&
        financialEntity.custom_hash?.[controlUnit.id]?.monthly_payment != null
      ) {
        down_payment =
          financialEntity.custom_hash?.[controlUnit.id]?.monthly_payment *
          final_months_to_cession;
      } else {
        down_payment = original_down_payment;
      }

      let minimum_monthly_down_payment_from_fe =
        this.currency === "USD"
          ? financialEntity.minimum_down_payment_dollar
          : financialEntity.minimum_down_payment;

      let minimum_monthly_down_payment = minimum_monthly_down_payment_from_fe;

      const minimum_monthly_down_payment_from_percentage = Math.ceil(
        original_down_payment / final_months_to_cession,
      );

      if (
        minimum_monthly_down_payment_from_percentage >
        minimum_monthly_down_payment
      ) {
        minimum_monthly_down_payment =
          minimum_monthly_down_payment_from_percentage;
      }

      let monthly_down_payment = 0;

      if (
        financialEntity.custom_hash?.[controlUnit.id]?.checked &&
        financialEntity.custom_hash?.[controlUnit.id]?.monthly_payment != null
      ) {
        monthly_down_payment =
          financialEntity.custom_hash?.[controlUnit.id]?.monthly_payment;
      } else {
        monthly_down_payment = Math.ceil(
          down_payment / final_months_to_cession,
        );
      }

      this.calcValues[financialEntity.id] = {};

      let initialCustomPayment = 0;
      let recalculateMinimumMonthlyDownPayment = false;
      if (financialEntity.custom_hash?.[controlUnit.id]?.initial_payment) {
        initialCustomPayment =
          financialEntity.custom_hash?.[controlUnit.id]?.initial_payment;
        down_payment += initialCustomPayment;
        this.calcValues[financialEntity.id]["initialCustomPayment"] =
          initialCustomPayment;
        recalculateMinimumMonthlyDownPayment = true;
      }

      const mininum_down_payment_percentage = parseFloat(
        financialEntity.down_payment_percentage,
      );

      let down_payment_percentage = (down_payment / finalPrice) * 100;
      down_payment_percentage = Math.round(down_payment_percentage * 100) / 100;

      this.minimumDownPaymentError =
        down_payment_percentage < mininum_down_payment_percentage;

      if (recalculateMinimumMonthlyDownPayment) {
        const new_minimum_monthly_payment = Math.ceil(
          (mininum_down_payment_percentage * finalPrice -
            initialCustomPayment) /
            final_months_to_cession,
        );
        minimum_monthly_down_payment =
          new_minimum_monthly_payment > minimum_monthly_down_payment_from_fe
            ? new_minimum_monthly_payment
            : minimum_monthly_down_payment_from_fe;
      }

      const to_finance = finalPrice - down_payment;

      this.calcValues[financialEntity.id]["initialPayment"] = initialPayment;
      this.calcValues[financialEntity.id]["monthlyDownPayment"] =
        monthly_down_payment;
      this.calcValues[financialEntity.id]["downPayment"] = down_payment;
      this.calcValues[financialEntity.id]["minimumMonthlyDownPayment"] =
        minimum_monthly_down_payment_from_percentage;
      this.calcValues[financialEntity.id]["finalPrice"] = finalPrice;
      this.calcValues[financialEntity.id]["originalDownPayment"] =
        original_down_payment;
      this.calcValues[financialEntity.id]["finalMonthsToCession"] =
        final_months_to_cession;
      this.calcValues[financialEntity.id]["downPaymentPercentage"] =
        down_payment_percentage;
      this.calcValues[financialEntity.id]["toFinance"] = to_finance;

      const financialEntityTitleObject =
        CustomFinancialEntityHelper.createTitle(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setInterestTableContent.bind(this),
        );

      const monthsToCessionObject =
        CustomFinancialEntityHelper.createMonthsToCessionFinancedTable(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setInterestTableContent.bind(this),
          monthsToCession,
        );

      const monthlyPaymentObject =
        CustomFinancialEntityHelper.createMonthlyPaymentFinancedTable(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setInterestTableContent.bind(this),
          monthly_down_payment,
          minimum_monthly_down_payment,
        );

      const initialPaymentObject =
        CustomFinancialEntityHelper.createInitialPaymentField(
          financialEntity,
          controlUnit,
          backgroundColor,
          this.showViewValue,
          this.setInterestTableContent.bind(this),
          this.currency === "USD" ? "$" : "Q",
        );

      this.createAndAppendDiv(
        "interest_financing_table_name",
        financialEntityTitleObject,
        null,
        false,
        true,
      );
      this.createAndAppendDiv(
        "interest_financing_table_initial_payment_percentage",
        `${financialEntity.initial_payment_percentage}%`,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_initial_payment_total",
        this.currency === "USD"
          ? this.formatAsCurrency(initialPayment, "$", 2)
          : this.formatAsCurrency(initialPayment, "Q", 2),
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_to_pay",
        this.currency === "USD"
          ? this.formatAsCurrency(finalPrice, "$", 2)
          : this.formatAsCurrency(finalPrice, "Q", 2),
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_initial_pay",
        initialPaymentObject,
        null,
        false,
        true,
      );

      this.createAndAppendDiv(
        "interest_financing_table_down_payment_months",
        monthsToCessionObject,
        null,
        false,
        true,
      );
      this.createAndAppendDiv(
        "interest_financing_table_down_payment_percentage",
        `${down_payment_percentage}%`,
        `${this.minimumDownPaymentError ? "text-red-500 dark:text-red-400" : "text-gray-500 dark:text-gray-400"}` +
          backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_down_payment_total",
        this.currency === "USD"
          ? this.formatAsCurrency(down_payment, "$", 2)
          : this.formatAsCurrency(down_payment, "Q", 2),
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_to_finance",
        this.currency === "USD"
          ? this.formatAsCurrency(to_finance, "$", 2)
          : this.formatAsCurrency(to_finance, "Q", 2),
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      this.createAndAppendDiv(
        "interest_financing_table_annual_interest_rate",
        `${financialEntity.annual_interest_rate}%`,
        "text-gray-500 dark:text-gray-400" + backgroundColor,
      );
      // this.createAndAppendDiv('interest_financing_table_years', years_div_content, "text-gray-500 dark:text-gray-400", true);
      // this.createAndAppendDiv('interest_financing_table_monthly_payment', monthly_payment_div_content, "text-gray-900 dark:text-white", true);

      this.calcValues[financialEntity.id]["yearsToFinance"] = {};
      this.yearsToFinance.forEach((year) => {
        const monthlyPayment = Math.ceil(
          this.pmt(
            parseFloat(financialEntity.annual_interest_rate) / 100 / 12,
            year * 12,
            to_finance,
            0,
            0,
          ),
        );
        this.calcValues[financialEntity.id]["yearsToFinance"][year] =
          monthlyPayment;
        const formattedMonthlyPayment =
          this.currency === "USD"
            ? this.formatAsCurrency(monthlyPayment, "$", 2)
            : this.formatAsCurrency(monthlyPayment, "Q", 2);
        this.createAndAppendDiv(
          `interest_financing_table_years_${year}`,
          formattedMonthlyPayment,
          "text-gray-900 dark:text-white" + backgroundColor,
        );
      });

      let customPaymentsButton = document.createElement("button");
      customPaymentsButton.textContent = "Pagos Variables";
      customPaymentsButton.className =
        "font-medium text-blue-600 dark:text-blue-500 hover:underline";

      customPaymentsButton.addEventListener("click", (event) => {
        let toPay = original_down_payment - initialCustomPayment;
        toPay = toPay < 0 ? 0 : toPay;
        event.preventDefault();
        this.dispatch("openCustomPaymentsModal", {
          detail: {
            financialEntity: financialEntity,
            controlUnit: controlUnit,
            monthlyPayment: monthly_down_payment.toFixed(2),
            finalPrice: toPay,
            currency: this.currency,
            withInterest: true,
            monthsToCession: monthsToCession,
            paymentDay: this.paymentDay,
          },
        });
      });

      let customPaymentsDiv = document.getElementById(
        "interest_financing_table_custom_payments_button",
      );

      let formattedMonthlyDownPayment =
        this.currency === "USD"
          ? this.formatAsCurrency(monthly_down_payment, "$", 2)
          : this.formatAsCurrency(monthly_down_payment, "Q", 2);

      let showButton = false;
      if (
        controlUnit.custom_payments &&
        controlUnit.custom_payments[financialEntity.id] != null
      ) {
        formattedMonthlyDownPayment = "Tiene Pagos Variables";
        showButton = true;
      }

      if ((!this.showViewValue || showButton) && !this.pdfViewValue) {
        customPaymentsDiv.className =
          "grid grid-flow-col-dense auto-cols-fr text-sm text-gray-700 border-b border-gray-200 dark:border-gray-700";
        this.createAndAppendDiv(
          "interest_financing_table_custom_payments_button",
          customPaymentsButton,
          "text-gray-900 dark:text-white" + backgroundColor,
          false,
          true,
        );
      } else if (this.pdfViewValue) {
        customPaymentsDiv.innerHTML = "";
      } else {
        let hiddenDiv = document.createElement("div");
        hiddenDiv.className = "";
        customPaymentsDiv.appendChild(hiddenDiv);
      }

      if (financialEntity.custom_hash?.[controlUnit.id]?.checked) {
        this.createAndAppendDiv(
          "interest_financing_table_down_payment_monthly_payment",
          monthlyPaymentObject,
          null,
          false,
          true,
        );
      } else {
        this.createAndAppendDiv(
          "interest_financing_table_down_payment_monthly_payment",
          formattedMonthlyDownPayment,
          "text-gray-900 dark:text-white" + backgroundColor,
        );
      }
    });
  }

  createAndAppendDiv(
    parentId,
    textContent,
    className = null,
    asInnerContent = false,
    append = false,
    extraLength = 0,
  ) {
    let parent = document.getElementById(parentId);
    let child = document.createElement("div");
    if (asInnerContent) {
      child.innerHTML = textContent;
    }
    if (append) {
      child.appendChild(textContent);
    } else {
      child.textContent = textContent;
    }
    if (className) {
      child.className = className;
    }
    parent.appendChild(child);

    for (let i = 0; i < extraLength; i++) {
      let extraChild = document.createElement("div");
      extraChild.textContent = "";
      extraChild.className = className;
      parent.appendChild(extraChild);
    }
  }

  addControlUnitToTable(controlUnit) {
    const tableId =
      this.financingTypeTarget.value === "financed"
        ? "control_units_financed_table"
        : "control_units_cash_table";

    let table = document.getElementById(tableId);
    let row = table.insertRow(-1);
    row.className =
      "odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700";
    row.setAttribute("data-action", "keydown->quotation#preventActionOnEnter");

    let codeCell = row.insertCell(-1);
    let priceCell = row.insertCell(-1);
    let monthsToCessionCell = row.insertCell(-1);
    let extrasCell = row.insertCell(-1);
    let deleteCell = row.insertCell(-1);

    let container = document.createElement("div");
    let codeText = document.createElement("p");
    codeText.textContent = controlUnit.code;
    container.appendChild(codeText);
    let extrasList = document.createElement("ul");
    extrasList.className = "list-disc pl-4";
    let extras = [];

    if (controlUnit.is_custom_house) {
      controlUnit.types.forEach((type) => {
        controlUnit.extras[type].forEach((extra) => {
          extra.control_unit_subtype = type;
        });

        extras.push(...controlUnit.extras[type]);
      });
    } else {
      extras = controlUnit.extras;
    }

    extras.forEach((extra) => {
      if (extra.apply) {
        let listItem = document.createElement("li");
        if (extra.control_unit_subtype) {
          listItem.textContent = `${extra.control_unit_subtype}: ${extra.name} - ${extra.quantity || 1}`;
        } else {
          listItem.textContent = `${extra.name} - ${extra.quantity || 1}`;
        }
        extrasList.appendChild(listItem);
      }
    });

    if (controlUnit.lots) {
      let lotsList = document.createElement("ul");
      lotsList.className = "list-disc pl-4";
      controlUnit.lots.forEach((lot) => {
        let listItem = document.createElement("li");
        listItem.textContent = lot.code;
        lotsList.appendChild(listItem);
      });
      container.appendChild(lotsList);
    }

    if (extrasList.children.length > 0) {
      const hr = document.createElement("hr");
      hr.className = "h-px my-1 bg-gray-200 border-0 dark:bg-gray-700";
      container.appendChild(hr);
    }

    container.appendChild(extrasList);

    codeCell.appendChild(container);

    priceCell.textContent =
      this.currency === "USD"
        ? this.formatAsCurrency(controlUnit.price_dollar, "$", 2)
        : this.formatAsCurrency(controlUnit.price, "Q", 2);

    codeCell.className = "px-3 py-3";
    priceCell.className = "px-3 py-3";
    monthsToCessionCell.className = "px-3 py-3";
    extrasCell.className = "px-3 py-3";
    deleteCell.className = "px-3 py-3";

    let input = document.createElement("input");
    input.className =
      "block p-2.5 w-50 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500";
    input.type = "number";
    input.min = 1;
    input.id = "months_to_cession_target_" + controlUnit.code;

    const financialEntity = this.financialEntities[0];
    if (this.financingTypeTarget.value === "financed") {
      if (this.financialEntities.length > 0) {
        if (
          controlUnit.months_to_cession == null ||
          isNaN(controlUnit.months_to_cession)
        ) {
          controlUnit.months_to_cession =
            financialEntity.months_to_pay_down_payment;
        }
        input.value = controlUnit.months_to_cession;
        input.max = financialEntity.months_to_pay_down_payment || 100;
      } else {
        input.disabled = true;
      }
    } else {
      monthsToCessionCell.className = "hidden";
    }

    input.addEventListener("change", () => {
      if (input.value > financialEntity.months_to_pay_down_payment) {
        input.value = financialEntity.months_to_pay_down_payment;
        alert(
          "La cantidad de meses no puede sobrepasar los configurados en la Entidad Financiera.",
        );
      }
      this.addMonthsToCessionToControlUnit(controlUnit.code, input.value);
    });

    monthsToCessionCell.appendChild(input);

    let extrasButton = document.createElement("button");
    extrasButton.textContent = "Extras";
    extrasButton.className =
      "font-medium text-blue-600 dark:text-blue-500 hover:underline";

    extrasButton.addEventListener("click", (event) => {
      event.preventDefault();
      this.showExtrasModal(controlUnit.code);
    });

    extrasCell.appendChild(extrasButton);

    let deleteButton = document.createElement("button");
    deleteButton.textContent = "Eliminar";
    deleteButton.className =
      "font-medium text-red-600 dark:text-red-500 hover:underline";

    deleteButton.addEventListener("click", (event) => {
      event.preventDefault();
      this.deleteControlUnit(row, controlUnit.code);
    });

    deleteCell.appendChild(deleteButton);
  }

  instantiateExtrasModal() {
    const $targetEl = document.getElementById("extrasModal");
    const options = {
      placement: "center",
      backdrop: "dynamic",
      backdropClasses: "bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40",
      closable: true,
      onHide: () => {},
      onShow: () => {},
      onToggle: () => {},
    };

    this.extrasModal = new Modal($targetEl, options);
  }

  showExtrasModal(controlUnitCode) {
    let controlUnit = this.controlUnits.find((controlUnit) => {
      return controlUnit.code === controlUnitCode;
    });

    let extras = [];
    this.extrasModalTitleTarget.textContent = `Extras para la unidad ${controlUnit.code}`;
    const selectForSubtypes = document.getElementById("extras_for_subtype");
    selectForSubtypes.innerHTML = "";

    if (controlUnit.is_custom_house) {
      selectForSubtypes.style.display = "block";
      extras = controlUnit.extras[controlUnit.types[0]] || [];
      this.displayExtras(extras);
      controlUnit.types.forEach((type) => {
        let option = document.createElement("option");
        option.value = type;
        option.textContent = type;
        selectForSubtypes.appendChild(option);
      });
      selectForSubtypes.addEventListener("change", (event) => {
        extras = controlUnit.extras[event.target.value] || [];
        this.displayExtras(extras);
      });
    } else {
      selectForSubtypes.style.display = "none";
      extras = controlUnit.extras || [];
      this.displayExtras(extras);
    }

    this.extrasModal.show();
  }

  displayExtras(extras) {
    let table = document.getElementById("extras_modal_table");

    while (table.rows.length > 1) {
      table.deleteRow(1);
    }

    extras.forEach((extra) => {
      let row = table.insertRow(-1);
      row.className =
        "odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700";
      let nameCell = row.insertCell(0);
      let priceCell = row.insertCell(1);
      let quantityCell = row.insertCell(2);
      let totalCell = row.insertCell(3);
      let applyCell = row.insertCell(4);

      let price = this.currency === "USD" ? extra.price_dollar : extra.price;

      nameCell.textContent = extra.name;
      priceCell.textContent = this.formatAsCurrency(
        price,
        this.currency === "USD" ? "$" : "Q",
        2,
      );
      totalCell.textContent = this.formatAsCurrency(
        price * (extra.quantity || 1),
        this.currency === "USD" ? "$" : "Q",
        2,
      );

      nameCell.className = "px-3 py-3 whitespace-nowrap";
      priceCell.className = "px-3 py-3 whitespace-nowrap";
      quantityCell.className = "px-3 py-3 w-28";
      totalCell.className = "px-3 py-3 whitespace-nowrap";
      applyCell.className = "px-3 py-3";

      let applyCheckbox = document.createElement("input");
      applyCheckbox.type = "checkbox";
      applyCheckbox.className = "form-checkbox h-5 w-5 text-primary-600";
      applyCheckbox.checked = extra.apply;
      applyCheckbox.addEventListener("change", (event) => {
        extra.apply = event.target.checked;
        extra.quantity = extra.quantity || 1;
        this.setControlUnitsTableContent();
        this.setCashTableContent();
        this.setInterestTableContent();
      });

      let input = document.createElement("input");
      input.className =
        "w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500";
      input.type = "number";
      input.value = extra.quantity || 1;
      input.min = 1;

      input.addEventListener("change", () => {
        extra.quantity = parseInt(input.value);
        totalCell.textContent = this.formatAsCurrency(
          price * extra.quantity,
          this.currency === "USD" ? "$" : "Q",
          2,
        );
        this.setControlUnitsTableContent();
        this.setCashTableContent();
        this.setInterestTableContent();
      });

      quantityCell.appendChild(input);

      applyCell.appendChild(applyCheckbox);
    });

    if (extras.length === 0) {
      let row = table.insertRow(-1);
      row.className = "text-gray-500 dark:text-gray-400 font-medium";
      row.textContent = "No hay extras para esta unidad";
    }
  }

  closeExtrasModal() {
    this.extrasModal.hide();
  }

  deleteControlUnit(row, controlUnitCode) {
    row.remove();
    this.controlUnits = this.controlUnits.filter((controlUnit) => {
      return controlUnit.code !== controlUnitCode;
    });

    const controlUnit = this.controlUnitsValue.find(
      (controlUnit) => controlUnit.code === controlUnitCode,
    );

    if (controlUnit.lots) {
      controlUnit.lots.forEach((lot) => {
        this.availableControlUnits.push(lot.code);
      });
    }

    this.availableControlUnits.push(controlUnitCode);
  }

  addMonthsToCessionToControlUnit(controlUnitCode, value = null) {
    let controlUnit = this.controlUnits.find((controlUnit) => {
      return controlUnit.code === controlUnitCode;
    });

    let target = document.getElementById(
      "months_to_cession_target_" + controlUnitCode,
    );
    const newValue = value || parseInt(target.value);

    controlUnit.months_to_cession = newValue;
    this.controlUnits = this.controlUnits.map((unit) => {
      return unit.code === controlUnitCode ? controlUnit : unit;
    });

    this.monthsToCessionHash[controlUnitCode] = newValue;

    this.setCashTableContent();
    this.setInterestTableContent();
  }

  addCustomPaymentsToControlUnit({
    detail: { controlUnitCode, customPayments, financialEntityId },
  }) {
    let controlUnit = this.controlUnits.find((controlUnit) => {
      return controlUnit.code === controlUnitCode;
    });

    if (!controlUnit.custom_payments) {
      controlUnit.custom_payments = {};
    }

    controlUnit.custom_payments[financialEntityId] = customPayments;

    this.controlUnits = this.controlUnits.map((unit) => {
      return unit.code === controlUnitCode ? controlUnit : unit;
    });

    this.setCashTableContent();
    this.setInterestTableContent();
  }

  resetControlUnitCustomPayments({
    detail: { controlUnitCode, financialEntityId },
  }) {
    let controlUnit = this.controlUnits.find((controlUnit) => {
      return controlUnit.code === controlUnitCode;
    });

    if (controlUnit.custom_payments) {
      delete controlUnit.custom_payments[financialEntityId];
    }

    if (controlUnit.custom_down_payment) {
      delete controlUnit.custom_down_payment[financialEntityId];
    }

    this.controlUnits = this.controlUnits.map((unit) => {
      return unit.code === controlUnitCode ? controlUnit : unit;
    });

    this.setCashTableContent();
    this.setInterestTableContent();
  }

  resetAllControlUnitCustomPayments() {
    this.controlUnits.forEach((controlUnit) => {
      if (controlUnit.custom_payments) {
        delete controlUnit.custom_payments;
      }

      if (controlUnit.custom_down_payment) {
        delete controlUnit.custom_down_payment;
      }
    });

    this.setCashTableContent();
    this.setInterestTableContent();
  }

  updateDownPaymentFromCustomPayments({
    detail: { downPayment, financialEntityId, controlUnitCode },
  }) {
    let controlUnit = this.controlUnits.find((controlUnit) => {
      return controlUnit.code === controlUnitCode;
    });

    if (!controlUnit.custom_down_payment) {
      controlUnit.custom_down_payment = {};
    }

    controlUnit.custom_down_payment[financialEntityId] = downPayment;

    this.controlUnits = this.controlUnits.map((unit) => {
      return unit.code === controlUnitCode ? controlUnit : unit;
    });

    this.setInterestTableContent();
  }

  openDiscountAuthorizationModal(maxAllowedDiscount, currency) {
    this.dispatch("openDiscountAuthorizationModal", {
      detail: {
        maxAllowedDiscount: maxAllowedDiscount,
        currency: currency,
      },
    });
  }

  getDiscountAuthorizationComment({ detail: { comment } }) {
    this.discount_authorization_comment = comment;
  }

  resetDiscount() {
    this.updateDiscountStatus(null);
    this.discount_authorization_comment = null;

    if (this.controlUnits[0]) this.controlUnits[0].discount = 0;
    this.discount_total = 0;

    if (this.financingTypeTarget.value === "financed") {
      this.setInterestTableContent();
    }
    {
      this.setCashTableContent();
    }
  }

  updateDiscountStatus(status) {
    this.discount_status = status;
  }

  resetCalculator(event) {
    if (event) event.preventDefault();

    if (this.isCalculatorPage) {
      const currencySelect = document.querySelector(
        '[data-quotation-target="currency"]',
      );

      if (currencySelect) {
        currencySelect.selectedIndex = 0;
      }

      this.currency = "GTQ";
      this.changeCurrency();
    }

    document.querySelectorAll("[data-quotation-target]").forEach((element) => {
      switch (element.type) {
        case "number":
          if (element.dataset.quotationTarget === "paymentDay") return;
          element.value = element.hasAttribute("min") ? element.min : 0;
          break;
        case "text":
          if (element.dataset.quotationTarget === "clientName") {
            break;
          } else if (element.hasAttribute("disabled")) {
            element.value = "";
          } else {
            element.value = 0;
          }
          break;
        default:
          break;
      }
    });

    this.triggerCalculations();
  }

  submitForm(event) {
    event.preventDefault();

    if (this.validateForm()) {
      this.quotationParamsTarget.value = JSON.stringify({
        years_to_finance: this.yearsToFinance,
        financial_entities: this.financialEntities,
        control_units: this.controlUnits,
        phone_extension: this.clientPhoneExtensionTarget.value,
        currency: this.currency,
        sale_total: this.sale_total,
        discount_total: this.calcValues.discountAmount,
        discount_status: this.discount_status,
        discount_authorization_comment: this.discount_authorization_comment,
        calculated_values: this.calcValues,
        payment_day: this.paymentDayTarget.value,
      });
      this.element.submit();
    }
  }

  validateForm() {
    const clientName = this.clientNameTarget.value;
    if (!clientName || clientName.trim() === "") {
      this.createToast(
        "error",
        "El nombre es requerido para realizar cotización.",
      );
      return;
    }

    const financingType = this.financingTypeTarget.value;
    if (!financingType || financingType.trim() === "") {
      this.createToast("error", "Seleccione un tipo de financiamiento.");
      return;
    }

    if (!this.financialEntities || this.financialEntities.length == 0) {
      this.createToast(
        "error",
        "Seleccione una entidad financiera para continuar.",
      );
      return;
    }

    if (financingType == "financed" && this.yearsToFinance <= 0) {
      this.createToast(
        "error",
        "Años de financiamiento debe ser mayor o igual a 1 si se financia.",
      );
      return;
    }

    if (this.paymentDayTarget.value > 31 || this.paymentDayTarget.value < 1) {
      this.createToast(
        "error",
        "El día de pago debe ser un número entre 1 y 31.",
      );
      return;
    }

    if (this.paymentDayTarget.value > 31 || this.paymentDayTarget.value < 1) {
      this.createToast(
        "error",
        "El día de pago debe ser un número entre 1 y 31.",
      );
      return;
    }

    if (this.financialEntities.length > 1) {
      this.createToast(
        "error",
        "Solo se puede seleccionar una entidad financiera para crear la cotización.",
      );
      return;
    }

    if (this.minimumDownPaymentError) {
      this.createToast(
        "error",
        "La cuota mensual de enganche no puede ser menor al mínimo permitido por la entidad financiera.",
      );
      return;
    }

    return true;
  }

  get price() {
    return parseFloat(this.cashValueTarget.value);
  }

  get downPaymentPercentage() {
    return parseFloat(this.downPaymentPercentageTarget.value);
  }

  get downPayment() {
    return (this.total * this.downPaymentPercentage) / 100;
  }

  get discount() {
    return this.discountTarget.value;
  }

  get total() {
    return this.price - this.discount;
  }

  get interestRatePercentage() {
    return parseFloat(this.interestRateTarget.value);
  }

  get financialEntity() {
    return this.financialEntitiesValue.find((financialEntity) => {
      return financialEntity.id === parseInt(this.lastAddedFinancialEntityId);
    });
  }

  get paymentDay() {
    if (this.hasPaymentDayTarget) {
      return parseInt(this.paymentDayTarget.value);
    }

    const params = JSON.parse(this.quotationParamsValue);

    if (params.payment_day) {
      return parseInt(params.payment_day);
    }

    return 1;
  }
}
