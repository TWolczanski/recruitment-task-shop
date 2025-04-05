defmodule RecruitmentTaskShop.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias RecruitmentTaskShop.Order

  schema "order_items" do
    field(:net_price, :decimal)
    field(:quantity, :integer)
    field(:net_total, :decimal)
    field(:total, :decimal)
    belongs_to(:order, Order)
  end

  def changeset(order_item, params \\ %{}) do
    order_item
    |> cast(params, [:net_price, :quantity, :net_total, :total, :order_id])
    |> validate_required([:net_price, :quantity, :order_id])
    |> validate_number(:net_price, greater_than: 0)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:net_total, greater_than: 0)
    |> validate_number(:total, greater_than: 0)
  end
end
