import { Controller } from "@hotwired/stimulus";
// import "flowbite";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.initializeDismiss();
    }, 5000);
  }

  initializeDismiss() {
    const options = {
      transition: "transition-opacity",
      duration: 1000,
      timing: "ease-out",
      onHide: () => {},
    };

    const dismiss = new Dismiss(this.element, null, options);
    dismiss.hide();
  }

  dismissAlert() {
    this.initializeDismiss();
  }
}
