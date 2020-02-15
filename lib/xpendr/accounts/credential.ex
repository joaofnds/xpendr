defmodule Xpendr.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Xpendr.Accounts.User

  alias Argon2

  schema "credentials" do
    field :password, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:user_id, :password])
    |> validate_required([:user_id, :password])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
