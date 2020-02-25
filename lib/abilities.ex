defmodule Xpendr.Abilities do
  alias Xpendr.Accounts.User
  alias Xpendr.Finance.{Wallet, Transaction}

  defimpl Canada.Can, for: User do
    def can?(nil, action, User) when action in [:new, :create], do: true
    def can?(%User{id: id}, _action, %User{id: id}), do: true

    def can?(%User{}, action, Wallet)
        when action in [:index, :new, :create],
        do: true

    def can?(%User{id: user_id}, _action, %Wallet{user_id: user_id}), do: true

    def can?(
          %User{id: user_id},
          _action,
          %Transaction{wallet: %{user_id: user_id}}
        ),
        do: true

    def can?(%User{}, action, Transaction)
        when action in [:index, :new, :create],
        do: true

    def can?(_, _, _), do: false
  end
end
