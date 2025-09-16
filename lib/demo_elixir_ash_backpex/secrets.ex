defmodule DemoElixirAshBackpex.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        DemoElixirAshBackpex.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:demo_elixir_ash_backpex, :token_signing_secret)
  end
end
