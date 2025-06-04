import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["container"];
  static values = {
    inputClass: String,
    maxFields: Number,
    extras: Boolean,
  };
  index = 0;

  connect() {
    this.index =
      this.containerTarget.querySelectorAll(`.${this.inputClassValue}`)
        .length || 0;
  }

  addInput() {
    if (this.index < this.maxFieldsValue) {
      this.index++;

      const newDiv = document.createElement("div");

      const numElement = document.createElement("p");
      numElement.textContent = String(this.index);
      numElement.classList.add(
        "w-full",
        "text-lg",
        "text-center",
        "text-gray-900",
        "dark:text-white",
      );

      const wrapper = document.createElement("div");
      wrapper.classList.add(
        "w-full",
        this.inputClassValue,
        "flex",
        "justify-between",
      );
      wrapper.id = `${this.inputClassValue}_${this.index}`;

      // common Tailwind classes for both inputs
      const baseClasses = [
        "mb-4",
        "w-[49%]",
        "p-2.5",
        "text-sm",
        "text-gray-900",
        "bg-gray-50",
        "rounded-lg",
        "border",
        "border-gray-300",
        "focus:ring-primary-500",
        "focus:border-primary-500",
        "dark:bg-gray-700",
        "dark:border-gray-600",
        "dark:placeholder-gray-400",
        "dark:text-white",
        "dark:focus:ring-primary-500",
        "dark:focus:border-primary-500",
      ].join(" ");

      const prefix = this.extrasValue ? "extra_" : "";

      const keyInput = document.createElement("input");
      keyInput.type = "text";
      keyInput.name = `${prefix}key${this.index}`;
      keyInput.placeholder = "Nombre";
      keyInput.className = baseClasses;

      const valueInput = document.createElement("input");
      valueInput.type = "text";
      valueInput.name = `${prefix}value${this.index}`;
      valueInput.placeholder = "Variable";
      valueInput.className = baseClasses;

      wrapper.append(numElement, keyInput, valueInput);
      newDiv.append(numElement, wrapper);
      this.containerTarget.append(newDiv);
    }
  }
}
