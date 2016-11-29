# Advent of Code

This is a repo that contains [PieSync's](http://www.piesync.com) solutions for [Advent of Code](http://adventofcode.com).

The goal is to keep this as simple as possible, that's why we use docker and wrapper scripts to handle I/O or other things like boilerplate for benchmarking.

## Structure

Each year has a directory for each day. You can add solution using `[yourname].[lang]`. You can use whatever language you like (go crazy) as long as there's a docker image (configured in `aoc`) and a runner script in `runners`.

Puzzle inputs are gathered in the `inputs` dir for each day. As inputs are generated per user, name the file `[yourname]`. This will make sure it will get used by default in your own solutions.

The solutions themselves don't need to deal with I/O or deciding which part of the solution to run. For example, in Haskell, we just need to provide an `a` and `b` function that takes a String (input) and outputs the solution. Take a look at the `2015/1` example for other languages.

## Running solutions

Running a solution is done by executing

```
./aoc 2015/1/challengee.hs run
```

This runs part A of the solution with the default input. Running Part B with a custom input could go like this:

```
cat input | ./aoc 2015/1/challengee.hs run b
```

Sometimes in can be useful to run an interactive session in the container to use tools like `ghci` or `irb`. You can do this by running `aocint`:

```
./aocint 2015/1/challengee.hs
```

will boot up a docker container with the solution and inputs mounted.

## Runners

You can create new runners by adding them to the `runners` directory. This directory maps on the subcommand you pass to `aoc`. Running `./aoc 2015/1/challengee.hs run` runs the `runner/run/hs/run` script in the container.
