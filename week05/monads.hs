import System.IO (readFile')
{-
Write a simple IO action sayHello :: IO () that uses >>= to ask for the user’s name and print "Hello, <name>!".
(No do notation — just chaining with >>=.)

Re-implement the above sayHelloDo :: IO () using do notation instead of >>=.

Define a pure function safeDiv :: Int -> Int -> Maybe Int that performs integer division but returns Nothing if the divisor is 0.

Write a function safeChain :: Maybe Int that uses safeDiv multiple times to compute (((100 ÷ 2) ÷ 5) ÷ 0) safely using >>= chaining.

Define a function doubleMaybe :: Maybe Int -> Maybe Int that doubles the value inside a Just, or leaves it Nothing.
Use do notation.
-}

sayHello :: IO ()
sayHello = 
    putStrLn "What's your name?" >>= (\_ -> getLine >>= (\name -> putStrLn $ "Hello, " ++ name))

sayHelloDo :: IO ()
sayHelloDo = do
    putStrLn "What's your name?"
    name <- getLine
    putStrLn ("Hello, " ++ name)

safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv a b = Just (a `div` b)

safeChain :: Maybe Int
safeChain = do
    a <- safeDiv 100 2
    b <- safeDiv a 5
    safeDiv b 0

doubleMaybe :: Maybe Int -> Maybe Int
doubleMaybe n = do
    a <- n
    Just (a * 2)

{-
Write a function askTwoNumbers :: IO () that asks the user for two numbers, reads them, sums them, and prints the result — using do notation.

Define a function readNumber :: IO Int that reads a line from input and converts it to an Int using read.
Then use it in sumThree :: IO Int that reads three numbers and returns their sum using do notation.

Create a function maybeAdd :: Maybe Int -> Maybe Int -> Maybe Int using monadic do notation, that adds two Maybe values safely.

Define a simple monadic pipeline squareAndShow :: Int -> IO () that squares an integer and prints it — first using >>=, then rewrite with do notation.

Implement a function readFileLength :: FilePath -> IO Int that reads a .txt file, computes its character count, and returns it using >>= instead of do.
-}

askTwoNumbers :: IO ()
askTwoNumbers = do
    putStrLn "Enter first number"
    num1 <- getLine
    putStrLn "Enter second number"
    num2 <- getLine
    let num3 = (read num1 :: Int) + (read num2 :: Int)
    print num3

readNumber :: IO Int
readNumber = do
    ln <- getLine
    return (read ln)

sumThree :: IO Int
sumThree = do
    n1 <- readNumber
    n2 <- readNumber
    n3 <- readNumber
    return (n1 + n2 + n3)

maybeAdd :: Maybe Int -> Maybe Int -> Maybe Int
maybeAdd n1 n2 = do
    p1 <- n1
    p2 <- n2
    Just (p1 + p2)

squareAndShow :: Int -> IO ()
squareAndShow n = return (n * n) >>= print

squareAndShow' :: Int -> IO ()
squareAndShow' n = do
    print (n * n)

fileReadLength :: FilePath -> IO Int 
fileReadLength fp = do
    contents <- readFile' fp
    return (length contents) 

