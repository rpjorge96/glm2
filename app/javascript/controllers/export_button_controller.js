import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["exportFormat"];

  updateFormat(event) {
    const format = event.currentTarget.getAttribute("data-format");
    this.exportFormatTarget.value = format;
  }
}
