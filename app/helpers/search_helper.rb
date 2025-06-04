module SearchHelper
  def search_field_with_icon(f, field_name, placeholder: "Buscar...", **options)
    content_tag(:div, class: "relative w-full") do
      icon_svg = content_tag(:div, class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
        "<svg class='w-4 h-4 text-gray-500 dark:text-gray-400' aria-hidden='true' fill='none' viewBox='0 0 20 20' xmlns='http://www.w3.org/2000/svg'><path stroke='currentColor' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z'/></svg>".html_safe
      end

      search_field = f.search_field(field_name,
        {
          autofocus: true,
          autocomplete: "off",
          class: "block w-full p-4 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
          placeholder:,
          onfocus: "this.setSelectionRange(this.value.length, this.value.length);",
          **options
        })

      icon_svg + search_field
    end
  end
end
