defmodule MyApp.MyDomain do
  use Ash.Domain,
    otp_app: :my_app

  resources do
    resource MyApp.MyDomain.Item
  end
end
