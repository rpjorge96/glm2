// app/javascript/controllers/role_projects_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["roleSelect", "checkboxes", "selectAll"];

  connect() {
    this.toggle();
    this.syncSelectAll();
  }

  toggle() {
    const roleText =
      this.roleSelectTarget.selectedOptions[0]?.text.toLowerCase();
    if (roleText === "vendedor") {
      this.checkboxesTarget.classList.remove("hidden");
    } else {
      this.hideAndClearAll();
    }
    this.syncSelectAll();
  }

  toggleAll(event) {
    const checked = event.target.checked;
    this.projectBoxes().forEach((cb) => (cb.checked = checked));
    this.syncSelectAll();
  }

  syncSelectAll() {
    if (!this.hasSelectAllTarget) return;
    const boxes = this.projectBoxes();
    this.selectAllTarget.checked =
      boxes.length > 0 && boxes.every((cb) => cb.checked);
  }

  projectBoxes() {
    return Array.from(
      this.checkboxesTarget.querySelectorAll(".project-checkbox"),
    );
  }

  hideAndClearAll() {
    this.checkboxesTarget.classList.add("hidden");
    this.projectBoxes().forEach((cb) => (cb.checked = false));
    if (this.hasSelectAllTarget) this.selectAllTarget.checked = false;
  }
}
