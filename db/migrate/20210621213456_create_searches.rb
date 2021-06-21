class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.boolean :rank_rising
      t.boolean :rank_falling
      t.boolean :weeks_on_list
    end
  end
end
