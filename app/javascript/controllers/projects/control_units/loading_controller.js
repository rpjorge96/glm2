import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];

  showLoadingImage() {
    this.containerTargets.forEach((target) => {
      target.classList.remove("hidden");
    });
  }
}
