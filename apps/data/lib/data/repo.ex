defmodule Data.Repo do
  use Ecto.Repo,
    otp_app: :data,
    adapter: Ecto.Adapters.Postgres

    use Scrivener, page_size: 5

end
