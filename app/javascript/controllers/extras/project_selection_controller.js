import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["projectsContainer"];
  static values = {
    projects: Array,
    controlUnitTypes: Array,
    projectsControlUnitTypes: { type: Array, default: [] },
  };
  allAdded = false;

  connect() {
    this.projectsData = this.projectsValue.slice(); // Hacer una copia de los proyectos iniciales
    this.controlUnitTypesData = this.controlUnitTypesValue;

    if (this.projectsControlUnitTypesValue.length > 0) {
      // Agregar automáticamente los proyectos desde projectsControlUnitTypes
      const addedProjects = new Set();

      this.projectsControlUnitTypesValue.forEach((entry) => {
        const project = this.projectsValue.find(
          (proj) => proj.id === entry.project_id,
        );
        if (project && !addedProjects.has(project.id)) {
          this.addProjectSelection({ project });
          addedProjects.add(project.id);
        }
      });
    }

    this.addGeneralCheckboxes(); // Agregar los checkboxes generales al conectar
  }

  addProjectSelection({ project = null, selectAll = false } = {}) {
    this.disablePreviousSelects();

    const projectSelection = document.createElement("div");
    projectSelection.classList.add("project_selection");

    const projectSelect = document.createElement("select");
    projectSelect.name = "extra[project_ids][]";
    projectSelect.className =
      "project-select bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 mb-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500";

    const selectedProjects = Array.from(
      this.projectsContainerTarget.querySelectorAll(".project-select"),
    ).map((select) => parseInt(select.value));

    this.projectsValue.forEach((proj) => {
      if (!selectedProjects.includes(proj.id)) {
        const option = document.createElement("option");
        option.value = proj.id;
        option.textContent = proj.name;
        projectSelect.appendChild(option);
      }
    });

    if (project) {
      projectSelect.value = project.id;
    } else if (projectSelect.options.length > 0) {
      projectSelect.value = projectSelect.options[0].value;
    }

    projectSelection.appendChild(projectSelect);

    const controlUnitTypesContainer = document.createElement("div");
    controlUnitTypesContainer.classList.add("control-unit-types-container");
    projectSelection.appendChild(controlUnitTypesContainer);

    const generateCheckboxes = (projectId) => {
      controlUnitTypesContainer.innerHTML = "";

      const selectAllCheckbox = document.createElement("input");
      selectAllCheckbox.type = "checkbox";
      selectAllCheckbox.id = `select_all_${Date.now()}`;
      selectAllCheckbox.className = "sr-only peer";

      const selectAllLabelContainer = document.createElement("label");
      selectAllLabelContainer.className =
        "inline-flex items-center cursor-pointer";
      selectAllLabelContainer.appendChild(selectAllCheckbox);

      const selectAllCheckboxDiv = document.createElement("div");
      selectAllCheckboxDiv.className =
        'relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[""] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600';
      selectAllLabelContainer.appendChild(selectAllCheckboxDiv);

      const selectAllLabelText = document.createElement("span");
      selectAllLabelText.className =
        "ms-3 text-sm font-medium text-gray-900 dark:text-gray-300";
      selectAllLabelText.textContent = "Seleccionar Todos";
      selectAllLabelContainer.appendChild(selectAllLabelText);

      controlUnitTypesContainer.appendChild(selectAllLabelContainer);
      controlUnitTypesContainer.appendChild(document.createElement("br"));

      selectAllCheckbox.addEventListener("change", function () {
        const checkboxes = controlUnitTypesContainer.querySelectorAll(
          'input[type="checkbox"]:not(#' + selectAllCheckbox.id + ")",
        );
        checkboxes.forEach((checkbox) => {
          checkbox.checked = selectAllCheckbox.checked;
        });
      });

      this.controlUnitTypesData.forEach((type) => {
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.name = `extra[project_control_unit_type_ids][${projectId}][]`;
        checkbox.value = type.id;
        checkbox.className = "sr-only peer type-checkbox";
        checkbox.dataset.typeId = type.id;

        // Verificar si el toggle debería estar seleccionado según la configuración actual
        if (
          this.projectsControlUnitTypesValue.some(
            (pcu) =>
              pcu.project_id === parseInt(projectId) &&
              pcu.control_unit_type_id === type.id,
          )
        ) {
          checkbox.checked = true;
        } else if (selectAll) {
          checkbox.checked = true;
        }

        const checkboxLabelContainer = document.createElement("label");
        checkboxLabelContainer.className =
          "inline-flex items-center cursor-pointer";
        checkboxLabelContainer.appendChild(checkbox);

        const checkboxDiv = document.createElement("div");
        checkboxDiv.className =
          'relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[""] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600';
        checkboxLabelContainer.appendChild(checkboxDiv);

        const checkboxLabelText = document.createElement("span");
        checkboxLabelText.className =
          "ms-3 text-sm font-medium text-gray-900 dark:text-gray-300";
        checkboxLabelText.textContent = type.name;
        checkboxLabelContainer.appendChild(checkboxLabelText);

        controlUnitTypesContainer.appendChild(checkboxLabelContainer);
        controlUnitTypesContainer.appendChild(document.createElement("br"));
      });

      if (selectAll) {
        selectAllCheckbox.checked = true;
      }
    };

    generateCheckboxes(projectSelect.value);

    projectSelect.addEventListener("change", (event) => {
      generateCheckboxes(event.target.value);
    });

    const removeButton = document.createElement("button");
    removeButton.type = "button";
    removeButton.textContent = "Quitar Proyecto";
    removeButton.className =
      "remove_project text-red-700 hover:text-white border border-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2 dark:border-red-500 dark:text-red-500 dark:hover:text-white dark:hover:bg-red-600 dark:focus:ring-red-900";

    removeButton.addEventListener("click", () => {
      this.projectsContainerTarget.removeChild(projectSelection);
      this.updateProjectSelects();
      this.addGeneralCheckboxes(); // Verificar si se deben mostrar los checkboxes generales
    });

    projectSelection.appendChild(removeButton);

    this.projectsContainerTarget.appendChild(projectSelection);
    this.updateProjectSelects();

    this.addGeneralCheckboxes(); // Verificar si se deben mostrar los checkboxes generales
  }

  addGeneralCheckboxes() {
    const projectCount =
      this.projectsContainerTarget.querySelectorAll(".project-select").length;

    // Verificar si hay 2 o más proyectos agregados
    if (projectCount < 2) {
      const existingContainer = document.querySelector(
        ".general-checkboxes-container",
      );
      if (existingContainer) {
        existingContainer.remove(); // Remover los checkboxes generales si no se cumplen las condiciones
      }
      return;
    }

    // Si ya existe el contenedor, no hacer nada
    if (document.querySelector(".general-checkboxes-container")) {
      return;
    }

    // Obtener el contenedor del botón
    const button = document.querySelector(
      '[data-action="extras--project-selection#toggleAllProjectsAndTypes"]',
    );

    // Crear un contenedor para los checkboxes generales
    const generalCheckboxesContainer = document.createElement("div");
    generalCheckboxesContainer.classList.add("general-checkboxes-container");
    button.insertAdjacentElement("afterend", generalCheckboxesContainer);

    // Generar un checkbox general para cada tipo de unidad de control
    this.controlUnitTypesData.forEach((type) => {
      const generalCheckbox = document.createElement("input");
      generalCheckbox.type = "checkbox";
      generalCheckbox.className = "sr-only peer general-type-checkbox";
      generalCheckbox.dataset.typeId = type.id; // Añadir el ID del tipo como atributo de datos

      const checkboxLabelContainer = document.createElement("label");
      checkboxLabelContainer.className =
        "inline-flex items-center cursor-pointer";
      checkboxLabelContainer.appendChild(generalCheckbox);

      const checkboxDiv = document.createElement("div");
      checkboxDiv.className =
        'relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[""] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600';
      checkboxLabelContainer.appendChild(checkboxDiv);

      const checkboxLabelText = document.createElement("span");
      checkboxLabelText.className =
        "ms-3 text-sm font-medium text-gray-900 dark:text-gray-300";
      checkboxLabelText.textContent = `Aplicar a todos los proyectos agregados: ${type.name}`;
      checkboxLabelContainer.appendChild(checkboxLabelText);

      generalCheckboxesContainer.appendChild(checkboxLabelContainer);
      generalCheckboxesContainer.appendChild(document.createElement("br"));

      // Listener para activar/desactivar todos los checkboxes correspondientes en la pantalla
      generalCheckbox.addEventListener("change", (event) => {
        const typeId = event.target.dataset.typeId;
        const allTypeCheckboxes = document.querySelectorAll(
          `.type-checkbox[data-type-id="${typeId}"]`,
        );
        allTypeCheckboxes.forEach((checkbox) => {
          checkbox.checked = event.target.checked;
        });
      });
    });
  }

  disablePreviousSelects() {
    const selects =
      this.projectsContainerTarget.querySelectorAll(".project-select");
    selects.forEach((select) => {
      select.disabled = true;
    });
  }

  updateProjectSelects() {
    const selects =
      this.projectsContainerTarget.querySelectorAll(".project-select");
    const selectedProjects = Array.from(selects).map((select) =>
      parseInt(select.value),
    );

    selects.forEach((select, index) => {
      const selectedValue = parseInt(select.value);

      // Limpiar las opciones actuales
      while (select.options.length > 0) {
        select.remove(0);
      }

      // Reagregar las opciones disponibles, omitiendo las seleccionadas
      this.projectsValue.forEach((proj) => {
        if (!selectedProjects.includes(proj.id) || proj.id === selectedValue) {
          const option = document.createElement("option");
          option.value = proj.id;
          option.textContent = proj.name;
          select.appendChild(option);
        }
      });

      // Reagregar la opción seleccionada y deshabilitar el select si no es el último
      select.value = selectedValue;
      select.disabled = index < selects.length - 1;
    });
  }

  toggleAllProjectsAndTypes() {
    this.allAdded = !this.allAdded;

    // Cambiar el texto del botón según el estado de selección
    const button = document.querySelector(
      '[data-action="extras--project-selection#toggleAllProjectsAndTypes"]',
    );
    button.textContent = this.allAdded
      ? "Quitar todos los proyectos/tipos"
      : "Agregar todos los proyectos/tipos";

    // Añadir o quitar todas las selecciones de proyectos
    this.projectsContainerTarget.innerHTML = "";
    if (this.allAdded) {
      this.projectsValue.forEach((project) => {
        this.addProjectSelection({
          project,
          selectAll: true,
        });
      });
    }

    this.addGeneralCheckboxes();
  }
}
