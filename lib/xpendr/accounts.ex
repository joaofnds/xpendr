defmodule Xpendr.Accounts do
  import Ecto.Query, warn: false
  alias Xpendr.Repo

  alias Xpendr.Accounts.User

  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:wallets)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:wallets)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_credential(attrs \\ %{}) do
    case Pow.Plug.create_user(attrs["conn"], attrs) do
      {:ok, credentials, _} ->
        {:ok, credentials}

      {:error, changeset, _} ->
        Repo.rollback(changeset)
        {:error, changeset}
    end
  end

  def create_user_with_credential(attrs \\ %{}) do
    Repo.transaction(fn ->
      case create_user(attrs) do
        {:ok, user} ->
          create_credential(Map.put(attrs, "user_id", user.id))

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def wallets(%User{wallets: wallets}) do
    wallets
  end
end
