// app/javascript/controllers/charts/control_units_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    data: Array,
    categories: Array,
  };

  connect() {
    const options = {
      series: [
        {
          name: "Unidades de control",
          data: this.dataValue,
          // Resto de la configuración...
        },
      ],
      chart: {
        sparkline: {
          enabled: false,
        },
        type: "bar",
        width: "100%",
        height: 400,
        toolbar: {
          offsetX: 0,
          offsetY: -30,
          show: true,
        },
        export: {
          csv: {
            headerCategory: "Proyectos",
          },
        },
      },
      fill: {
        opacity: 1,
      },
      plotOptions: {
        bar: {
          horizontal: true,
          columnWidth: "100%",
          borderRadiusApplication: "end",
          borderRadius: 6,
          dataLabels: {
            position: "top",
          },
        },
      },
      legend: {
        show: true,
        position: "bottom",
      },
      dataLabels: {
        enabled: false,
      },
      tooltip: {
        shared: true,
        intersect: false,
        formatter: function (value) {
          return value;
        },
      },
      xaxis: {
        title: {
          text: "Unidades de control",
        },
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: "font-normal fill-gray-500 dark:fill-gray-400",
          },
          formatter: function (value) {
            return value;
          },
        },
        type: "category",
        categories: this.categoriesValue,
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: true,
        },
      },
      yaxis: {
        title: {
          text: "Proyectos",
        },
        labels: {
          show: true,
          align: "left",
          maxWidth: 350,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: "font-normal fill-gray-500 dark:fill-gray-400",
          },
          formatter: (value) => {
            // Break text on white space when too long
            if (typeof value === "string" || value instanceof String) {
              return value.replace(/(.{1,28})(\s|$)/g, "$1\n");
            }
            return value;
          },
        },
      },
      grid: {
        show: false,
        strokeDashArray: 4,
        padding: {
          left: 0,
          top: -20,
        },
      },
    };

    if (document.getElementById("bar-chart")) {
      const chart = new ApexCharts(
        document.getElementById("bar-chart"),
        options,
      );
      chart.render();
    }
  }
}
