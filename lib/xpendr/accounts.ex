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

  def authenticate_user_with_password(username, plain_text_password) do
    query = from u in User, where: u.username == ^username

    case Repo.one(query) |> Repo.preload(:credential) do
      nil ->
        Argon2.no_user_verify()
        {:error, :bad_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.credential.password) do
          {:ok, user}
        else
          {:error, :bad_credentials}
        end
    end
  end

  alias Xpendr.Accounts.Credential

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credential{}, ...]

  """
  def list_credentials do
    Credential
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single credential.

  Raises `Ecto.NoResultsError` if the Credential does not exist.

  ## Examples

      iex> get_credential!(123)
      %Credential{}

      iex> get_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credential!(id) do
    Credential
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a credential.

  ## Examples

      iex> create_credential(%{field: value})
      {:ok, %Credential{}}

      iex> create_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credential.

  ## Examples

      iex> update_credential(credential, %{field: new_value})
      {:ok, %Credential{}}

      iex> update_credential(credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a credential.

  ## Examples

      iex> delete_credential(credential)
      {:ok, %Credential{}}

      iex> delete_credential(credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """
  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end
end
