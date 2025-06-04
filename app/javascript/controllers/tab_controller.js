import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    addEventListener("turbo:frame-load", () => this.showTabFromURL());
  }

  showTabFromURL() {
    if (!window.hasExecuted) {
      window.hasExecuted = true; // Set the flag to true to prevent future executions

      const urlParams = new URLSearchParams(window.location.search);
      const tab = urlParams.get("tab");
      if (tab) {
        const tabElement = document.querySelector(
          `[data-tabs-target="#${tab}"]`,
        );
        const textArea = document.querySelector(`#${tab}-message`);
        if (tabElement) {
          textArea.style.display = "";
          tabElement.click(); // Activa el tab correspondiente
          tabElement.scrollIntoView({ behavior: "auto" }); // Desplaza la pantalla hacia el tab
        }
      }
    }
  }
}
