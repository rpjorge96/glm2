import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleButton"];

  connect() {
    this.loadSidebarState();
    this.addHoverListeners();
  }

  toggle() {
    const sidebar = document.getElementById("logo-sidebar");
    const content = document.getElementById("main-sidebar-content");
    const button = document.getElementById("toggle-button");
    const isExpanded = sidebar.classList.contains("expanded");

    if (isExpanded) {
      sidebar.classList.remove("expanded");
      content.classList.remove("expanded");
      button.classList.remove("selected");
      localStorage.setItem("sidebarExpanded", "false");
    } else {
      sidebar.classList.add("expanded");
      content.classList.add("expanded");
      button.classList.add("selected");
      localStorage.setItem("sidebarExpanded", "true");
    }
  }

  loadSidebarState() {
    const sidebar = document.getElementById("logo-sidebar");
    const content = document.getElementById("main-sidebar-content");
    const button = document.getElementById("toggle-button");
    const isExpanded = localStorage.getItem("sidebarExpanded") === "true";

    if (isExpanded) {
      sidebar.classList.add("expanded");
      content.classList.add("expanded");
      button.classList.add("selected");
    } else {
      sidebar.classList.remove("expanded");
      content.classList.remove("expanded");
      button.classList.remove("selected");
    }
  }

  addHoverListeners() {
    const sidebar = document.getElementById("logo-sidebar");
    const content = document.getElementById("main-sidebar-content");

    sidebar.addEventListener("mouseenter", () => {
      if (!sidebar.classList.contains("expanded")) {
        content.classList.add("hovered");
      }
    });

    sidebar.addEventListener("mouseleave", () => {
      if (!sidebar.classList.contains("expanded")) {
        content.classList.remove("hovered");
      }
    });
  }
}
