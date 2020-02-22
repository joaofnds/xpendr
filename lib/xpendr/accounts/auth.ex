defmodule Xpendr.Accounts.Auth do
  import Ecto.Changeset
  alias Xpendr.Accounts.Encryption

  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Encryption.hash_password(password))
  end

  def put_password_hash(changeset), do: changeset
end
