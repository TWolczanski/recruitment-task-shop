defmodule RecruitmentTaskOrders.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:net_total, :decimal)
      add(:tax, :decimal)
      add(:total, :decimal)
    end

    create(constraint("orders", :net_total_must_be_positive, check: "net_total > 0"))
    create(constraint("orders", :total_must_be_positive, check: "total > 0"))
  end
end
