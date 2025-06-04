import { Controller } from "@hotwired/stimulus";
// eslint-disable-next-line no-unused-vars
import * as pagy from "pagy";

export default class extends Controller {
  connect() {
    Pagy.init(this.element);
  }
}
