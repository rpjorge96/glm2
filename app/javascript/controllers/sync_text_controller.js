// app/javascript/controllers/sync_text_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["source", "destination"];

  sync() {
    this.destinationTarget.value = this.sourceTarget.value;
  }
}
