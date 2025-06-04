import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  loginRecaptcha(event) {
    const form = this.element.closest("form"); // Encuentra el formulario más cercano
    var inputRecaptchaElement = document.getElementById(
      "g-recaptcha-response-data-login",
    );

    if (!form.checkValidity() || !inputRecaptchaElement) {
      // Si el formulario no es válido o recaptcha no esta activo, deja que el navegador maneje las validaciones
      return;
    }

    event.preventDefault();

    // update the inputRecaptchaElement with the token
    grecaptcha.ready(function () {
      grecaptcha
        .execute(inputRecaptchaElement.dataset.sitekey, { action: "login" })
        .then(function (token) {
          inputRecaptchaElement.value = token;
          form.submit();
        });
    });
  }
}
