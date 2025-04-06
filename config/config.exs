import Config

config :recruitment_task_shop, RecruitmentTaskShop.Repo,
  database: "recruitment_task_shop",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :recruitment_task_shop,
  ecto_repos: [RecruitmentTaskShop.Repo]

import_config "#{config_env()}.exs"
