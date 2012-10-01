class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
	  t.string :default_language
      t.string :site_title
      t.text :welcome_text

      t.timestamps
    end
  end
end
