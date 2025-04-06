defmodule RecruitmentTaskShop.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:net_total, :decimal)
      add(:tax, :decimal)
      add(:total, :decimal)
    end
  end
end
