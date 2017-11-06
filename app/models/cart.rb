class Cart < ActiveRecord::Base
    has_many :line_items
    has_many :items, through: :line_items
    belongs_to :user

    def total
      sum = 0
      self.line_items.each do |i|
          sum += (i.item.price * i.quantity)
        end
      sum
    end

    def add_item(item_id)
      line_item = self.line_items.find_by(item_id: item_id)
      if line_item
        line_item.quantity += 1
        line_item.save
        line_item
      else
        self.line_items.build(item_id: item_id)
      end
    end

    def checkout
    self.update(status: "submitted")
    self.line_items.each do |line_item|
      line_item.item.update(inventory: line_item.item.inventory - line_item.quantity)
    end
  end

end
