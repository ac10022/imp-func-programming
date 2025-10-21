import Data.Char (toUpper, toLower)
import Data.List (sortBy)
{-
A function greaterThan :: Int → [Int] → [Int] that takes an integer x and a list of integers xs and returns the list that only contains the elements of xs that are greater than x. Example: greaterThan 2 [1,2,3,4] = [3,4].
-}

greaterThan :: Int -> [Int] -> [Int]
greaterThan n = filter (>n)

-- >>> greaterThan 2 [1,2,3,4] == [3,4]
-- True

{-
A function filterOdd :: Integral a ⇒ [a] → [a] that remove all even elements from a list. Example: filterOdd [1,2,3] == [1,3].
-}

filterOdd :: Integral a => [a] -> [a]
filterOdd = filter odd

-- >>> filterOdd [1,2,3]
-- [1,3]

{-
A function filterSquare :: [Double] → [Double] that only keeps the square numbers in a list. You might find it useful to use the sqrt, floor, and fromIntegral functions. Example: filterSquare [1,9,2,3] == [1,9]
-}

filterSquare :: [Double] -> [Double]
filterSquare xs = [ x | x <- xs, whole $ sqrt x ]

whole :: Double -> Bool
whole n = floor n == ceiling n

-- >>> filterSquare [1,9,2,3]
-- [1.0,9.0]

{-
The Sieve of Eratosthenes is a very old method for enumerating prime numbers. It starts with a list of numbers, e.g. [2,3,...,100], and then, for each number, removes any multiples of that number. 
For example, we start by removing all even numbers (other than 2 itself) to produce the list [2,3,5,7,9,...,99]. This process is then repeated for the number 3 so that we end up removing 9, 15, etc. 
Once completed for each number in our original list, only prime numbers remain. 
    (a) Define the function primeSeiveUpTo :: Int → [Int], which outputs all the primes up to and including n. 
        Example: primeSeiveUpTo 13 ==[2,3,5,7,11,13]. 
    (b) Use primeSeiveUpTo to define a function filterPrime :: [Int] → [Int] that filters a list of numbers to contain only prime numbers. 
        Example: filterPrime [1,13,2,17,20] == [13,2,17].
-}

primeSeiveUpTo :: Int -> [Int]
primeSeiveUpTo n 
    | n <= 1 = []
    | n == 2 = [2]
    | otherwise = psh n 2 [2..n]

psh :: Int -> Int -> [Int] -> [Int]
psh a b xs
    | a == b = xs
    | otherwise =   let xs' = filter (\x -> x `mod` b /= 0 || x == b) xs 
                    in psh a (b+1) xs'

isPrime :: Int -> Bool
isPrime n = n `elem` primeSeiveUpTo n

filterPrime :: [Int] -> [Int]
filterPrime = filter isPrime

{-
Define a function double :: [Int] → [Int] that doubles each element in a list using the map function.
-}

double :: [Int] -> [Int]
double = map (*2)

{-
Using map, define the function shout :: String → String, that changes all letters to upper case. Have a look at the Data.Char module on hoogle to see if there are any functions that can help you. Example: shout "hello" =="HELLO".
-}

shout :: String -> String
shout = map toUpper

{-
Using map, define the function whisper :: String → String, that changes all letters to lower case. Example: whisper "HELLO" == "hello"
-}

whisper :: String -> String
whisper = map toLower

{-
Define the function basicTitle :: String → String, which capitalises the first character of every word. Example: basicTitle "functional programming" == "Functional Programming".
-}

capitalise :: String -> String
capitalise [] = []
capitalise (x:xs) = toUpper x : xs

basicTitle :: String -> String
basicTitle xs = unwords $ map capitalise $ words xs

-- >>> basicTitle "hello world"
-- "Hello World"

{-
The or :: [Bool] → Bool function can be used to check if any of the given lists elements are True. 
    (a) Using this function and the map function, implement a function anyList :: (a → Bool) → [a] → Bool that returns True is any element of the list satisfies the given predicate (i.e. the function of type a →Bool). 
    Example: anyList even [1,2,3] = True and anyList odd [2,4,6] = False. 
    (b) Again using the or and map functions, define another function anyList′ :: [a → Bool] → a → Bool that instead takes a list of predicates and a fixed values of type a and checks whether any of the predicates are true for this value.
-}

