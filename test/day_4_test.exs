defmodule Day4Tests do
  use ExUnit.Case
  doctest Day4Solutions

  # calculate next board
  test "calculate next board calculates the first 1 well" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_number = 14

    current_board_tally = %{
      :columns => [0, 0, 0, 0, 0],
      :rows => [0, 0, 0, 0, 0]
    }

    test_case =
      Day4Solutions.calculate_next_board_tally(
        pulled_number,
        current_board_tally,
        board
      )

    assert test_case == %{
             :columns => [1, 0, 0, 0, 0],
             :rows => [1, 0, 0, 0, 0]
           }
  end

  test "next step works" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_number = 16

    current_board_tally = %{
      :columns => [1, 0, 0, 0, 0],
      :rows => [1, 0, 0, 0, 0]
    }

    test_case =
      Day4Solutions.calculate_next_board_tally(
        pulled_number,
        current_board_tally,
        board
      )

    assert test_case == %{
             :columns => [1, 1, 0, 0, 0],
             :rows => [1, 1, 0, 0, 0]
           }
  end

  test "edge case works" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_number = 7

    current_board_tally = %{
      :columns => [1, 1, 0, 0, 0],
      :rows => [1, 1, 0, 0, 0]
    }

    test_case =
      Day4Solutions.calculate_next_board_tally(
        pulled_number,
        current_board_tally,
        board
      )

    assert test_case == %{
             :columns => [1, 1, 0, 0, 1],
             :rows => [1, 1, 0, 0, 1]
           }
  end

  test "Will increment on existing row" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_number = 21

    current_board_tally = %{
      :columns => [1, 2, 0, 0, 1],
      :rows => [1, 1, 0, 0, 1]
    }

    test_case =
      Day4Solutions.calculate_next_board_tally(
        pulled_number,
        current_board_tally,
        board
      )

    assert test_case == %{
             :columns => [1, 3, 0, 0, 1],
             :rows => [2, 1, 0, 0, 1]
           }
  end

  test "is-board-complete" do
    current_board_tally = %{
      :columns => [1, 2, 0, 0, 1],
      :rows => [1, 1, 0, 0, 1]
    }

    answer1 = Day4Solutions.is_board_complete(current_board_tally)
    assert answer1 == false

    current_board_tally = %{
      :columns => [1, 5, 0, 0, 1],
      :rows => [1, 1, 0, 0, 1]
    }

    answer2 = Day4Solutions.is_board_complete(current_board_tally)
    assert answer2 == true

  end

  test "is board complete edge case" do
    current_board_tally = %{
      :columns => [1, 2, 1, 1, 1],
      :rows => [5, 0, 1, 0, 0]
    }

    answer3 = Day4Solutions.is_board_complete(current_board_tally)
    assert answer3 == true
  end

  test "getBoardCompleteCount" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_numbers = [14, 21, 17, 24, 4, 8]

    test_case = Day4Solutions.get_game_complete_data(board, pulled_numbers)

    assert test_case.count == 5
  end

  test "getBoardCompleteCount on test case" do
    board = [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]

    pulled_numbers = TestData.Day4.exampleDraws()
    test_case = Day4Solutions.get_game_complete_data(board, pulled_numbers)
    assert test_case.unmarked_sum == 188
  end

  test "getUnmarkedSum no count" do
    board = [
      [1, 2],
      [3, 4]
    ]

    pulled = [ 1, 2 ]

    test_case = Day4Solutions.get_unmarked_sum( board,pulled, 2 )
    assert test_case == 7
  end

  test "getUnmarkedSum count" do
    board = [
      [1, 2],
      [3, 4]
    ]

    pulled = [ 1, 2, 3 ]

    test_case = Day4Solutions.get_unmarked_sum( board,pulled, 2 )
    assert test_case == 7
  end

  test "check fake example" do
    boards = TestData.Day4.exampleBoards()
    pulledNumbers = [ 14, 21, 17, 24, 4, 5, 6 ]

    test_case = Day4Solutions.get_data_for_fastest_win(boards, pulledNumbers)

    # assert test_case.unmarked_sum == 188
    # assert test_case.count == 12
    assert test_case == 5
  end

  test "check example" do
    boards = TestData.Day4.exampleBoards()
    pulledNumbers = TestData.Day4.exampleDraws()

    test_case = Day4Solutions.get_data_for_fastest_win(boards, pulledNumbers)

    assert test_case.unmarked_sum == 188
    assert test_case.count == 12
    assert test_case.last_number == 12
  end

  @tag :wip
  test "get real answer" do
    boards = Day4Input.boards
    pulledNumbers = Day4Input.pulls

    test_case = Day4Solutions.get_data_for_fastest_win(boards, pulledNumbers)

    IO.inspect(915 * 25)
    assert test_case== 915
    assert test_case.count == 25
    assert test_case == 66

  end
end
