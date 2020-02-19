defmodule Xpendr.Finance do
  import Ecto.Query

  alias Xpendr.Repo
  alias Xpendr.Finance.Wallet

  def user_wallets_query(user_id) do
    where(Wallet, user_id: ^user_id)
  end

  def wallet_transactions(wallet_id) do
    where(Transaction, wallet_id: ^wallet_id)
  end

  def user_wallets(user_id) do
    user_wallets_query(user_id)
    |> Repo.all()
    |> Repo.preload([:user, :transactions])
  end

  def get_wallet!(user_id, wallet_id) do
    Wallet
    |> Ecto.Query.where(user_id: ^user_id, id: ^wallet_id)
    |> Repo.one!()
    |> Repo.preload([:user, :transactions])
  end

  def create_wallet(attrs \\ %{}) do
    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  def inc_wallet_balance(wallet_id, amount) when amount > 0 do
    {1, [%Wallet{}]} =
      from(w in Wallet, where: w.id == ^wallet_id, select: [:balance])
      |> Repo.update_all(inc: [balance: amount])
  end

  def dec_wallet_balance(wallet_id, amount) when amount > 0 do
    {1, [%Wallet{}]} =
      from(w in Wallet, where: w.id == ^wallet_id, select: [:balance])
      |> Repo.update_all(inc: [balance: -amount])
  end

  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  def change_wallet(%Wallet{} = wallet) do
    Wallet.changeset(wallet, %{})
  end

  alias Xpendr.Finance.Transaction

  def list_transactions(user_id) do
    from(w in Wallet,
      join: t in Transaction,
      on: [wallet_id: w.id],
      where: w.user_id == ^user_id,
      select: t
    )
    |> Repo.all()
    |> Repo.preload(wallet: :user)
  end

  def get_transaction!(id) do
    Transaction
    |> Repo.get!(id)
    |> Repo.preload(wallet: :user)
  end

  def create_transaction(_user_id, attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Transaction{type: type, amount: amount, wallet_id: wallet_id} = transaction} ->
        case type do
          "income" ->
            inc_wallet_balance(wallet_id, amount)

          "expense" ->
            dec_wallet_balance(wallet_id, amount)
        end

        {:ok, transaction}

      _ ->
        nil
    end
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def delete_transaction(%Transaction{} = transaction) do
    result = Repo.delete(transaction)

    case result do
      {:ok, %Transaction{type: type, amount: amount, wallet_id: wallet_id}} ->
        case type do
          "income" ->
            dec_wallet_balance(wallet_id, amount)

          "expense" ->
            inc_wallet_balance(wallet_id, amount)
        end

      {:error} ->
        nil
    end

    result
  end

  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
