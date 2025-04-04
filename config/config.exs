import Config

config :recruitment_task_orders, RecruitmentTaskOrders.Repo,
  database: "recruitment_task_orders",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :recruitment_task_orders,
  ecto_repos: [RecruitmentTaskOrders.Repo]
