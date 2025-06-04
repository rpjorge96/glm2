import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("keydown", this.handleKeyDown);
  }

  disconnect() {
    this.element.removeEventListener("keydown", this.handleKeyDown);
  }

  handleKeyDown = (event) => {
    if (event.key === " ") {
      event.preventDefault();
      var value = this.element.value;
      var spaceCount = (value.match(/ /g) || []).length;

      if (spaceCount < 3) {
        var symbol = spaceCount === 0 ? "° " : spaceCount === 1 ? "' " : '" ';
        this.element.value = value + symbol;
      }
    }
  };
}
