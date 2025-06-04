import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  connect() {
    const templateVariableLabels = document.querySelectorAll(
      "p.template-variable-label",
    );

    templateVariableLabels.forEach((label) => {
      const span = label.querySelector("span.template-variable");
      const variableValue = span.textContent.trim();

      // copy to clipboard
      label.addEventListener("click", () => {
        navigator.clipboard.writeText(variableValue).then(() => {
          this.createToast(
            "success",
            `Se copió al portapapeles: ${variableValue}`,
          );
        });
      });
    });
  }
}
