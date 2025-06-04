import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  checkBoxSelectAll(event) {
    const checkboxes = this.element.querySelectorAll("input[type='checkbox']");
    checkboxes.forEach((checkbox) => {
      checkbox.checked = event.target.checked;
    });
  }
}
