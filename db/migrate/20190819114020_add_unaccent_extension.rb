class AddUnaccentExtension < ActiveRecord::Migration[5.2]
  def up
    execute "create extension unaccent"
    execute "create extension pg_trgm"
  end

  def down
    execute "drop extension unaccent"
    execute "drop extension pg_trgm"
  end
end
