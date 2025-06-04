import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { message: String };

  connect() {
    this.element.addEventListener("click", (event) => {
      if (!confirm(this.messageValue)) {
        event.preventDefault();
      }
    });
  }
}
