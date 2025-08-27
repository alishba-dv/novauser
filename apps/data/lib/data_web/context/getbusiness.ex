defmodule Data.Context.GetBusiness do

  alias Data.Repo
  import Ecto.Query
  alias Data.Schema.Business


  def getbusiness() do

    case Repo.all(Business) do

      business -> {:ok,business}
      _-> {:error, "Error"}

    end

  end

end