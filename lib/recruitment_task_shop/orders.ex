defmodule RecruitmentTaskShop.Orders do
  alias RecruitmentTaskShop.Repo
  alias RecruitmentTaskShop.Orders.Order
  import Ecto.Changeset

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> put_assoc(:items, attrs[:items] || [])
    |> Repo.insert()
  end

  defp calc_missing_items_fields(order_items, tax) do
    for item <- order_items do
      net_total = Decimal.mult(item.net_price, item.quantity)
      total = Decimal.div(tax, 100) |> Decimal.mult(net_total) |> Decimal.add(net_total)
      %{net_total: net_total, total: total}
    end
  end

  defp calc_missing_order_fields(order_items) do
    net_total = order_items |> Enum.reduce(Decimal.new(0), &Decimal.add(&1.net_total, &2))
    total = order_items |> Enum.reduce(Decimal.new(0), &Decimal.add(&1.total, &2))
    tax = Decimal.sub(total, net_total)
    %{net_total: net_total, total: total, tax: tax}
  end

  @doc """
  Fills `net_total` and `total` of order's items, and `net_total`, `total`, `tax` of the order itself
  based on `net_price` and `quantity` of the items.
  The changes will be persisted into the database.
  """
  @spec fill_order_fields!(%Order{}, Decimal.decimal()) :: %Order{}
  def fill_order_fields!(%Order{} = order, tax) do
    order = order |> Repo.preload(:items)

    order_items_changesets =
      order.items
      |> calc_missing_items_fields(tax)
      |> Stream.zip(order.items)
      |> Enum.map(fn {changes, item} -> change(item, changes) end)

    order_changes =
      order_items_changesets |> Enum.map(&apply_changes/1) |> calc_missing_order_fields()

    order
    |> change(order_changes)
    |> put_assoc(:items, order_items_changesets)
    |> Repo.update!()
  end
end
