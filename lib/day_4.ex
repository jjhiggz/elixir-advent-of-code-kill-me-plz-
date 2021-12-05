defmodule Day4Solutions do
  @type board_tally :: %{
          columns: [integer],
          rows: [integer],
          index: integer
        }

  def initial_tally do
    %{
      :rows => [0, 0, 0, 0, 0],
      :columns => [0, 0, 0, 0, 0]
    }
  end

  # @spec calculate_next_board_tally([integer], number, board_tally, pulled_number ) :: board_tally()
  def calculate_next_board_tally_from_row(
        current_row,
        row_index,
        current_board_tally,
        pulled_number
      ) do
    current_row
    |> Enum.with_index()
    |> Enum.reduce(current_board_tally, fn {board_number, index}, acc ->
      cond do
        board_number == pulled_number ->
          {:ok, existing_column_value} = Enum.fetch(acc.columns, index)
          {:ok, existing_row_value} = Enum.fetch(acc.rows, row_index)
          %{
            :columns => HelperMethods.replace_at(acc.columns, index, existing_column_value + 1),
            :rows => HelperMethods.replace_at(acc.rows, row_index, existing_row_value + 1)
          }

        true ->
          acc
      end
    end)
  end

  # @spec calculate_next_board_tally(integer, board_tally, [[number]]) :: board_tally()
  def calculate_next_board_tally(pulled_number, current_board_tally, board) do
    board
    |> Enum.with_index()
    |> Enum.reduce(current_board_tally, fn {row, index}, accumulator ->
      calculate_next_board_tally_from_row(row, index, accumulator, pulled_number)
    end)
  end

  # @spec board_tally( board_tally) :: Boolean
  def is_board_complete(board_tally) do
    is_valid_column = board_tally.columns |> Enum.find(fn count -> count == 5 end) && true
    is_valid_row = board_tally.rows |> Enum.find(fn count -> count == 5 end) && true
    !!(is_valid_row || is_valid_column)
  end

  def get_game_complete_data(board, pulled_numbers) do
    get_game_complete_data(board, initial_tally(), pulled_numbers, 0, pulled_numbers)
  end

  def get_game_complete_data(board, board_tally, numbers_left, count, all_numbers_to_pull) do
    invalid_board? = numbers_left |> Enum.count() < 1

    cond do
      invalid_board? ->
        %{
          :count => 99999999999999999999999999,
          :unmarked_sum => -1,
          :last_number => -1
        }

      true ->
        [next_number | rest_numbers] = numbers_left

        next_board_tally = calculate_next_board_tally(next_number, board_tally, board)
        complete? = is_board_complete(board_tally)

        {:ok, last_number_called} = Enum.fetch(all_numbers_to_pull, count - 1)

        cond do
          complete? ->
            %{
              :count => count,
              :unmarked_sum => get_unmarked_sum(board, all_numbers_to_pull, count),
              :last_number => last_number_called
            }

          true ->
            get_game_complete_data(
              board,
              next_board_tally,
              rest_numbers,
              count + 1,
              all_numbers_to_pull
            )
        end
    end
  end

  def is_in(list, value) do
    list
    |> Enum.find(fn list_el -> list_el == value end)
  end

  def sum(list) do
    list
    |> Enum.reduce(fn el, acc -> el + acc end)
  end

  def get_unmarked_sum(board, all_numbers, count) do
    selected_numbers = all_numbers |> Enum.take(count)

    board
    |> List.flatten()
    |> Enum.filter(fn board_number -> !is_in(selected_numbers, board_number) end)
    |> sum
  end

  def get_data_for_fastest_win(boards, pulled_numbers) do
    boards
    |> Enum.map(fn board -> get_game_complete_data(board, pulled_numbers) end)
    |> Enum.max_by(fn data -> data.count end)
  end
end
