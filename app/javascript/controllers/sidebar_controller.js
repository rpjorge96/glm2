import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["admin", "sells", "checking"];
  static values = { role: String };

  connect() {
    requestAnimationFrame(() => {
      const currentView = localStorage.getItem("sidebarView") || "admin";
      const role = this.roleValue;

      if (role === "vendedor") {
        this.showSellsSidebar();
        return;
      }

      if (currentView === "sells") {
        this.showSellsSidebar();
      } else if (role === "admin") {
        if (currentView === "checking") {
          this.showCheckingSidebar();
        } else {
          this.showAdminSidebar();
        }
      } else {
        this.showSellsSidebar();
      }
    });
  }

  showSellsSidebar(event) {
    if (event) this.navigateAndPreventDefault(event);
    this.adminTarget.classList.add("hidden");
    this.checkingTarget.classList.add("hidden");
    this.sellsTarget.classList.remove("hidden");
    localStorage.setItem("sidebarView", "sells");
  }

  showAdminSidebar(event) {
    if (event) this.navigateAndPreventDefault(event);
    this.sellsTarget.classList.add("hidden");
    this.checkingTarget.classList.add("hidden");
    this.adminTarget.classList.remove("hidden");
    localStorage.setItem("sidebarView", "admin");
  }

  showCheckingSidebar(event) {
    if (event) this.navigateAndPreventDefault(event);
    this.sellsTarget.classList.add("hidden");
    this.adminTarget.classList.add("hidden");
    this.checkingTarget.classList.remove("hidden");
    localStorage.setItem("sidebarView", "checking");
  }

  navigateAndPreventDefault(event) {
    event.preventDefault();
    const href = event.currentTarget.getAttribute("href");
    if (href) window.location.href = href;
  }

  navigateByCurrentView(event) {
    event.preventDefault();

    const currentView = localStorage.getItem("sidebarView") || "admin";
    const href = currentView === "sells" ? "/ventas/home" : "/";

    window.location.href = href;
  }
}
