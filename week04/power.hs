module Power where
-- Code for the Power to the People Coursework.
-- Write all your code in this file.
-- *DO NOT CHANGE THE FUNCTION NAMES OR TYPE SIGNATURES*

---------------------------------------------
-- An example implementation of the power function.
-- *DO NOT EDIT THIS FUNCTION OR USE IT IN YOUR CODE*

power :: Integer -> Integer -> Integer
power n k
   | k < 0 = error "power: negative argument"
power n 0  = 1
power n k  = n * power n (k-1)

-- Task 1 -------------------------

stepsPower :: Integer -> Integer -> Integer
stepsPower n k = k + 1

-- Task 2 -------------------------

power1 :: Integral a => a -> a -> a
power1 n k = product (replicate (fromIntegral k) n)

-- Task 3 -------------------------

power2 :: Integral a => a -> a -> a
power2 n k
   | k == 0 = 1
   | even k = power2 (n * n) (k `div` 2)
   | otherwise = n * power2 n (k-1)

-- Task 4 -------------------------

comparePower1 :: Integer -> Integer -> Bool
comparePower1 n k = power n k == power1 n k

comparePower2 :: Integer -> Integer -> Bool
comparePower2 n k = power n k == power2 n k

-- Task 5 -------------------------

-- Each entry should be in this format: (n, k, result of comparePower1, result of comparePower2)
comparisonList :: [Integer] -> [Integer] -> [(Integer, Integer, Bool, Bool)]
comparisonList ns ks = [ (x, y, comparePower1 x y, comparePower2 x y) | x <- ns, y <- ks ]
