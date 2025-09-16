defmodule DemoElixirAshBackpex.MyDomain do
  use Ash.Domain,
    otp_app: :demo_elixir_ash_backpex

  resources do
    resource DemoElixirAshBackpex.MyDomain.Item
  end
end
