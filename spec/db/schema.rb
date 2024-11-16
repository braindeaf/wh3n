ActiveRecord::Schema.define(:version => 0) do

create_table :events, :force => true do |t|
    t.column :starts_at, :datetime
    t.column :ends_at, :datetime
  end
end