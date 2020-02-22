defmodule Xpendr.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Xpendr.Accounts.{User, Auth}

  schema "credentials" do
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:user_id, :password])
    |> validate_required([:user_id, :password])
    |> Auth.put_password_hash()
  end
end
