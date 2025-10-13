module ADTs where

import Prelude hiding (Bool(..), Either(..), Maybe(..), length, fst, snd)
import qualified Data.Char
import Data.Char (digitToInt)

-- algebraic data types is the way to make data representations

-- constructors: to pattern match on
data Bool = True | False
    deriving Show

-- >>> :t True
-- True :: Bool

-- sum types: offer a choice of disjoint values

data Three = One | Two | Three -- constructor name can match the type name

one :: Three
one = One

two :: Three
two = Two

showThree :: Three -> String
showThree t = case t of 
    One -> "1"
    Two -> "2"
    Three -> "3"

eqThree :: Three -> Three -> Bool
eqThree One One = True
eqThree Two Two = True
eqThree Three Three = True
eqThree _ _ = False

-- >>> eqThree Three Two
-- False

data Coin = Heads | Tails

showCoin :: Coin -> String
showCoin c = case c of
    Heads -> "Heads"
    Tails -> "Tails"

-- product types: a generalisation of tuples

data Coord = Coord Char Int

-- >>> :t Coord
-- Coord :: Char -> Int -> Coord
-- constructor takes a char and int and returns a coord

treasure :: Coord
treasure = Coord 'A' 4

incCoordInt :: Coord -> Coord
incCoordInt (Coord l n) = Coord l (n+1)

-- we could also implement a type synonym
type Coord' = (Char, Int)

-- full ADTs

data RobotInstr
    = Dance
    | Move Int
    | Teleport Char Int

data RobotLang
    = Say String
    | Sum Int Int

-- recursive ADTs

data RobotSequence
    = Stop
    | AddInst RobotInstr RobotSequence

doNothing = Stop
danceThenStop = AddInst Dance Stop
danceThenDanceThenStop = AddInst Dance (AddInst Dance Stop)

-- monomorphic lists

-- data IntList = IntEmpty | IntCons Int IntList

-- polymorphism: a list of any type

-- 'a' represents 'some type'
-- data List a = Empty | Cons a (List a)

data Pair a b = Pair a b

data Either a b = Left a | Right b

exampleEitherL :: Either Int Char
exampleEitherL = Left 3

exampleEitherR :: Either Int Char
exampleEitherR = Right 'a'

data Maybe a = Just a | Nothing

exampleMaybeJ :: Maybe Int
exampleMaybeJ = Just 3

exampleMaybeN :: Maybe Int
exampleMaybeN = Nothing

-- polymorphic functions

-- this is a monomorphic function
-- lengthIntList :: IntList -> Int
-- lengthIntList IntEmpty = 0
-- lengthIntList (IntCons _ xs) = 1 + lengthIntList xs

-- length :: List a -> Int
-- length Empty = 0
-- length (Cons _ xs) = 1 + length xs

-- isEmpty :: List a -> Bool
-- isEmpty Empty = True
-- isEmpty _ = False

fst :: (a, b) -> a
fst (x, _) = x

snd :: (a, b) -> b
snd (_, y) = y

{-
BASIC PRODUCT TYPES

Pair Manipulation
Define a function swap :: (a, b) -> (b, a) that swaps the elements of a tuple.

Record Definition
Define a Point type with x and y coordinates and write a function distanceFromOrigin :: Point -> Float.

Combining Two Products
Create a function combinePoints :: (Point, Point) -> Point that adds corresponding coordinates.
-}

swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

type Point = (Float, Float)
distanceFromOrigin :: Point -> Float
distanceFromOrigin point = sqrt ((fst point)^2 + (snd point)^2)

combinePoints :: (Point, Point) -> Point
combinePoints (p1, p2) = (fst p1 + fst p2, snd p1 + snd p2)

{-
SUM TYPES

Custom Sum Type
Define
data Shape = Circle Float | Rectangle Float Float
Then write area :: Shape -> Float.

Pattern Matching on Sum Type
Extend Shape with Triangle Float Float Float, then modify area to handle it (you can use Heron’s formula).

Error Handling via Sum Type
Create
data ParseResult = Success Int | Error String
and define a function safeReadInt :: String -> ParseResult.
-}


