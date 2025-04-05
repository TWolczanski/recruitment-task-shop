defmodule RecruitmentTaskShop.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add(:net_price, :decimal)
      add(:quantity, :integer)
      add(:net_total, :decimal)
      add(:total, :decimal)
      add(:order_id, references(:orders, on_delete: :delete_all), null: false)
    end

    create(index(:order_items, [:order_id]))

    create(constraint("order_items", :net_price_must_be_positive, check: "net_price > 0"))
    create(constraint("order_items", :quantity_must_be_positive, check: "quantity > 0"))
    create(constraint("order_items", :net_total_must_be_positive, check: "net_total > 0"))
    create(constraint("order_items", :total_must_be_positive, check: "total > 0"))
  end
end
