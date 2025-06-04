class RenameImg1DescToImg4DescInControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    rename_column :control_unit_sub_types, :img1_desc, :img4_desc
  end
end
