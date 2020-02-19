defmodule Xpendr.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  import Xpendr.Accounts.Auth
  alias Xpendr.Accounts.{User}

  schema "credentials" do
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:user_id, :password])
    |> validate_required([:user_id, :password])
    |> put_password_hash()
  end
end
