import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["type", "subtype"];

  updateControlUnitSubType(event) {
    const projectId =
      event.currentTarget.dataset.controlUnitTypeProjectIdParamValue;
    const type = this.typeTarget.value;
    const url = `/control_unit_settings/subtypes?type=${type}&project_id=${projectId}`;

    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        let options = data
          .map(
            (subtype) => `<option value="${subtype[1]}">${subtype[1]}</option>`,
          )
          .join("");
        this.subtypeTarget.innerHTML = options;
      })
      .catch((error) => console.error("Error fetching states:", error));
  }
}
