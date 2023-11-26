#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'

# Load the script that contains the function to be tested
#load colors.sh

# Describe block for testing the change_color function
@test "change_color changes the text color" {

  # Load the function that is to be tested.
  source src/logging/cli_logging.sh

  # Test setting text color to 1 (red)
  result="$(change_color 1)"
  # Assert that the ANSI escape sequence for red (setaf 1) is output
  [ "$result" == "$(tput setaf 1)" ]

  # Test setting text color to 2 (green)
  result="$(change_color 2)"
  # Assert that the ANSI escape sequence for green (setaf 2) is output
  [ "$result" == "$(tput setaf 2)" ]

  # Add more tests as needed for other colors or edge cases
}
