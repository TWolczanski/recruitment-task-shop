import Config

config :recruitment_task_shop, RecruitmentTaskShop.Repo,
  database: "recruitment_task_shop_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
