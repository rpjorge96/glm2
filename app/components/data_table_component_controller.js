import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    this.page = urlParams.get("page") || 1;
    this.perPage = urlParams.get("per_page") || 25;
    this.sortBy = urlParams.get("sort_by") || "-created_at";
  }

  sort(event) {
    const sortField = event.currentTarget.dataset.field;
    if (sortField === this.sortBy) {
      this.sortBy = `-${sortField}`;
    } else {
      this.sortBy = sortField;
    }

    this.load();
  }

  load() {
    const url = new URL(window.location);
    url.searchParams.set("page", this.page);
    url.searchParams.set("per_page", this.perPage);
    url.searchParams.set("sort_by", this.sortBy);
    window.location = url.toString();
  }
}
