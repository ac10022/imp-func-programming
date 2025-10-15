import System.Environment (getArgs, withArgs)
import System.IO (readFile')
{-
Write a function sayHi :: IO () that asks for the user’s name with a prompt, reads it from input, and then prints "Hi, <name>!".

Define a function doubleEcho :: IO () that reads a single line from the user and prints it twice on separate lines.

Write a function pureReverse :: String -> String that reverses a string without any IO, and then define ioReverse :: IO () that uses pureReverse to reverse user input and print it.

Create a function askAge :: IO () that prompts the user for their age, reads it, converts it to an Int, and prints "Next year you will be <age + 1>".
-}

sayHi :: IO ()
sayHi = do
    putStrLn "Enter your name:"
    userName <- getLine
    putStrLn $ "Hi, " ++ userName ++ "!"

doubleEcho :: IO ()
doubleEcho = do
    enteredLine <- getLine
    putStrLn enteredLine
    putStrLn enteredLine

pureReverse :: String -> String
pureReverse = reverse

ioReverse :: IO ()
ioReverse = do
    line <- getLine
    putStrLn $ pureReverse line

askAge :: IO ()
askAge = do
    putStrLn "What is your age?"
    age <- getLine
    let age' = read age :: Int
    putStrLn ("Next year you will be " ++ show (age' + 1))

{-
Write a function countArgs :: IO () that reads command-line arguments and prints how many were given.

Define a program printFirstArg :: IO () that prints the first command-line argument if one exists, or "No arguments!" otherwise.

Write a function showFile :: FilePath -> IO () that reads a .txt file and prints its entire contents to the console.

Define a function wordCount :: FilePath -> IO () that reads a .txt file, counts how many words it contains, and prints the total.

Write a function copyTxt :: FilePath -> FilePath -> IO () that copies the contents of one .txt file into another, safely (read fully before writing to avoid lazy IO traps).
-}

countArgs :: IO ()
countArgs = do
    args <- getArgs
    print $ length args

printFirstArg :: IO ()
printFirstArg = do
    args <- getArgs
    case args of
        [] -> putStrLn "No arguments!"
        (k:ks) -> putStrLn k 

showFile :: FilePath -> IO ()
showFile path = do
    fileContents <- readFile path
    putStrLn fileContents

wordCount :: FilePath -> IO ()
wordCount path = do
    fileContents <- readFile path
    print $ length [ x | x <- fileContents, x == ' ' || x == '\n' ] + 1
 
copyTxt :: FilePath -> FilePath -> IO ()
copyTxt source dest = do
    sourceContent <- readFile' source
    writeFile dest sourceContent