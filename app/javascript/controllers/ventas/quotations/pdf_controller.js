import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "header", "footer"];

  download() {
    // Obtén el contenido que quieres convertir a PDF
    const element = this.contentTarget;

    // Opciones para html2pdf
    const options = {
      margin: 0,
      filename: "cotizacion.pdf",
      image: { type: "jpeg", quality: 0.98 },
      html2canvas: { scale: 2, backgroundColor: null },
      jsPDF: { unit: "in", format: "letter", orientation: "portrait" },
      pagebreak: { mode: ["avoid-all"], before: [".page-break"] },
      customStyles: ".page-break { page-break-before: always; }",
    };

    // Genera y descarga el PDF
    // html2pdf().from(element).set(options).save();

    // Genera el PDF y abre una nueva pestaña con el PDF
    html2pdf()
      .from(element)
      .set(options)
      .outputPdf("blob")
      .then((pdfBlob) => {
        // Crear una URL para el Blob
        const pdfUrl = URL.createObjectURL(pdfBlob);

        // Abrir el PDF en una nueva pestaña
        window.open(pdfUrl);
      });
  }

  sendPdf() {
    const element = this.contentTarget;

    const options = {
      margin: 0,
      filename: "cotizacion.pdf",
      image: { type: "jpeg", quality: 0.98 },
      html2canvas: { scale: 2, backgroundColor: null },
      jsPDF: { unit: "in", format: "letter", orientation: "portrait" },
    };

    // Genera el PDF como un Blob
    html2pdf()
      .from(element)
      .set(options)
      .outputPdf("blob")
      .then((pdfBlob) => {
        // Crear un FormData para enviar el Blob al servidor
        const formData = new FormData();
        formData.append("pdf", pdfBlob, "cotizacion.pdf");

        // Enviar el Blob al servidor
        fetch("/ventas/quotations/send_email_pdf", {
          method: "POST",
          body: formData,
          headers: {
            "X-CSRF-Token": document
              .querySelector('meta[name="csrf-token"]')
              .getAttribute("content"),
          },
        })
          .then((response) => {
            if (response.ok) {
              // Convertir la respuesta a un Blob
              return response.blob();
            } else {
              throw new Error("Error en la respuesta del servidor");
            }
          }) // Es una prueba que el rails controller reciba el pdf, entonces lo abrimos en una nueva pestaña
          .then((blob) => {
            // Crear una URL para el Blob y abrirla en una nueva pestaña
            const url = window.URL.createObjectURL(blob);
            window.open(url); // Abrir el PDF en una nueva pestaña
            window.URL.revokeObjectURL(url); // Limpiar la URL temporal después de abrir
          })
          .catch((error) => {
            alert("Hubo un problema al enviar el PDF.");
            console.error("Error:", error);
          });
        // }).then(response => {
        //   if (response.ok) {
        //     alert('El PDF se ha enviado con éxito.');
        //   } else {
        //     alert('Hubo un problema al enviar el PDF.');
        //   }
        // });
      });
  }

  // ejemplo con mas opciones, header y footer
  preview() {
    const element = this.contentTarget;
    const headerElement = this.headerTarget;
    const footerElement = this.footerTarget;

    // Capturar header y footer en paralelo
    Promise.all([html2canvas(headerElement), html2canvas(footerElement)])
      .then(([headerCanvas, footerCanvas]) => {
        const headerImgData = headerCanvas.toDataURL("image/jpg");
        const footerImgData = footerCanvas.toDataURL("image/jpg");

        const options = {
          margin: 1,
          filename: "cotizacion.pdf",
          image: { type: "jpg", quality: 0.98 },
          html2canvas: {
            scale: 2,
            backgroundColor: "#ffffff",
            logging: true,
          },
          jsPDF: {
            unit: "in",
            format: "letter",
            orientation: "portrait",
            compressPdf: true,
          },
          pagebreak: { mode: ["avoid-all"], before: [".page-break"] },
          customStyles: ".page-break { page-break-before: always; }",
        };

        // Generar el PDF
        html2pdf()
          .from(element)
          .set(options)
          .toPdf()
          .get("pdf")
          .then((pdf) => {
            const totalPages = pdf.internal.getNumberOfPages();

            for (let i = 1; i <= totalPages; i++) {
              pdf.setPage(i);

              // Insertar imagen del encabezado
              pdf.addImage(
                headerImgData,
                "JPG",
                0.5, // Posición X
                0, // Posición Y
                pdf.internal.pageSize.getWidth() - 1, // Ancho de la imagen
                1, // Altura de la imagen
              );

              // Insertar imagen del pie de página
              pdf.addImage(
                footerImgData,
                "JPG",
                0.5, // Posición X
                pdf.internal.pageSize.getHeight() - 1, // Posición Y
                pdf.internal.pageSize.getWidth() - 1, // Ancho de la imagen
                1, // Altura de la imagen
              );
            }

            // Abre el PDF en una nueva ventana o guarda el archivo
            const pdfBlob = pdf.output("blob"); // Obtén un Blob para abrir en una nueva ventana
            const pdfUrl = URL.createObjectURL(pdfBlob);
            window.open(pdfUrl, "_blank"); // Abre en una nueva ventana

            // O usa pdf.save() para descargar automáticamente
            // pdf.save('documento_con_encabezado_pie.pdf');
          });
      })
      .catch((error) => {
        console.error(
          "Error en el proceso de captura o generación del PDF:",
          error,
        );
      });
  }
}
