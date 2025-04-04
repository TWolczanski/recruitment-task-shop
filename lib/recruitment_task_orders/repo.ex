defmodule RecruitmentTaskOrders.Repo do
  use Ecto.Repo,
    otp_app: :recruitment_task_orders,
    adapter: Ecto.Adapters.Postgres
end
