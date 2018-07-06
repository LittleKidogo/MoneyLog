defmodule Spender.Planning.LogSection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Spender.{
    Planning.LogSection,
    MoneyLogs.Budget,
    WishList.Item
  }

  @type t :: %__MODULE__{}



  schema "logsections" do
    field :duration, :float
    field :name, :string
    field :section_position, :integer
    belongs_to :budget, Budget
    many_to_many :wishlist_items, Item, join_through: "logsections_items", join_keys: [log_section_id: :id, wishlist_item_id: :id], on_replace: :delete


    timestamps()
  end

  @doc false
  def changeset(%LogSection{} = log_section, attrs) do
    log_section
    |> cast(attrs, [:name, :duration, :section_position])
    |> validate_required([:name, :duration, :section_position])
  end

  @doc """
  This function takes a MoneyLog and a map of attributes the proceeds to use these
  attributes to create a LogSection Struct
  """
  @spec create_changeset(Budget.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(%Budget{} = budget, attrs) do
    %LogSection{}
    |> changeset(attrs)
    |> put_assoc(:budget, budget)
  end

  @doc """
  This function takes a WishListItem and a LogSection assumes  are Associated
  and proceeds to remove the item from the list of associated WishListItems
  """
  @spec remove_item(LogSection.t(), Item.t()) :: Ecto.Changeset.t()
  def remove_item(%LogSection{wishlist_items: items} = logsection, %Item{} = item) do

    logsection
    |> change(%{})
    |> put_assoc(:wishlist_items, items -- [item])
  end
end
