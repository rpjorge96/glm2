import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { disablePreventDefault: Boolean };

  connect() {
    this.ignoreBeforeUnload = false;

    this.initialFormData = this.serializeForm();

    const specificButtons = document.querySelectorAll(".submitButton");
    specificButtons.forEach((button) => {
      button.addEventListener("click", this.ignoreUnload);
    });

    window.history.pushState(null, "", window.location.href);
    window.addEventListener("popstate", this.handlePopState);
    window.addEventListener("beforeunload", this.handleBeforeUnload);
  }

  disconnect() {
    const specificButtons = document.querySelectorAll(".submitButton");
    specificButtons.forEach((button) => {
      button.removeEventListener("click", this.ignoreUnload);
    });

    window.removeEventListener("popstate", this.handlePopState);
    window.removeEventListener("beforeunload", this.handleBeforeUnload);
  }

  serializeForm() {
    const form = this.element.querySelector("form");
    const data = {};
    if (!form) return data;

    for (let el of form.elements) {
      if (!el.name || el.disabled) continue;

      if (el.type === "checkbox" || el.type === "radio") {
        data[el.name] = el.checked;
      } else {
        data[el.name] = el.value;
      }
    }
    return data;
  }

  hasFormChanged() {
    const currentData = this.serializeForm();

    for (const key in this.initialFormData) {
      if (this.initialFormData[key] !== currentData[key]) {
        return true;
      }
    }
    return false;
  }

  handlePopState = () => {
    window.history.pushState(null, "", window.location.href);
    alert("No se puede usar el botón de regreso en esta página.");
  };

  handleBeforeUnload = (event) => {
    if (this.ignoreBeforeUnload) {
      this.ignoreBeforeUnload = false;
      return;
    }

    if (this.hasFormChanged()) {
      event.preventDefault();
      event.returnValue = "";
    }
  };

  ignoreUnload = () => {
    this.ignoreBeforeUnload = true;
  };
}
