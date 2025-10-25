defmodule MyApp.MyDomain.Item do
  use Ash.Resource, otp_app: :my_app, domain: MyApp.MyDomain, data_layer: AshPostgres.DataLayer

  postgres do
    table "items"
    repo MyApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: [:name, :note], update: [:name, :note]]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
    end

    attribute :note, :string do
      public? true
    end
  end
end
