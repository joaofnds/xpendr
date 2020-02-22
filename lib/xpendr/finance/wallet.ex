defmodule Xpendr.Finance.Wallet do
  use Ecto.Schema
  import Ecto.Changeset
  alias Xpendr.Accounts.User
  alias Xpendr.Finance.Transaction

  schema "wallets" do
    field :balance, :integer
    field :description, :string
    field :name, :string
    belongs_to :user, User
    has_many :transactions, Transaction

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:user_id, :name, :balance, :description])
    |> validate_required([:user_id, :name])
  end
end
