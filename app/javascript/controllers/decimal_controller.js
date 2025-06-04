import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  restrictDecimals() {
    const value = this.element.value;
    if (!value.match(/^\d*\.?\d{0,4}$/)) {
      this.element.value = value.slice(0, -1);
    }
  }
}
