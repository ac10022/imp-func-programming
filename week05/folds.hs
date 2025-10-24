module Folds where

import Prelude hiding (foldr, foldl, sum, product, length, maximum, minimum, concat, takeWhile) 

-- >>> sum [1..200]
-- 20100

sum :: [Int] -> Int
sum list = case list of
  x : xs -> x + sum xs
  []     -> 0

-- >>> product [1..5]
-- 120

product :: [Int] -> Int
product list = case list of
  x : xs -> x * product xs
  []     -> 1

-- >>> length [1..100]
-- 100

length :: [a] -> Int
length list = case list of
  x : xs -> 1 + length xs
  []     -> 0

snoc :: a -> [a] -> [a]
snoc y list = case list of
  x : xs -> x : snoc y xs
  []     -> [y]

-- >>> xorList [False, True, True]
-- False
-- >>> xorList [False, False, True]
-- True
-- >>> xorList [False, True, True, False, True, True]
-- False

xorList :: [Bool] -> Bool
xorList list = case list of
  x : xs -> xor x (xorList xs)
  []     -> False

xor :: Bool -> Bool -> Bool
xor False False = False
xor False True  = True
xor True  False = True
xor True  True  = False