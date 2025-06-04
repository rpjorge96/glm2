import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static values = {
    modalId: String,
    opened: Boolean,
  };

  modal = null;

  initialize() {
    this.instantiateModalComponent();
  }

  connect() {
    if (this.openedValue) {
      setTimeout(() => {
        this.clickModalTriggerOpen();
      }, 10);
    }
  }

  instantiateModalComponent() {
    const modalId = this.modalIdValue;
    const $targetEl = document.getElementById(modalId);
    const options = {
      placement: "center",
      backdrop: "static",
      closable: false,
      onHide: () => {},
      onShow: () => {},
      onToggle: () => {},
    };

    const instanceOptions = {
      id: modalId,
      override: false,
    };

    this.modal = new Modal($targetEl, options, instanceOptions);
  }

  closeModal() {
    this.modal.hide();
  }

  openModal() {
    this.modal.show();
  }

  clickModalTriggerOpen() {
    const divToTrigger = document.getElementById(
      `modal-trigger-open-${this.modalIdValue}`,
    );
    divToTrigger.click();
  }
}
