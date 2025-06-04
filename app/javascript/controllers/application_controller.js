import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  formatValue(event) {
    let target = event.currentTarget;
    let value = parseFloat(target.value);
    target.value = value.toFixed(2);
  }

  formatAsCurrency(value, currency, precision) {
    if (isNaN(value)) {
      value = 0;
    }

    let formatter = new Intl.NumberFormat("en-US", {
      minimumFractionDigits: precision,
      maximumFractionDigits: precision,
    });

    return `${currency} ${formatter.format(value)}`;
  }

  createToast(type = "success", message, duration = 8000) {
    const toastContainer = document.querySelector("#toast-container");
    if (!toastContainer) {
      console.error("No se encontró el contenedor de toasts.");
      return;
    }

    const toast = document.createElement("div");
    toast.dataset.controller = "toast";
    toast.dataset.toastDurationValue = duration;

    toast.className =
      "relative flex items-center max-w-xs p-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800";

    let iconColorClass =
      "text-green-500 bg-green-100 dark:bg-green-800 dark:text-green-200";
    let progressColorClass = "bg-green-500";
    let iconSvg = `
      <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
        <path d="M16.707 5.293a1 1 0 0 0-1.414 0L9 11.586l-2.293-2.293a1 1 0 0 0-1.414 1.414l3 3a1 1 0 0 0 1.414 0l7-7a1 1 0 0 0 0-1.414Z"/>
      </svg>`;

    if (type === "error") {
      iconColorClass =
        "text-red-500 bg-red-100 dark:bg-red-800 dark:text-red-200";
      progressColorClass = "bg-red-500";
      iconSvg = `
        <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
          <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 11.793a1 1 0 1 1-1.414 1.414L10 11.414l-2.293 2.293a1 1 0 0 1-1.414-1.414L8.586 10 6.293 7.707a1 1 0 0 1 1.414-1.414L10 8.586l2.293-2.293a1 1 0 0 1 1.414 1.414L11.414 10l2.293 2.293Z"/>
        </svg>`;
    }

    toast.innerHTML = `
      <div class="inline-flex items-center justify-center w-8 h-8 ${iconColorClass} rounded-lg">
        ${iconSvg}
      </div>
      <div class="ml-3 text-sm font-normal">${message}</div>
      <div class="absolute bottom-0 left-0 w-full h-1 overflow-hidden">
        <div class="h-full ${progressColorClass} toast-progress" style="width: 100%;"></div>
      </div>
      <button
        type="button"
        class="ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700"
        data-action="toast#dismiss">
        <span class="sr-only">Cerrar</span>
        <svg class="w-3 h-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1l6 6m0 0l6 6M7 7l6-6M7 7L1 13"/>
        </svg>
      </button>
    `;

    toastContainer.appendChild(toast);
  }
}
