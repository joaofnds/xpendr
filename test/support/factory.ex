defmodule Xpendr.Factory do
  alias Xpendr.Repo

  alias Xpendr.Accounts.User

  def build(:user) do
    %User{name: "some name", username: "some username"}
  end

  def build(factory, attributes) do
    build(factory) |> struct(attributes)
  end

  def insert!(factory, attributes \\ []) do
    Repo.insert! build(factory, attributes)
  end
end