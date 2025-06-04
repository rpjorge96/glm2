import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { delay: Number };

  connect() {
    this.timeout = null;
    this.delay = this.hasDelayValue ? this.delayValue : 500;
  }

  debouncedSearch() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.performSearch();
    }, this.delay);
  }

  performSearch() {
    const form = this.element;
    const formAction = form.getAttribute("action");

    const url = new URL(formAction, window.location.origin);

    new FormData(form).forEach((value, key) => {
      if (key === "page") return;
      url.searchParams.set(key, value);
    });

    url.searchParams.set("page", "1");

    Turbo.visit(url.toString(), { action: "replace" });
  }
}
