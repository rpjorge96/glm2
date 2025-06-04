import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["country", "subdivision", "city"];

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
        this.updateCitiesSelect(data);
      })
      .catch((error) => console.error("Error fetching cities:", error));
  }

  updateCitiesSelect(data) {
    let options = data
      .map((city) => `<option value="${city}"></option>`)
      .join("");
    this.cityTarget.innerHTML = options;
  }
}
