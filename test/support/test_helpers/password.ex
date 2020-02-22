defmodule Xpendr.TestHelpers.Password do
  alias Xpendr.Accounts.Credential

  def valid_password(%Credential{} = credential, candidate_raw_password) do
    {:ok, ^credential} =
      Argon2.check_pass(
        credential,
        candidate_raw_password,
        hash_key: :password
      )
  end
end
