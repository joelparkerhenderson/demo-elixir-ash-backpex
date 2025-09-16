defmodule DemoElixirAshBackpex.Accounts do
  use Ash.Domain,
    otp_app: :demo_elixir_ash_backpex

  resources do
    resource DemoElixirAshBackpex.Accounts.Token
    resource DemoElixirAshBackpex.Accounts.User
  end
end
