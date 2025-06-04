class AddPrecioToControlUnitSubTypeProjects < ActiveRecord::Migration[7.1]
  def change
    add_monetize :control_unit_sub_type_projects,
      :precio,
      amount: {null: true, default: nil},
      currency: {null: true, default: nil}

    add_monetize :control_unit_sub_type_projects,
      :precio_dollar,
      amount: {null: true, default: nil},
      currency: {null: false, default: "USD"}
  end
end
