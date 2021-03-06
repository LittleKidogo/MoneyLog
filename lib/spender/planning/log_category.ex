defmodule Spender.Planning.LogCategory do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  This module holds the schema and changeset functions for the LogCategory
  """
  alias Spender.{
    MoneyLogs.Moneylog,
    Planning.LogCategory,
    Using.ExpenseLog
  }

  @type t :: %__MODULE__{}

  # binary key setup
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "logcategories" do
    field(:name, :string)
    belongs_to(:moneylog, Moneylog, foreign_key: :moneylog_id, type: :binary_id)
    has_many(:expenselogs, ExpenseLog)
  end

  @doc """
  This changeset function takes in a struct and map containing parameters
  It proceeds to match the parameters in the the map to the schema above
  """
  @spec changeset(LogCategory.t(), map()) :: Ecto.Changeset.t()
  def changeset(logcategory, attrs \\ %{}) do
    logcategory
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 40)
  end
  @doc """
  This changeset function takes in a budget struct and map containing parameters
  It proceeds to match the parameters in the the map to the schema above
  """
  @spec create_changeset(Moneylog.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(%Moneylog{} = moneylog, attrs) do
    %LogCategory{}
    |> LogCategory.changeset(attrs)
    |> put_assoc(:moneylog, moneylog)
  end
end