anyList :: (a -> Bool) -> [a] -> Bool
anyList f xs = or $ map f xs

anyList' :: [a -> Bool] -> a -> Bool
anyList' [] x = False
anyList' (f:fs) x = f x || anyList' fs x 

{-
Define fancyTitle :: String → String, which is just like basicTitle, but follows more capitalisation rules: 
    • Always capitalize the first word as well as all nouns, pronouns, verbs, adjectives, and adverbs. 
    • Articles, conjunctions, and prepositions should not be capitalized. (i.e. “and” or “the”) Example: fancyTitle "a little bit of FP" == "A Little Bit of FP" In other words, iteratively improve the basicTitle function to include more features. e.g. Now it doesn’t capitalise an ‘a’ unless it is at the start of the title.
-}

fancyTitle :: String -> String
fancyTitle [] = []
fancyTitle s =  let wds = words s in
                unwords ((capitalise $ head wds) : (smartCapitalise $ tail wds))

smartCapitalise :: [String] -> [String]
smartCapitalise [] = []
smartCapitalise (x:xs)
    | x `elem` ["a", "the", "and", "of", "this", "that"] = x : smartCapitalise xs
    | otherwise = capitalise x : smartCapitalise xs

-- >>> fancyTitle "a little bit of a FP"
-- "A Little Bit of a FP"

{-
Using a list comprehension, define the function myMap :: (a → b) → [a] → [b] capable of transforming one list containing values of type a into one containing bs.
-}

myMap :: (a -> b) -> [a] -> [b]
myMap f xs = [ f x | x <- xs ]

{-
Using a list comprehension, define a function myFilter :: (a → Bool) → [a] → [a] such that myFilter p xs keeps every element x in xs for which p x is True.
-}

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter p xs = [ x | x <- xs, p x ]

-- >>> myFilter (==3) [1,2,3,3,4,5]
-- [3,3]

{-
Define a function myFunc :: [Int] → [Int] such that myFunc xs computes the list comprehension [2 ∗ x | x ← xs,x ⩾ 2] but only uses the map and filter functions.
-}

myFunc :: [Int] -> [Int]
myFunc xs = map (*2) $ filter (>=2) xs

{-
Define a function sumPairs :: [Int] → [Int] → [Int] such that sumPairs xs ys computes the following list comprehension [x + y | x ← xs,y ← ys] without using a list comprehension. You may wish to use the concatMap :: (a → [b]) → [a] → [b] function
-}

mapAdd :: (Int, [Int]) -> [Int]
mapAdd p = map (+ fst p) $ snd p

sumPairs :: [Int] -> [Int] -> [Int]
sumPairs xs ys =    let z = zip xs (replicate (length xs) ys) in
                    concatMap mapAdd z

sumPairs' :: [Int] -> [Int] -> [Int]
sumPairs' xs ys = [ x + y | x <- xs, y <- ys ]

-- >>> sumPairs' [1,2,3,4] [5,6,7,8]
-- [6,7,8,9,7,8,9,10,8,9,10,11,9,10,11,12]

-- >>> sumPairs [1,2,3,4] [5,6,7,8]
-- [6,7,8,9,7,8,9,10,8,9,10,11,9,10,11,12]

{-
Using the function zipWith :: (a → b → c) → [a] → [b] → [c] define the function myZip :: [a] → [b] → [(a, b)]. Use the type information the help you.
-}

myZip :: [a] -> [b] -> [(a,b)]
myZip = zipWith (,)

{-
Using the function sortBy :: (a → a → Ordering) → [a] → [a] from Data.List, define compareSnd :: (Ord a,Ord b) ⇒ [(a,b)] → [(a,b)], which sorts the pairs into ascending order based on the second element Example: compareSnd [(1,9),(2,8),(3,7)] == [(3,7),(2,8),(1,9)]
-}

compareSnd :: (Ord a, Ord b) => [(a,b)] -> [(a,b)]
compareSnd = sortBy (\x y -> snd x `compare` snd y)

-- >>> compareSnd [(1,9),(2,8),(3,7)]
-- [(3,7),(2,8),(1,9)]

{-
Write a function twice::(a → a) → a → a that takes a function of type a → a and an initial value of type a and applies the function to the value twice.
-}

twice :: (a -> a) -> a -> a
twice f a = f $ f a

-- >>> twice (+2) 3
-- 7

