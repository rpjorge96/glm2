class AddImgDescToControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :img1_desc, :string
    add_column :control_unit_sub_types, :img2_desc, :string
    add_column :control_unit_sub_types, :img3_desc, :string
  end
end
