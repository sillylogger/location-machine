class RenameEventsToParties < ActiveRecord::Migration
  def change
    rename_table :events, :parties
  end
end
