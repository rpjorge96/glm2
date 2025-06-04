import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["country", "subdivision", "city"];

  updateSubdivision() {
    const country = this.countryTarget.value;
    const url = `/country_settings/subdivisions?country=${country}`;

    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        this.updateStatesSelect(data);
      })
      .catch((error) => console.error("Error fetching states:", error));
  }

  updateStatesSelect(data) {
    let options = data
      .map((state) => `<option value="${state}">${state}</option>`)
      .join("");
    this.subdivisionTarget.innerHTML = `${options}`;
    this.updateCity();
  }

  updateCity() {
    const subdivision = this.subdivisionTarget.value;
    const country = this.countryTarget.value;
    const url = `/country_settings/cities?subdivision=${subdivision}&country=${country}`;

    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        let options = data
          .map((city) => `<option value="${city}"></option>`)
          .join("");
        this.cityTarget.innerHTML = options;
      })
      .catch((error) => console.error("Error fetching cities:", error));
  }
}
