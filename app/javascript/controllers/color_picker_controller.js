import { Controller } from "@hotwired/stimulus";

import "coloris";

export default class extends Controller {
  connect() {
    this.initializeColorPicker();
  }

  initializeColorPicker() {
    Coloris({
      el: ".input-color-picker",
      defaultColor: "#FFF",
      swatches: [
        "#264653",
        "#2a9d8f",
        "#e9c46a",
        "rgb(244,162,97)",
        "#e76f51",
        "#d62828",
        "#07b",
        "#0096c7",
        "#00b4d8",
        "rgba(0,119,182,1)",
      ],
    });
  }
}