{-
Generalise the previous function to applyN :: Int → (a → a) → a → a take additionaly takes an integer and applies the given function that many times.
-}

applyN :: Int -> (a -> a) -> a -> a
applyN 1 f a = f a
applyN n f a = applyN (n-1) f (f a)

{-
Define applyUntilStable :: Eq a ⇒ (a → a) → a → a, which applies the given (a → a) function until the answer doesn’t change. Example: applyUntilStable (\x → if x ⩽ 0 then 0 else x−1) 7==0
-}

applyUntilStable :: Eq a => (a -> a) -> a -> a
applyUntilStable f a = let a' = f a in
    if a' == f a' then a'
    else applyUntilStable f a' 

{-
Integration, the mathematical operation for finding the area under a curve, is also an example of a higher order function — it takes as input the function to integrate and returns its integral. An approximate ap proach to integration uses the trapezoidal rule.
Using the trapezoidal rule, define a function integrate :: (Float → Float) → Float → Float that takes a function f :: Float → Float and a value x :: Float and approximates its integral over the range 0 to x.
-}

integrate :: (Float -> Float) -> Float -> Float
integrate f x = x * (f 0 + f x) * 0.5

-- >>> integrate exp 0.1
-- 0.10525855

{-
Convert foo to use function composition: foo :: [Int] → [Int], foo xs = map (∗10) (filter even xs)
-}

foo :: [Int] -> [Int]
foo = map (*10) . filter even

{-
Convert bar to use function composition: bar :: [Int] → Int, bar xs = foldr (+) 0 (map (+1) (filter odd xs))
-}

bar :: [Int] -> Int
bar = foldr (+) 0 . map (+1) . filter odd

{-
Convert baz to use function composition: baz :: [[a]] → [Int], baz xss = map length (filter (\xs → odd (length xs)) xss)
-}

baz :: [[a]] -> [Int]
baz = map length . filter (odd . length)

-- >>> baz ["hello", "bye", "goodbye", "hello", "once", "twice"]
-- [5,3,7,5,5]

{-
Rewrite the twice :: (a → a) → a → a function that applies the given argument twice, using function composition.
-}

twice' :: (a -> a) -> a -> a
twice' f = f . f

{-
Rewrite the list comprehension [2 ∗ x | x ← xs,x ⩾ 2] using function composition.
-}

listComp :: [Int] -> [Int]
listComp = map (*2) . filter (>=2)

{-
The id :: a → a function returns its input without modifying it. Rewrite the expression filter id . map even as a single filter expression.
-}

foo' :: [Int] -> [Int]
foo' = filter even

{-
As laziness means that only those expressions which need to be evaluated are evaluated, we can work with infinite values (such as infinite lists) as long as we only ever use a finite section. 
    (a) Try evaluating the expression [1..] in GHCi (you’ll need to use the Ctrl-C shortcut to terminate the evaluation).
    (b) Recall the headOrZero function from Section 1 that returns the first element of a list or 0 if it is empty. Make sure that function evaluates the input list 2:⊥ to 2 and does not crash in this case. If it crashes, reimplement your function using pattern matching instead of any previously defined functions. Now try evaluating the expression headOrZero [1..]. Why does this expression terminate even when given an infinite input list? 
    (c) Test your take::Int → [Int] → [Int] function from earlier. It should have the behaviour: take 3 [1..] = [1, 2, 3]. If take 3 [1..] fails to terminate, change it so it does. 
    (d) Implement the function repeat :: Int → [Int] that given an input value x returns an infinite list that repeats the element x. For example, take 5 (repeat 1) = [1,1,1,1,1]. You will need to use recursion to construct the infinite list. 
    (e) Implement the function cycle :: [Int] → [Int] that takes a finite list and repeats it infinitely often. For example, take 5 (cycle [1,2,3]) = [1,2,3,1,2]. You may wish to use the function (++) :: [Int] → [Int] → [Int] that appends two lists, e.g. [2,3] ++ [1] = [2,3,1].
-}

headOrZero :: [Int] -> Int
headOrZero [] = 0
headOrZero xs = head xs

repeat' :: Int -> [Int]
repeat' n = map (*n) [1,1..]

-- >>> take 5 (repeat' 1)
-- [1,1,1,1,1]

cycle' :: [Int] -> [Int]
cycle' n = n ++ cycle' n

-- >>> take 5 (cycle' [1,2,3])
-- [1,2,3,1,2]