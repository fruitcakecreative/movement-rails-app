class CreateEventAttendees < ActiveRecord::Migration[7.2]
  def change
    create_table :event_attendees do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
