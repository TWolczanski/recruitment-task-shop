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
  end
end
