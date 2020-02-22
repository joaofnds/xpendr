defmodule XpendrWeb.SessionManager.Guardian do
  use Guardian, otp_app: :xpendr

  alias Xpendr.Accounts

  def subject_for_token(%Accounts.User{id: id}, _claims), do: {:ok, id}
  def subject_for_token(_, _), do: {:error, "unknown resource type"}

  def resource_from_claims(%{"sub" => id}), do: {:ok, Accounts.get_user!(id)}
  def resource_from_claims(_claims), do: {:error, "unknown resource type"}
end
