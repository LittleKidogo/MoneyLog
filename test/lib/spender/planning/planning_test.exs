defmodule Spender.PlanningTest do
  use Spender.DataCase

  alias Spender.{
    Planning,
    Planning.LogSection,
    MoneyLogs.Budget
  }

  @num_sections 5
  describe "Planning Boundary" do

    test "add_sections should return an error if start_date and end_date are not set for a budget" do
      no_date_attrs = %{name: "Food Lovers", start_date: nil, end_date: nil}
      budget = insert(:budget, no_date_attrs)

     {:error, message} = Planning.add_sections(budget, @num_sections)

     assert message == "#{budget.name} needs a start date and an end date"
    end

    test "add_sections should return a budget preloaded with sections" do
      budget = insert(:budget)
      assert Repo.aggregate(LogSection, :count, :id) == 0
      {:ok, budget} = Planning.add_sections(budget, @num_sections)
      assert Repo.aggregate(LogSection, :count, :id) == @num_sections
      assert Enum.count(budget.logsections) == @num_sections
    end

    test "get_sections should return an error if the budget has no sections" do
      budget = insert(:budget)
      assert Repo.aggregate(Budget, :count, :id) == 1
      assert Repo.aggregate(LogSection, :count, :id) == 0
      assert {:error, "#{budget.name} doesn't have any sections"} == Planning.get_sections(budget)
    end

    test "get_sections should return sections from a MoneyLog" do
      budget = insert(:budget)
      insert_list(@num_sections, :log_section, budget: budget)
      assert Repo.aggregate(Budget, :count, :id) == 1
      assert Repo.aggregate(LogSection, :count, :id) == @num_sections
      {:ok, sections} = Planning.get_sections(budget)
      assert Enum.count(sections) == @num_sections
    end
  end
end