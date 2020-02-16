defmodule Xpendr.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  use Pow.Ecto.Schema

  alias Xpendr.Accounts.User

  schema "credentials" do
    pow_user_fields()
    belongs_to :user, User

    timestamps()
  end

  def changeset(changeset, attrs) do
    changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
