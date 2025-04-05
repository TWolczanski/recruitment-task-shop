defmodule RecruitmentTaskShop.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias RecruitmentTaskShop.OrderItem

  schema "orders" do
    field(:net_total, :decimal)
    field(:tax, :decimal)
    field(:total, :decimal)
    has_many(:items, OrderItem)
  end

  def changeset(order, params \\ %{}) do
    order
    |> cast(params, [:net_total, :tax, :total])
    |> validate_number(:net_total, greater_than: 0)
    |> validate_number(:total, greater_than: 0)
  end
end
