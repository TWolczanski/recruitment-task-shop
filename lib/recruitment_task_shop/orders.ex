defmodule RecruitmentTaskShop.Orders do
  alias RecruitmentTaskShop.Repo
  alias RecruitmentTaskShop.Orders.Order
  alias RecruitmentTaskShop.Orders.OrderItem
  import Ecto.Changeset

  @doc """
  Fills `net_total` and `total` of order's items, and `net_total`, `total`, `tax` of the order itself.
  The order and its items will be inserted into the database if they haven't been persisted yet.
  Otherwise they will be updated.
  """
  @spec fill_missing_order_fields(%Order{}, Decimal.decimal()) ::
          {:ok, %Order{}} | {:error, Ecto.Changeset.t()}
  def fill_missing_order_fields(%Order{} = order, tax) do
    order = order |> Repo.preload(:items)

    order_items =
      for item <- order.items do
        net_total = Decimal.mult(item.net_price, item.quantity)
        total = Decimal.div(tax, 100) |> Decimal.mult(net_total) |> Decimal.add(net_total)
        item |> OrderItem.changeset(%{net_total: net_total, total: total})
      end

    net_total = order_items |> Enum.reduce(Decimal.new(0), &Decimal.add(&1.net_total, &2))
    total = order_items |> Enum.reduce(Decimal.new(0), &Decimal.add(&1.total, &2))

    order
    |> Order.changeset(%{net_total: net_total, total: total, tax: Decimal.sub(total, net_total)})
    |> put_assoc(:items, order_items)
    |> Repo.insert()
  end
end
