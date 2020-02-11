defmodule Xpendr.Repo do
  use Ecto.Repo,
    otp_app: :xpendr,
    adapter: Ecto.Adapters.Postgres
end
