import Prelude hiding (length,sum,product,zip,take,repeat,cycle,(++))

{-
A function headOrZero :: [Int] → Int, which returns the first element of a list or 0 if it is empty.
-}

headOrZero :: [Int] -> Int
headOrZero [] = 0
headOrZero (x:xs) = x

-- >>> headOrZero [1,2,3]
-- 1

-- >>> headOrZero []
-- 0

{-
A function length :: [Int] → Int, which returns the number of elements in a given list
-}

length :: [Int] -> Int
length [] = 0
length (x:xs) = 1 + length xs

-- >>> length [1,2,3]
-- 3

-- >>> length []
-- 0

{-
Write out evaluation steps for length (1 : 2 : []). You may want to rewrite length to be a one-line function to make it easier to write out the evaluation.
-}

{-
length 1 : 2 : []
== 1 + length 2 : []
== 1 + 1 + length []
== 1 + 1 + 0
== 2
-}

{-
A function sum :: [Int] → Int, which returns the summation of all the elements in the list and 0 if the list is empty.
-}

sum :: [Int] -> Int
sum [] = 0
sum (x:xs) = x + sum xs

-- >>> sum [1,2,3,4]
-- 10

-- >>> sum []
-- 0

{-
A function product::[Int] → Int, which multiplies all the elements in the list together. Make sure to pick an appropriate base case for the empty list!
-}

product :: [Int] -> Int
product [] = 1
product (x:xs) = x * product xs

-- >>> product [1,2,3,4]
-- 24

-- >>> product []
-- 1

{-
Define a function snoc :: Int → [Int] → [Int] which adds an element to the end of a list. (We call it snoc because it’s the opposite of (:) a.k.a. “cons”, which adds an element to the front of a list.) For example, snoc 2 [1,3] = [1,3,2].
-}

snoc :: Int -> [Int] -> [Int]
snoc x xs = reverse (x: reverse xs)

-- >>> snoc 2 [1,3]
-- [1,3,2]

{-
Implement the function take :: Int → [Int] → [Int] such that take n xs only returns the first n elements of the input list. For example: take 3 [1,2,3,4,5] = [1,2,3].
-}

take :: Int -> [Int] -> [Int]
take n [] = []
take 0 xs = []
take n (x:xs) = x : take (n-1) xs

-- >>> take 3 [1,2,3,4,5]
-- [1,2,3]

{-
Define a function insert :: Int → [Int] → [Int] that, given an element x and a sorted input list xs in ascending order, produces another sorted list with x inserted into the correct position in xs. If the element is already present in the list, it should appear an additional time. For example, insert 2 [1,3] = [1,2,3] and insert 3 [1,3] = [1,3,3].
-}

insert :: Int -> [Int] -> [Int]
insert t [] = [t]
insert t (x:xs)
    | x > t = t : x : xs
    | otherwise = x : insert t xs

{-
Use the insert defined in the previous question to implement the function isort :: [Int] → [Int] which sorts an arbitrary input list in ascending order. For example, isort [2,3,1,2] = [1,2,2,3].
-}

isortHelper :: [Int] -> [Int] -> [Int]
isortHelper [] o = o
isortHelper (x:xs) o = isortHelper xs (insert x o) 

isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = isortHelper (x:xs) []

-- >>> isort [2,3,1,2]
-- [1,2,2,3]

-- >>> isort [2,4,1,3,0,2,1]
-- [0,1,1,2,2,3,4]

{-
Define a function merge :: [Int] → [Int] → [Int] that takes two lists xs and ys that are sorted in ascending order, and produces another list containing all their elements in ascending order.
-}

merge :: [Int] -> [Int] -> [Int]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
    | x < y = x : merge xs (y:ys)
    | otherwise = y : merge (x:xs) ys

-- >>> merge [1,2,3,4] [0,2,3,4,5,6]
-- [0,1,2,2,3,3,4,4,5,6]

