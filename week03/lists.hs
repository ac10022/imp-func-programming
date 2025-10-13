module Lists where

egTupleInts :: (Int, Int, Int)
egTupleInts = (1, 2, 3)

egList :: [Int]
egList = 1 : (2 : (3 : []))

-- >>> egList
-- [1,2,3]

cons :: Int -> [Int] -> [Int]
cons x xs = x : xs

-- append 1 to list [2,3]
-- >>> cons 1 [2,3]
-- [1,2,3]

is123 :: [Int] -> Bool
is123 xs = case xs of
    [1,2,3] -> True
    xs -> False 

-- >>> is123 [1,2]
-- False

head' :: [Int] -> Int
head' xs = case xs of
    a : _ -> a

head'' :: [Int] -> Int
head'' (x:xs) = x

-- >>> head' [1,2,3]
-- 1

tail' :: [Int] -> [Int]
tail' xs = case xs of
    _ : a -> a

tail'' :: [Int] -> [Int]
tail'' (x:xs) = xs

-- >>> tail' [1,2,3]
-- [2,3]

sum' :: [Int] -> Int
sum' [] = 0
sum' (x:xs) = x + sum' xs

-- >>> sum' [1,2,3,4]
-- 10

-- >>> sum' [1..2938]
-- 4317391
