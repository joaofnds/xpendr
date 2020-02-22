defmodule Xpendr.Accounts.Encryption do
  alias Argon2

  def hash_password(raw_password), do: Argon2.hash_pwd_salt(raw_password)
  def check_password(raw, encrypted), do: Argon2.verify_pass(raw, encrypted)
end