{-
Define a function zip :: [Int] → [Int] → [(Int,Int)] that takes two input lists and returns a list which pairs up the corresponding element of the lists.
-}

zip :: [Int] -> [Int] -> [(Int, Int)]
zip [] _ = []
zip _ [] = []
zip (x:xs) (y:ys) = (x, y) : zip xs ys

-- >>> zip [1,2,3] [4,5,6]
-- [(1,4),(2,5),(3,6)]

-- >>> zip [1,2,3,4] [2,3]
-- [(1,2),(2,3)]

{-
Define a function (++) :: [a] → [a] → [a] which appends one list to the end of another. 
It has a polymorphic type, which we have avoided so far and will dig into more later, but for now you can think of it like (++) :: [Int] → [Int] → [Int]. 

It is a binary operator, which means it’s usually used infix, like addition and multiplication. For example, [1,2] ++ [3,4] = [1,2,3,4] 
You can also use it like a normal prefix function by adding brackets, e.g. (++) [1,2] [3,4] = [1,2,3,4]. 
Operators are defined just like normal functions, except you define them like this: 

(++) :: [a] → [a] → [a] 
(++) xs ys = error "Implement me!" 

Or like this: 
(++) :: [a] → [a] → [a] 
xs ++ ys = error "Implement me!" 

This choice of definition style doesn’t affect how the operator is used.
-}

(++) :: [a] -> [a] -> [a]
[] ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)

{-
Using a list comprehension and a range, define a function squaresUpto :: Int → [Int] which, given an n, returns the list of all the square numbers up to and including the nth square number. For example, squaresUpto 3 = [0,1,4,9]
-}

squaresUpTo :: Int -> [Int]
squaresUpTo n 
    | n < 1 = []
    | otherwise = [ x * x | x <- [1..n] ]

-- >>> squaresUpTo (100)
-- [1,4,9,16,25,36,49,64,81,100,121,144,169,196,225,256,289,324,361,400,441,484,529,576,625,676,729,784,841,900,961,1024,1089,1156,1225,1296,1369,1444,1521,1600,1681,1764,1849,1936,2025,2116,2209,2304,2401,2500,2601,2704,2809,2916,3025,3136,3249,3364,3481,3600,3721,3844,3969,4096,4225,4356,4489,4624,4761,4900,5041,5184,5329,5476,5625,5776,5929,6084,6241,6400,6561,6724,6889,7056,7225,7396,7569,7744,7921,8100,8281,8464,8649,8836,9025,9216,9409,9604,9801,10000]

{-
Define a function odds :: Int → [Int], which lists the positive odd numbers less than or equal to the input number.
-}

odds :: Int -> [Int]
odds n 
    | n < 1 = []
    | otherwise = [ x | x <- [1..n], odd x ]

-- >>> odds 100
-- [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99]

{-
Implement the function orderedPairs :: [Int] → [(Int,Int)] which returns all pairs of elements (x,y) taken from its input list such that x < y. For example, orderedPairs [3,4,1] = [(1,3),(3,4),(1,4)]. It doesn’t matter in which order the pairs appear.
-}

orderedPairs :: [Int] -> [(Int, Int)]
orderedPairs xs = [ (x, y) | x <- xs, y <- xs, x < y ]

{-
A bit string is a string made up of either '0' or '1'. Write a function that will output all possible bit strings of length n. For example, bitString 2 = ["00","01","10","11"]
-}

bitString :: Int -> [String]
bitString n
    | n == 1 = ["0", "1"]
    | otherwise = [ x ++ y | x <- ["0", "1"], y <- bitString (n-1) ]

-- >>> bitString 5
-- ["00000","00001","00010","00011","00100","00101","00110","00111","01000","01001","01010","01011","01100","01101","01110","01111","10000","10001","10010","10011","10100","10101","10110","10111","11000","11001","11010","11011","11100","11101","11110","11111"]
