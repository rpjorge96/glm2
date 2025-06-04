export default class CustomFinancialEntityHelper {
  static createTitle(
    financialEntity,
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
  ) {
    if (financialEntity?.custom_hash?.[controlUnit.id]?.checked === undefined) {
      if (financialEntity?.custom_hash == null)
        financialEntity.custom_hash = {};
      financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["checked"] = true;
    }

    const financialEntityTitle = `
        <div class=" bg-sky-100 dark:bg-sky-950 p-2 text-gray-900 dark:text-white ${backgroundColor}">
          <label class="inline-flex items-center cursor-pointer">
            ${financialEntity.name}
            <input type="checkbox" value="" class="sr-only peer"
              ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "checked" : ""}
              ${showViewValue ? "disabled" : ""}
            >
            <div class="relative ml-3 w-9 h-5 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
            <span class="ms-3 text-xs text-gray-900 dark:text-gray-300">Enganche propuesto</span>
        </div>`;
    const financialEntityTitleDom =
      this.stringToDomElements(financialEntityTitle);
    const titleCheckbox = financialEntityTitleDom.querySelector("input");
    titleCheckbox.addEventListener("change", (event) => {
      if (financialEntity.custom_hash == null) financialEntity.custom_hash = {};
      if (financialEntity.custom_hash[controlUnit.id] == null)
        financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["checked"] =
        event.target.checked;

      setTableContent();
    });

    return financialEntityTitleDom;
  }

  static createMonthsToPayCashTable(
    financialEntity,
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
  ) {
    const monthsToPayDiv = `
        <div class="text-gray-500 dark:text-gray-400 ${backgroundColor}"
        style="padding: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "0 !important" : "8px !important"}"
        >
          <span id="cash_financing_table_months_span_${financialEntity.id}" 
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "none" : "block"}"
          >
            ${financialEntity.months_to_pay_down_payment}
          </span>
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" 
            min="1"
            type="number"
            max="${financialEntity.months_to_pay_down_payment}"
            onkeypress="return event.charCode >= 48 && event.charCode <= 57"
            id="cash_financing_table_months_input_${financialEntity.id}"
            value="${financialEntity.custom_hash?.[controlUnit.id]?.months_to_pay || financialEntity.months_to_pay_down_payment}"
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "block" : "none"}; height: 36px;"
            ${showViewValue ? "disabled" : ""}
          >
        </div>
      `;
    const monthsToPayDivDom = this.stringToDomElements(monthsToPayDiv);
    const monthsToPayInput = monthsToPayDivDom.querySelector("input");
    monthsToPayInput.addEventListener("change", (event) => {
      const months = parseFloat(event.target.value);
      if (months > financialEntity.months_to_pay_down_payment) {
        alert(
          "La cantidad de meses no puede sobrepasar los configurados en la Entidad Financiera.",
        );
        event.target.value = financialEntity.months_to_pay_down_payment;
        setTableContent();
        return;
      }
      if (financialEntity.custom_hash == null) financialEntity.custom_hash = {};
      if (financialEntity.custom_hash[controlUnit.id] == null)
        financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["months_to_pay"] = months;
      setTableContent();
    });

    return monthsToPayDivDom;
  }

  static createMonthsToCessionFinancedTable(
    financialEntity,
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
    monthsToCession,
  ) {
    const monthsToCessionDiv = `
        <div class="text-gray-500 dark:text-gray-400 ${backgroundColor}"
        style="padding: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "0 !important" : "8px !important"}"
        >
          <span id="cession_financing_table_months_span_${financialEntity.id}" 
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "none" : "block"}"
          >
            ${monthsToCession}
          </span>
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" 
            min="1"
            type="number"
            max="${monthsToCession}"
            onkeypress="return event.charCode >= 48 && event.charCode <= 57"
            id="cession_financing_table_months_input_${financialEntity.id}"
            value="${financialEntity.custom_hash?.[controlUnit.id]?.months_to_cession || monthsToCession}"
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "block" : "none"}; height: 36px;"
            ${showViewValue ? "disabled" : ""}
          >
        </div>
      `;
    const monthsToCessionDivDom = this.stringToDomElements(monthsToCessionDiv);
    const monthsToCessionInput = monthsToCessionDivDom.querySelector("input");
    monthsToCessionInput.addEventListener("change", (event) => {
      const months = parseFloat(event.target.value);
      if (months > monthsToCession) {
        alert(
          "La cantidad de meses no puede sobrepasar los configurados en la Unidad de Control.",
        );
        event.target.value = monthsToCession;
        setTableContent();
        return;
      }
      if (financialEntity.custom_hash == null) financialEntity.custom_hash = {};
      if (financialEntity.custom_hash[controlUnit.id] == null)
        financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["months_to_cession"] =
        parseInt(event.target.value);
      setTableContent();
    });

    return monthsToCessionDivDom;
  }

  static createMonthlyPaymentFinancedTable(
    financialEntity,
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
    monthlyPayment,
    minimumMonthlyPayment,
  ) {
    const monthlyPaymentDiv = `
        <div class="text-gray-500 dark:text-gray-400 ${backgroundColor}"
        style="padding: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "0 !important" : "8px !important"}"
        >
          <span id="financing_table_monthly_payment_span_${financialEntity.id}" 
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "none" : "block"}"
          >
            ${monthlyPayment}
          </span>
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" 
            min="${minimumMonthlyPayment}"
            type="number"
            step="1"
            id="financing_table_monthly_payment_input_${financialEntity.id}"
            value="${monthlyPayment}"
            style="display: ${financialEntity?.custom_hash?.[controlUnit.id]?.checked ? "block" : "none"}; height: 36px;"
            ${showViewValue ? "disabled" : ""}
          >
        </div>
      `;
    const monthlyPaymentDivDom = this.stringToDomElements(monthlyPaymentDiv);
    const monthlyPaymentInput = monthlyPaymentDivDom.querySelector("input");
    monthlyPaymentInput.addEventListener("change", (event) => {
      if (financialEntity.custom_hash == null) financialEntity.custom_hash = {};
      if (financialEntity.custom_hash[controlUnit.id] == null)
        financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["monthly_payment"] =
        Math.ceil(parseFloat(event.target.value));
      setTableContent();
    });

    return monthlyPaymentDivDom;
  }

  static createInitialPaymentField(
    financialEntity,
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
    currency,
  ) {
    if (showViewValue) {
      const initialPaymentDiv = `
      <div class="text-gray-500 dark:text-gray-400  bg-sky-100 dark:bg-sky-950 p-2" style="padding: 8px !important">
          <span id="cash_financing_table_months_span_9" style="display: block">
            ${this.formatAsCurrency(financialEntity.custom_hash?.[controlUnit.id]?.initial_payment || 0, currency, 2)}
          </span>
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" min="1" max="10" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" id="cash_financing_table_months_input_9" value="10" style="display: none; height: 36px;" disabled="">
        </div>
      `;

      return this.stringToDomElements(initialPaymentDiv);
    }

    const initialPaymentDiv = `
        <div class="text-gray-500 dark:text-gray-400 ${backgroundColor}"
        style="padding: 0 !important"
        >
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" 
            min="0"
            type="number"
            step="1"
            id="financing_table_initial_payment_input_${financialEntity.id}"
            value="${financialEntity.custom_hash?.[controlUnit.id]?.initial_payment || 0}"
            ${showViewValue ? "disabled" : ""}
          >
        </div>
      `;
    const initialPaymentDivDom = this.stringToDomElements(initialPaymentDiv);
    const initialPaymentInput = initialPaymentDivDom.querySelector("input");
    initialPaymentInput.addEventListener("change", (event) => {
      if (financialEntity.custom_hash == null) financialEntity.custom_hash = {};
      if (financialEntity.custom_hash[controlUnit.id] == null)
        financialEntity.custom_hash[controlUnit.id] = {};
      financialEntity.custom_hash[controlUnit.id]["initial_payment"] =
        Math.ceil(parseFloat(event.target.value));
      setTableContent();
    });

    return initialPaymentDivDom;
  }

  static createDiscountField(
    controlUnit,
    backgroundColor,
    showViewValue,
    setTableContent,
    currency,
    maxAllowedDiscount,
    discount_status,
    openDiscountAuthorizationModal,
    updateDiscountStatus,
  ) {
    let discountText = "";
    let discountTextColor = "";

    switch (discount_status) {
      case "pending":
        discountText = "Necesita Aprobación";
        discountTextColor = "text-amber-600";
        break;
      case "approved":
        discountText = "Descuento Aprobado";
        discountTextColor = "text-green-600";
        break;
      case "unapproved":
        discountText = "Descuento Rechazado";
        discountTextColor = "text-red-600";
        break;
    }

    if (showViewValue) {
      const discountDiv = `
      <div class="text-gray-500 dark:text-gray-400  bg-sky-100 dark:bg-sky-950 p-2" style="padding: 8px !important">
          <span style="display: block" class="flex">
            ${this.formatAsCurrency(controlUnit.discount, currency, 2)}
            <span class="ml-3 ${discountTextColor}"> ${discount_status == null ? "" : discountText} </span>
          </span>
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" min="1" max="10" onkeypress="return event.charCode >= 48 &amp;&amp; event.charCode <= 57" id="cash_financing_table_months_input_9" value="10" style="display: none; height: 36px;" disabled="">
        </div>
      `;

      return this.stringToDomElements(discountDiv);
    }

    const discountDiv = `
        <div class="text-gray-500 dark:text-gray-400 ${backgroundColor} flex "
        style="padding: 0 !important; align-items: center"
        >
          <input class="block w-1/2 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500" type="number" 
            min="0"
            type="number"
            step="1"
            id="financing_table_discount_input_${controlUnit.id}"
            value="${controlUnit.discount || 0}"
            ${showViewValue ? "disabled" : ""}
          >
          
            <span class="ml-3 ${discountTextColor}"> ${discount_status == null ? "" : discountText} </span>
        </div>
      `;
    const discountDivDom = this.stringToDomElements(discountDiv);
    const discountInput = discountDivDom.querySelector("input");
    discountInput.addEventListener("change", (event) => {
      const discount = Math.ceil(parseFloat(event.target.value));

      if (discount > maxAllowedDiscount) {
        openDiscountAuthorizationModal(maxAllowedDiscount, currency);
        updateDiscountStatus("pending");
      } else {
        updateDiscountStatus(null);
      }

      controlUnit.discount = discount;
      setTableContent();
    });

    return discountDivDom;
  }

  static formatValue(event) {
    let target = event.target;
    let value = parseFloat(target.value);
    target.value = value.toFixed(2);
  }

  static formatAsCurrency(value, currency, precision) {
    if (isNaN(value)) {
      value = 0;
    }

    let formatter = new Intl.NumberFormat("en-US", {
      minimumFractionDigits: precision,
      maximumFractionDigits: precision,
    });

    return `${currency} ${formatter.format(value)}`;
  }

  static stringToDomElements(htmlString) {
    const range = document.createRange();
    return range.createContextualFragment(htmlString);
  }
}
