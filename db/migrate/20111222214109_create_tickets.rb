class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.boolean :ready

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
