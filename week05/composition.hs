import Prelude hiding ((.), subtract, curry, uncurry)

(.) :: (b -> c) -> (a -> b) -> a -> c
(g . f) x = g (f x)

-- forward composotion
(.>) :: (a -> b) -> (b -> c) -> a -> c
(f .> g) x = g (f x)

-- currying

takeAway :: (Int, Int) -> Int
takeAway (x, y) = x - y

subtract :: Int -> Int -> Int
subtract x y = x - y

-- curry takes a function where arguments are in a tuple and turns it into an function which takes detatched arguments
-- >>> (curry takeAway) 10 2
-- 8

curry :: ((a, b) -> c) -> a -> b -> c
curry f x y = f (x, y)

-- uncurry takes a function which takes its arguments detatched and turns it into a function which accepts tuple arguments
-- >>> (uncurry subtract) (10,2)
-- 8

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) = f x y

-- takeWhile
-- takes elements from a list while a predicate holds

-- >>> takeWhile (<=3) [1..]
-- [1,2,3]

-- sortBy