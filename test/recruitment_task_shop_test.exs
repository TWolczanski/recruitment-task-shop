defmodule RecruitmentTaskShopTest do
  use RecruitmentTaskShop.RepoCase
  doctest RecruitmentTaskShop
  alias RecruitmentTaskShop.Orders
  alias RecruitmentTaskShop.Orders.OrderItem

  test "fills fields of an order and its items" do
    {:ok, order} =
      Orders.create_order(%{
        items: [
          %{net_price: Decimal.new(1), quantity: 2},
          %{net_price: Decimal.new(2), quantity: 4}
        ]
      })

    order = Orders.fill_order_fields!(order, 25)

    expected_items = [
      %OrderItem{
        net_price: Decimal.new(1),
        quantity: 2,
        net_total: Decimal.new(2),
        total: Decimal.new("2.50")
      },
      %OrderItem{
        net_price: Decimal.new(2),
        quantity: 4,
        net_total: Decimal.new(8),
        total: Decimal.new(10)
      }
    ]

    assert_order_items(order.items, expected_items)
    assert Decimal.equal?(order.net_total, 10)
    assert Decimal.equal?(order.total, "12.5")
    assert Decimal.equal?(order.tax, "2.5")
  end

  test "fills fields of an order and its items when tax is 0%" do
    {:ok, order} =
      Orders.create_order(%{
        items: [
          %{net_price: Decimal.new(1), quantity: 2},
          %{net_price: Decimal.new(2), quantity: 4}
        ]
      })

    order = Orders.fill_order_fields!(order, 0)

    expected_items = [
      %OrderItem{
        net_price: Decimal.new(1),
        quantity: 2,
        net_total: Decimal.new(2),
        total: Decimal.new(2)
      },
      %OrderItem{
        net_price: Decimal.new(2),
        quantity: 4,
        net_total: Decimal.new(8),
        total: Decimal.new(8)
      }
    ]

    assert_order_items(order.items, expected_items)
    assert Decimal.equal?(order.net_total, 10)
    assert Decimal.equal?(order.total, 10)
    assert Decimal.equal?(order.tax, 0)
  end

  test "fills fields of an order and its single item" do
    {:ok, order} =
      Orders.create_order(%{
        items: [
          %{net_price: Decimal.new(2), quantity: 4}
        ]
      })

    order = Orders.fill_order_fields!(order, "12.5")

    expected_items = [
      %OrderItem{
        net_price: Decimal.new(2),
        quantity: 4,
        net_total: Decimal.new(8),
        total: Decimal.new(9)
      }
    ]

    assert_order_items(order.items, expected_items)
    assert Decimal.equal?(order.net_total, 8)
    assert Decimal.equal?(order.total, 9)
    assert Decimal.equal?(order.tax, 1)
  end

  test "fills fields of an order and its single item, overriding existing values" do
    {:ok, order} =
      Orders.create_order(%{
        tax: Decimal.new(1000),
        items: [
          %{net_price: Decimal.new(2), quantity: 4, net_total: Decimal.new(100)}
        ]
      })

    order = Orders.fill_order_fields!(order, "12.5")

    expected_items = [
      %OrderItem{
        net_price: Decimal.new(2),
        quantity: 4,
        net_total: Decimal.new(8),
        total: Decimal.new(9)
      }
    ]

    assert_order_items(order.items, expected_items)
    assert Decimal.equal?(order.net_total, 8)
    assert Decimal.equal?(order.total, 9)
    assert Decimal.equal?(order.tax, 1)
  end

  test "fills fields of an order with 0 if there are no items" do
    {:ok, order} =
      Orders.create_order(%{
        net_total: Decimal.new(10),
        total: Decimal.new(15),
        tax: Decimal.new(5)
      })

    order = Orders.fill_order_fields!(order, 50)

    assert length(order.items) == 0
    assert Decimal.equal?(order.net_total, 0)
    assert Decimal.equal?(order.total, 0)
    assert Decimal.equal?(order.tax, 0)
  end

  defp maps_with_decimals_equal?(map1, map2) do
    keys1 = Map.keys(map1)
    keys2 = Map.keys(map2)

    keys1 == keys2 and
      Enum.all?(keys1, fn key ->
        val1 = Map.get(map1, key)
        val2 = Map.get(map2, key)

        case {val1, val2} do
          {%Decimal{}, %Decimal{}} ->
            Decimal.equal?(val1, val2)

          _ ->
            val1 === val2
        end
      end)
  end

  def assert_order_item_in(item, items) do
    fields = [:net_price, :quantity, :net_total, :total]
    item = item |> Map.take(fields)
    items = items |> Enum.map(&Map.take(&1, fields))
    assert Enum.any?(items, &maps_with_decimals_equal?(&1, item))
  end

  def assert_order_items(actual_items, expected_items) do
    assert length(actual_items) == length(expected_items)
    Enum.each(expected_items, &assert_order_item_in(&1, actual_items))
  end
end
