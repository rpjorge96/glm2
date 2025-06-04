import ApplicationController from "controllers/application_controller";

export default class extends ApplicationController {
  static targets = ["approveButton", "unapproveButton"];

  approveForm = null;
  unapproveForm = null;

  connect() {
    this.approveForm = document
      .getElementById("approve_discount")
      .querySelector("form");
    this.unapproveForm = document
      .getElementById("unapprove_discount")
      .querySelector("form");

    const approveInput = Object.assign(document.createElement("input"), {
      type: "hidden",
      name: "discount_authorization[status]",
      value: "approved",
    });

    const unapproveInput = Object.assign(document.createElement("input"), {
      type: "hidden",
      name: "discount_authorization[status]",
      value: "unapproved",
    });

    this.approveForm.appendChild(approveInput);
    this.unapproveForm.appendChild(unapproveInput);
  }

  approve() {
    const url = this.approveButtonTarget.getAttribute("data-update-url");
    this.approveForm.action = url;
  }

  unapprove() {
    const url = this.unapproveButtonTarget.getAttribute("data-update-url");
    this.unapproveForm.action = url;
  }
}
