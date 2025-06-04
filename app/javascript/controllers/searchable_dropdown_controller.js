import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static selectedItem = null;
  static targets = ["input", "inputField", "dropdown"];
  static values = {
    items: Array,
    keysToCompare: Array,
    allowNewValue: Boolean,
  };

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
    document.addEventListener("keydown", this.handleKeyDown.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
    document.removeEventListener("keydown", this.handleKeyDown.bind(this));
  }

  handleClickOutside(event) {
    if (
      !this.dropdownTarget.contains(event.target) &&
      !this.inputFieldTarget.contains(event.target)
    ) {
      this.closeDropdown();
    }
  }

  handleKeyDown(event) {
    if (event.key === "Tab") {
      if (this.dropdownTarget.style.display === "block") {
        const filteredItems = this.search();
        if (filteredItems.length > 0) {
          this.selectItem(filteredItems[0]);
        } else {
          this.selectCustom(this.inputTarget.value);
        }
        event.preventDefault();
      }
    }
    if (event.key === "Escape") {
      this.closeDropdown();
    }
  }

  closeDropdown() {
    this.dropdownTarget.style.display = "none";
  }

  search() {
    const query = this.inputTarget.value.toLowerCase();
    const filteredItems = this.itemsValue.filter(
      (item) => this.compareData(item, query) || query === "",
    );

    this.renderDropdown(filteredItems);

    if (this.allowNewValueValue && filteredItems.length === 0 && query !== "") {
      this.addCustomOption(query);
    }

    return filteredItems;
  }

  compareData(item, compareValue) {
    return this.keysToCompareValue.some((key) => {
      const value = item[key];
      if (
        typeof value === "string" &&
        value.toLowerCase().includes(compareValue)
      ) {
        return true;
      } else if (
        typeof value === "number" &&
        value.toString().includes(compareValue)
      ) {
        return true;
      }
      return false;
    });
  }

  addClasses(element) {
    element.classList.add(
      "w-full",
      "p-2.5",
      "text-sm",
      "text-gray-900",
      "bg-gray-200",
      "bg-none",
      "cursor-pointer",
      "focus:ring-primary-500",
      "dark:bg-gray-700",
      "dark:placeholder-gray-400",
      "dark:text-white",
      "dark:focus:ring-primary-500",
      "dark:focus:border-primary-500",
    );
  }

  renderDropdown(items) {
    this.dropdownTarget.innerHTML = "";

    this.dropdownTarget.style.position = "relative";
    this.dropdownTarget.style.display = "block";

    this.dropdownTarget.style.maxHeight = "160px";
    this.dropdownTarget.style.overflowY = "auto";

    if (items.length > 0) {
      items.forEach((item) => {
        const option = document.createElement("li");
        this.addClasses(option);
        option.textContent = item.display_text;
        option.dataset.id = item.id;
        option.addEventListener("click", () => this.selectItem(item));
        this.dropdownTarget.appendChild(option);
      });
    } else {
      this.dropdownTarget.style.display = "none";
    }
  }

  addCustomOption(query) {
    const customOption = document.createElement("li");
    this.addClasses(customOption);
    customOption.textContent = `Nuevo: "${query}"`;
    customOption.dataset.custom = true;
    customOption.addEventListener("click", () => this.selectCustom(query));
    this.dropdownTarget.appendChild(customOption);
    this.dropdownTarget.style.display = "block";
  }

  selectItem(item) {
    this.selectedItem = item;
    this.inputTarget.value = item.display_text;
    this.dropdownTarget.style.display = "none";
    this.updateSelectedValue();
  }

  selectCustom(query) {
    this.selectedItem = null;
    this.inputTarget.value = query;
    this.dropdownTarget.style.display = "none";
    this.updateSelectedValue();
  }

  updateSelectedValue() {
    this.inputFieldTargets.forEach((inputField) => {
      const key = inputField.dataset.key; // Get the key from data-key attribute

      // If the selected item has the key, update the input field
      if (
        this.selectedItem &&
        Object.prototype.hasOwnProperty.call(this.selectedItem, key)
      ) {
        inputField.value = this.selectedItem[key] || "";
      } else {
        inputField.value = "";
      }
    });
  }
}
