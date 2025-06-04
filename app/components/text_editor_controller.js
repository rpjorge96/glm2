import { Controller } from "@hotwired/stimulus";
import { Editor } from "https://esm.sh/@tiptap/core@2.6.6";
import StarterKit from "https://esm.sh/@tiptap/starter-kit@2.6.6";
import Highlight from "https://esm.sh/@tiptap/extension-highlight@2.6.6";
import Underline from "https://esm.sh/@tiptap/extension-underline@2.6.6";
import Link from "https://esm.sh/@tiptap/extension-link@2.6.6";
import TextAlign from "https://esm.sh/@tiptap/extension-text-align@2.6.6";
import Image from "https://esm.sh/@tiptap/extension-image@2.6.6";
import YouTube from "https://esm.sh/@tiptap/extension-youtube@2.6.6";
import TextStyle from "https://esm.sh/@tiptap/extension-text-style@2.6.6";
import FontFamily from "https://esm.sh/@tiptap/extension-font-family@2.6.6";
import { Color } from "https://esm.sh/@tiptap/extension-color@2.6.6";
import Bold from "https://esm.sh/@tiptap/extension-bold@2.6.6";

export default class extends Controller {
  static values = {
    id: String,
    fallbackId: String,
    initialContent: String,
    options: Array,
  };

