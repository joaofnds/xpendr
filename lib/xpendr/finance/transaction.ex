defmodule Xpendr.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Xpendr.Finance.Wallet

  @types %{income: "income", expense: "expense"}

  def types, do: @types

  schema "transactions" do
    field :amount, :integer
    field :description, :string
    field :type, :string
    belongs_to :wallet, Wallet

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:wallet_id, :type, :amount, :description])
    |> validate_required([:wallet_id, :type, :amount])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, Map.values(@types))
  end
end
