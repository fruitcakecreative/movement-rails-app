class RenameEventShorterTitleToEvenShorterTitleInEvents < ActiveRecord::Migration[7.2]
  def change
    rename_column :events, :event_shorter_title, :even_shorter_title
  end
end