  connect() {
    const id = this.idValue;
    const fallbackId = this.fallbackIdValue;
    const initialContent = this.initialContentValue;
    const options = this.optionsValue;

    const element = this.element.querySelector(`[data-editor="${id}"]`);

    if (document.getElementById(id)) {
      const FontSizeTextStyle = TextStyle.extend({
        addAttributes() {
          return {
            fontSize: {
              default: null,
              parseHTML: (element) => element.style.fontSize,
              renderHTML: (attributes) => {
                if (!attributes.fontSize) {
                  return {};
                }
                return { style: "font-size: " + attributes.fontSize };
              },
            },
          };
        },
      });
      const CustomBold = Bold.extend({
        // Override the renderHTML method
        renderHTML({ HTMLAttributes }) {
          const { style, ...rest } = HTMLAttributes;

          // Merge existing styles with font-weight
          const newStyle = "font-weight: bold;" + (style ? " " + style : "");

          return ["span", { ...rest, style: newStyle.trim() }, 0];
        },
        // Ensure it doesn't exclude other marks
        addOptions() {
          return {
            ...this.parent?.(),
            HTMLAttributes: {},
          };
        },
      });
      // tip tap editor setup
      const editor = new Editor({
        element: element,
        extensions: [
          StarterKit.configure({
            textStyle: false,
            bold: false,
            marks: {
              bold: false,
            },
            bulletList: {
              HTMLAttributes: {
                class: "list-disc pl-4",
              },
            },
            orderedList: {
              HTMLAttributes: {
                class: "list-decimal pl-4",
              },
            },
          }),
          // Include the custom Bold extension
          CustomBold,
          Color,
          FontSizeTextStyle,
          FontFamily,
          Highlight,
          Underline,
          Link.configure({
            openOnClick: false,
            autolink: true,
            defaultProtocol: "https",
          }),
          TextAlign.configure({
            types: ["heading", "paragraph"],
          }),
          Image,
          YouTube,
        ],
        content: initialContent,
        onUpdate: ({ editor }) => {
          // Update the hidden input field with the current editor content
          document.querySelector(`#${fallbackId}`).value = editor.getHTML();
        },
        editorProps: {
          attributes: {
            class:
              "format lg:format-lg dark:format-invert focus:outline-none format-blue max-w-none",
          },
        },
      });

      // set up custom event listeners for the buttons
      if (options.includes("bold")) {
        document
          .getElementById(`${id}-toggleBoldButton`)
          .addEventListener("click", () =>
            editor.chain().focus().toggleBold().run(),
          );
      }
      if (options.includes("italic")) {
        document
          .getElementById(`${id}-toggleItalicButton`)
          .addEventListener("click", () =>
            editor.chain().focus().toggleItalic().run(),
          );
      }
      if (options.includes("underline")) {
        document
          .getElementById(`${id}-toggleUnderlineButton`)
          .addEventListener("click", () =>
            editor.chain().focus().toggleUnderline().run(),
          );
      }
      if (options.includes("strike")) {
        document
          .getElementById(`${id}-toggleStrikeButton`)
          .addEventListener("click", () =>
            editor.chain().focus().toggleStrike().run(),
          );
      }
      if (options.includes("highlight")) {
        document
          .getElementById(`${id}-toggleHighlightButton`)
          .addEventListener("click", () => {
            const isHighlighted = editor.isActive("highlight");
            // when using toggleHighlight(), judge if is is already highlighted.
            editor
              .chain()
              .focus()
              .toggleHighlight({
                color: isHighlighted ? undefined : "#ffc078", // if is already highlighted，unset the highlight color
              })
              .run();
          });
      }

      if (options.includes("left_align")) {
        document
          .getElementById(`${id}-toggleLeftAlignButton`)
          .addEventListener("click", () => {
            editor.chain().focus().setTextAlign("left").run();
          });
      }
      if (options.includes("center_align")) {
        document
          .getElementById(`${id}-toggleCenterAlignButton`)
          .addEventListener("click", () => {
            editor.chain().focus().setTextAlign("center").run();
          });
      }
      if (options.includes("right_align")) {
        document
          .getElementById(`${id}-toggleRightAlignButton`)
          .addEventListener("click", () => {
            editor.chain().focus().setTextAlign("right").run();
          });
      }
      if (options.includes("justify")) {
        document
          .getElementById(`${id}-toggleJustifyAlignButton`)
          .addEventListener("click", () => {
            editor.chain().focus().setTextAlign("justify").run();
          });
      }
      if (options.includes("list")) {
        document
          .getElementById(`${id}-toggleListButton`)
          .addEventListener("click", () => {
            editor.chain().focus().toggleBulletList().run();
          });
      }
      if (options.includes("ordered_list")) {
        document
          .getElementById(`${id}-toggleOrderedListButton`)
          .addEventListener("click", () => {
            editor.chain().focus().toggleOrderedList().run();
          });
      }
      if (options.includes("hr")) {
        document
          .getElementById(`${id}-toggleHRButton`)
          .addEventListener("click", () => {
            editor.chain().focus().setHorizontalRule().run();
          });
      }
      if (options.includes("image")) {
        document
          .getElementById(`${id}-addImageButton`)
          .addEventListener("click", () => {
            const url = window.prompt("Ingrese la URL de la imagen:", "");
            if (url) {
              editor.chain().focus().setImage({ src: url }).run();
            }
          });
      }

      if (options.includes("size")) {
        const textSizeDropdown = FlowbiteInstances.getInstance(
          "Dropdown",
          "textSizeDropdown",
        );

        // Loop through all elements with the data-text-size attribute
        document.querySelectorAll("[data-text-size]").forEach((button) => {
          button.addEventListener("click", () => {
            const fontSize = button.getAttribute("data-text-size");

            // Apply the selected font size via pixels using the TipTap editor chain
            editor.chain().focus().setMark("textStyle", { fontSize }).run();

            // Hide the dropdown after selection
            textSizeDropdown.hide();
          });
        });
      }

      if (options.includes("color")) {
        const textColorDropdown = FlowbiteInstances.getInstance(
          "Dropdown",
          "textColorDropdown",
        );

        // Listen for color picker changes
        const colorPicker = document.getElementById(`${id}-color`);
        colorPicker.addEventListener("input", (event) => {
          const selectedColor = event.target.value;

          // Apply the selected color to the selected text
          editor.chain().focus().setColor(selectedColor).run();

          // Hide the dropdown after selection
          textColorDropdown.hide();
        });

        document.querySelectorAll("[data-hex-color]").forEach((button) => {
          button.addEventListener("click", () => {
            const selectedColor = button.getAttribute("data-hex-color");

            // Apply the selected color to the selected text
            editor.chain().focus().setColor(selectedColor).run();
          });
        });

        document
          .getElementById(`${id}-reset-color`)
          .addEventListener("click", () => {
            editor.commands.unsetColor();
          });
      }

      if (options.includes("font")) {
        const fontFamilyDropdown = FlowbiteInstances.getInstance(
          "Dropdown",
          "fontFamilyDropdown",
        );

        // Loop through all elements with the data-font-family attribute
        document.querySelectorAll("[data-font-family]").forEach((button) => {
          button.addEventListener("click", () => {
            const fontFamily = button.getAttribute("data-font-family");

            // Apply the selected font size via pixels using the TipTap editor chain
            editor.chain().focus().setFontFamily(fontFamily).run();

            // Hide the dropdown after selection
            fontFamilyDropdown.hide();
          });
        });
      }
    }
  }
}
