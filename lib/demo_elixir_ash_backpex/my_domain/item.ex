defmodule DemoElixirAshBackpex.MyDomain.Item do
  use Ash.Resource,
    otp_app: :demo_elixir_ash_backpex,
    domain: DemoElixirAshBackpex.MyDomain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo DemoElixirAshBackpex.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :note], update: [:name, :note]]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :note, :string do
      public? true
    end
  end
end
