class AddNoteIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :notes, :created_at, order: { created_at: :desc }
    add_index :notes,
      "to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, ''))",
      using: :gin,
      name: "index_notes_on_full_text_search"
  end
end
