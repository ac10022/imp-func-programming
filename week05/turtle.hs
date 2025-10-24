-- the functional implementation should help to appreciate the compositional
-- nature of Haskell programming, compared to the paradigm used in C

module Turtle where

-- explicitly printing the state requires monads, which you will learn about later
-- today we'll be lazy and just give the turtle a Show instance

data Command = RotateClockwise | MoveForward | Noop

data Orientation = North | East | South | West deriving (Show, Eq, Enum)

type Point = (Int, Int)

data Turtle = Turtle
  { position :: Point
  , orientation :: Orientation
  } deriving Show

-- NB this implementation must be pure
runCommand :: Turtle -> Command -> Turtle
runCommand (Turtle p o) RotateClockwise
    | o == West = Turtle { position = p, orientation = North }
    | otherwise = Turtle { position = p, orientation = succ o }
runCommand (Turtle (x,y) North) MoveForward = Turtle { position = (x, y+1), orientation = North }
runCommand (Turtle (x,y) South) MoveForward = Turtle { position = (x, y-1), orientation = South }
runCommand (Turtle (x,y) East) MoveForward = Turtle { position = (x+1, y), orientation = East }
runCommand (Turtle (x,y) West) MoveForward = Turtle { position = (x-1, y), orientation = West }
runCommand t Noop = t 

-- the program-runner function could make use of a foldl just to make a point
type Program = [Command]

runProgram :: Program -> Turtle -> Turtle
runProgram p t = foldl runCommand t p

-- >>> runProgram [MoveForward, RotateClockwise, MoveForward, MoveForward] (Turtle (0,0) North)
-- Turtle {position = (2,1), orientation = East}
