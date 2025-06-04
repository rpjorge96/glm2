import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["maxAllowedDiscount", "comment"];

  modal = null;

  connect() {
    this.instantiateDiscountAuthorizationModal();
  }

  instantiateDiscountAuthorizationModal() {
    const $targetEl = document.getElementById("discountAuthorizationModal");
    const options = {
      placement: "center",
      backdrop: "dynamic",
      backdropClasses: "bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40",
      closable: false,
      onHide: () => {},
      onShow: () => {},
      onToggle: () => {},
    };

    this.modal = new Modal($targetEl, options);
  }

  closeModal() {
    this.dispatch("closeDiscountAuthorizationModal");
    this.modal.hide();
  }

  openModal({ detail: { maxAllowedDiscount, currency } }) {
    this.maxAllowedDiscountTarget.textContent = `${this.formatAsCurrency(maxAllowedDiscount, currency, 2)}`;
    this.modal.show();
  }

  sendComment() {
    const comment = this.commentTarget.value;
    if (comment === "") {
      this.createToast("error", "El comentario no puede estar vacío.");
      return;
    }
    this.dispatch("sendDiscountAuthorizationComment", {
      detail: { comment: comment },
    });
    this.modal.hide();
  }
}
