defmodule Xpendr.Accounts do
  import Ecto.Query, warn: false
  alias Xpendr.Repo

  alias Xpendr.Accounts.{User, Encryption}

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

  def create_user_with_credential(attrs \\ %{}) do
    Repo.transaction(fn ->
      case create_user(attrs) do
        {:ok, user} ->
          attrs
          |> Map.put("user_id", user.id)
          |> create_credential()
          |> case do
            {:ok, credential} ->
              {:ok, credential}

            {:error, changeset} ->
              Repo.rollback(changeset)
          end

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

  def authenticate_user_with_password(username, plain_text_password) do
    User
    |> where(username: ^username)
    |> Repo.one()
    |> Repo.preload(:credential)
    |> case do
      nil ->
        Argon2.no_user_verify()
        {:error, :bad_credentials}

      user ->
        if Encryption.check_password(plain_text_password, user.credential.password) do
          {:ok, user}
        else
          {:error, :bad_credentials}
        end
    end
  end

  alias Xpendr.Accounts.Credential

  def list_credentials do
    Credential
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def get_credential!(id) do
    Credential
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end
end
