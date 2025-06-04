import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "arrow"];

  connect() {
    const dropdownId = this.buttonTarget.getAttribute("aria-controls");
    const dropdown = document.getElementById(dropdownId);

    if (dropdown) {
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.attributeName === "class") {
            this.updateArrowRotation(!dropdown.classList.contains("hidden"));
          }
        });
      });

      observer.observe(dropdown, {
        attributes: true,
        attributeFilter: ["class"],
      });
    }
  }

  updateArrowRotation(isExpanded) {
    if (isExpanded) {
      this.arrowTarget.classList.add("rotate-180");
    } else {
      this.arrowTarget.classList.remove("rotate-180");
    }
  }
}
