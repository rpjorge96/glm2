import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { duration: Number };

  connect() {
    this.startTimeout();
    this.animateProgress();
  }

  startTimeout() {
    this.timeout = setTimeout(() => this.close(), this.durationValue || 8000);
  }

  animateProgress() {
    setTimeout(() => {
      const progressBar = this.element.querySelector(".toast-progress");
      if (progressBar) {
        progressBar.style.transition = `width ${this.durationValue || 8000}ms linear`;
        progressBar.style.width = "0";
      }
    }, 100);
  }

  dismiss() {
    clearTimeout(this.timeout);
    this.close();
  }

  close() {
    clearTimeout(this.timeout);
    this.element.classList.add(
      "opacity-0",
      "transition-opacity",
      "duration-500",
    );
    setTimeout(() => this.element.remove(), 500);
  }
}
