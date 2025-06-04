import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["textArea", "counter"];

  static values = { maxCharacters: Number };

  connect() {
    console.log("text field controller");
    this.updateCounter();
    this.textAreaTarget.addEventListener("input", () => this.updateCounter());
  }

  updateCounter() {
    const currentLength = this.textAreaTarget.value.length;
    const maxLength = this.maxCharactersValue;
    this.counterTarget.textContent = `${currentLength}/${maxLength}`;

    if (currentLength > maxLength) {
      this.counterTarget.textContent = `${maxLength}/${maxLength}`;
      this.textAreaTarget.value = this.textAreaTarget.value.slice(0, maxLength);
      this.createToast(
        "error",
        "Se ha llegado a la cantidad máxima de caracteres",
      );
    }
  }
}
