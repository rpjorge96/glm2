import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["textarea"];

  connect() {}

  toggleTextArea() {
    const textarea = this.textareaTarget;
    textarea.style.display = textarea.style.display === "none" ? "" : "none";
  }
}
