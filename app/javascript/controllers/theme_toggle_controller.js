import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["darkIcon", "lightIcon"];

  connect() {
    this.clrPickerDiv = document.getElementById("clr-picker");
    this.updateThemeIcon();
  }

  updateThemeIcon() {
    if (
      localStorage.getItem("color-theme") === "dark" ||
      (!("color-theme" in localStorage) &&
        window.matchMedia("(prefers-color-scheme: dark)").matches)
    ) {
      this.lightIconTarget.classList.remove("hidden");
      if (this.clrPickerDiv) {
        this.clrPickerDiv.classList.add("clr-dark");
      }
    } else {
      this.darkIconTarget.classList.remove("hidden");
      if (this.clrPickerDiv) {
        this.clrPickerDiv.classList.remove("clr-dark");
      }
    }
  }

  toggleTheme() {
    this.darkIconTarget.classList.toggle("hidden");
    this.lightIconTarget.classList.toggle("hidden");

    if (localStorage.getItem("color-theme") === "light") {
      document.documentElement.classList.add("dark");
      localStorage.setItem("color-theme", "dark");
      if (this.clrPickerDiv) {
        this.clrPickerDiv.classList.add("clr-dark");
      }
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("color-theme", "light");
      if (this.clrPickerDiv) {
        this.clrPickerDiv.classList.remove("clr-dark");
      }
    }
  }
}
