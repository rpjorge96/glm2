import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("change", this.changePermission);
  }

  changePermission = (event) => {
    if (event.target.type === "checkbox") {
      event.target.closest("form").requestSubmit();
    }
  };
}
