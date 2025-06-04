import globals from "globals";
import pluginJs from "@eslint/js";
import eslintConfigPrettier from "eslint-config-prettier";

export default [
  { languageOptions: { globals: globals.browser } },
  {
    ignores: [
      "app/assets/javascripts/coloris.min.js",
      "config/tailwind.config.js",
      "public/assets/**/*.js",
    ],
  },
  pluginJs.configs.recommended,
  eslintConfigPrettier,
  { rules: { "no-undef": "off" } },
];