data Shape 
    = Circle Float 
    | Rectangle Float Float 
    | Triangle Float Float Float

area :: Shape -> Float
area s = case s of
    Circle r -> pi * r * r
    Rectangle w l -> w * l
    Triangle s1 s2 s3 -> sqrt (sem * (sem - s1) * (sem - s2) * (sem - s3))
        where sem = s1 + s2 + s3 / 2

data ParseResult
    = Success Int
    | Error String
    deriving Show

safeReadInt :: String -> ParseResult
safeReadInt "" = Error "Empty string"
safeReadInt s = Success (safeReadIntH (reverse s))

safeReadIntH :: [Char] -> Int
safeReadIntH [] = 0
safeReadIntH (x:xs) = digitToInt x + 10 * safeReadIntH xs

{-
FULL ADTS

Arithmetic Expressions
Define
data Expr = Val Int | Add Expr Expr | Mul Expr Expr
Write an evaluator eval :: Expr -> Int.

Extending Expressions
Add Sub and Div to Expr, and update eval to safely handle division by zero using Maybe Int.
-}

data Expr 
    = Val Int 
    | Add Expr Expr 
    | Mul Expr Expr
    | Sub Expr Expr
    | Div Expr Expr

eval :: Expr -> Int
eval v = case v of
    Val n -> n
    Add a b -> eval a + eval b
    Mul a b -> eval a * eval b 
    Sub a b -> eval a - eval b
    Div a b -> case eval b of 
        0 -> error "Division by 0 error."
        _ -> eval a `div` eval b

{-
Define a polymorphic binary tree:
data Tree a = Leaf a | Node (Tree a) (Tree a)
Implement size :: Tree a -> Int.

Mapping Over a Tree
Write treeMap :: (a -> b) -> Tree a -> Tree b.
-}

data Tree a = Leaf a | Node (Tree a) (Tree a)
    deriving Show

size :: Tree a -> Int
size t = case t of
    Leaf a -> 1
    Node x y -> 1 + size x + size y

-- >>> size (Node (Leaf 1) (Leaf 2)) 
-- 3

treeMap :: (a -> b) -> Tree a -> Tree b
treeMap f t = case t of
    Leaf a -> Leaf (f a)
    Node x y -> (Node (treeMap f x) (treeMap f y))

{-
MONOMORPHIC LISTS

Custom Int List Type
Define
data IntList = Empty | Cons Int IntList
Implement sumIntList :: IntList -> Int.

List Reversal (Monomorphic)
Implement reverseIntList :: IntList -> IntList.

Appending Two IntLists
Write appendIntList :: IntList -> IntList -> IntList.
-}

data IntList = Empty | IntCons Int IntList
    deriving Show

sumIntList :: IntList -> Int
sumIntList Empty = 0
sumIntList (IntCons n l) = n + sumIntList l

reverseIntList :: IntList -> IntList
reverseIntList Empty = Empty
reverseIntList ls = rilH ls Empty

rilH :: IntList -> IntList -> IntList
rilH Empty ls = ls
rilH (IntCons i l1) l2 = rilH l1 (IntCons i l2)

{-
POLYMORPHISMS

Define
data MyList a = Nil | Cons a (MyList a)
Write myMap :: (a -> b) -> MyList a -> MyList b.

Fold Over Polymorphic List
Implement myFoldr :: (a -> b -> b) -> b -> MyList a -> b.

Filter Function
Implement myFilter :: (a -> Bool) -> MyList a -> MyList a.
-}

data MyList a = Nil | Cons a (MyList a)
    deriving Show

myMap :: (a -> b) -> MyList a -> MyList b
myMap f Nil = Nil
myMap f (Cons a b) = Cons (f a) (myMap f b)

myFoldr :: (a -> b -> b) -> b -> MyList a -> b
myFoldr f s Nil = s
myFoldr f s (Cons a b) = f a (myFoldr f s b)