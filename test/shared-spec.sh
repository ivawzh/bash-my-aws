#!/usr/bin/env bash
source $(dirname $0)/bash-spec.sh
source $(dirname $0)/../shared-functions

describe "Read Inputs" "$(

  context "Without arguments" "$(
    input=$(__bma_read_inputs)

    it "is empty" "$(
      expect "${#input}" to_be "0"
    )"
  )"

  context "With argument" "$(
    input=$(__bma_read_inputs arg1)

    it "has one argument" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With arguments" "$(
    input=$(__bma_read_inputs arg1 arg2)

    it "has two arguments" "$(
      expect "${input}" to_be "arg1 arg2"
    )"
  )"

  context "With stdin" "$(
    input=$(echo "arg1" | __bma_read_inputs)

    it "has single word of input" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With two words of stdin" "$(
    input=$(echo "arg1 arg2" | __bma_read_inputs)

    it "has two words of input" "$(
      expect "${input}" to_be "arg1"
    )"
  )"

  context "With two lines of stdin" "$(
    input=$(printf "arg1\narg2\n" | __bma_read_inputs)

    it "has two words of input" "$(
      expect "${input}" to_be "$(echo 'arg1 arg2')"
    )"
  )"

  context "With stdin and argument" "$(
    input=$(echo "blah" | __bma_read_inputs --switch=value)

    it "has two words of input" "$(
      expect "${input}" to_be "blah --switch=value"
    )"
  )"

  context "With two lines of stdin and argument" "$(
    input=$(printf "blah\nblah2\n" | __bma_read_inputs --switch=value)

    it "has two words of input" "$(
      expect "${input}" to_be "blah --switch=value blah2 --switch=value"
    )"
  )"
)"

describe "Switch STDIN" "$(
  context "without anything" "$(
    expect $(__bma_switch_stdin) to_be ""
    expect $(__bma_switch_stdin) to_be_true
  )"

  context "only switch" "$(
    expect $(__bma_switch_stdin --switch) to_be ""
    expect $(__bma_switch_stdin --switch) to_be_true
  )"

  context "only stdin" "$(
    expect $(echo "first" | __bma_switch_stdin) to_be ""
    expect $(echo "first" | __bma_switch_stdin; echo $?) to_be "1"
  )"

  context "both stdin and switch" "$(
    expect "$(echo "a" | __bma_switch_stdin -s)" to_be "-s a "
    expect "$(echo "a b" | __bma_switch_stdin -s)" to_be "-s a -s b "
  )"
)"