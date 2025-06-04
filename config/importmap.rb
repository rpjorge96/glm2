# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "coloris", to: "coloris.min.js", preload: true
pin "pagy", to: "pagy.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/components", under: "components", to: ""

pin "flowbite", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.turbo.min.js"
pin "flowbite-datepicker", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/datepicker.turbo.min.js"
pin "apexcharts", to: "https://cdn.jsdelivr.net/npm/apexcharts"
pin "html2pdf.js", to: "https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"
pin "html2canvas", to: "https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"

# Custom javascripts
pin "custom_financial_entity_helper", to: "services/custom_financial_entity_helper.js"
