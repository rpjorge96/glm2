import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = [
    "downPaymentPercentage",
    "interestRate",
    "minimumDownPayment",
    "downPaymentDiscountPercentage",
    "porcentajePagoInicial",
    "cashType",
    "financedType",
  ];

  connect() {
    this.hideByFinancingType();
  }

  hideByFinancingType() {
    const element = document.getElementById("financial_entity_financing_type");
    const cashTypeElements = this.cashTypeTargets;
    const financedTypeElements = this.financedTypeTargets;
    let displayCash;
    let displayFinanced;
    if (element.value == "cash") {
      displayCash = "inline";
      displayFinanced = "none";
    } else {
      displayCash = "none";
      displayFinanced = "inline";
    }

    financedTypeElements.forEach((element) => {
      element.style.display = displayFinanced;
    });
    cashTypeElements.forEach((element) => {
      element.style.display = displayCash;
    });
  }
}
