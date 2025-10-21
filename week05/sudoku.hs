module Sudoku where
import Data.List (findIndex, elemIndex, union)
import Data.Maybe (isNothing, isJust)
import Data.Char (ord, isDigit)
import System.IO (readFile')

{-
We define the board as a 9x9 grid of cells, where each cell is either "empty" or a value 1-9
-}

type Grid = [[Cell]]

data Cell = Empty | Value Int

instance Show Cell where
    show :: Cell -> String
    show Empty = "_"
    show (Value n) = show n

instance Eq Cell where
    (==) :: Cell -> Cell -> Bool
    Empty == Empty = True
    (Value m) == (Value n) = n == m
    _ == _ = False


easyGrid :: Grid
easyGrid =
  [ 
    [Value 5,   Value 3,    Empty,    Empty,    Value 7,    Empty,      Empty,      Empty,      Empty   ]
  , [Value 6,   Empty,      Empty,    Value 1,  Value 9,    Value 5,    Empty,      Empty,      Empty   ]
  , [Empty,     Value 9,    Value 8,  Empty,    Empty,      Empty,      Empty,      Value 6,    Empty   ]
  , [Value 8,   Empty,      Empty,    Empty,    Value 6,    Empty,      Empty,      Empty,      Value 3 ]
  , [Value 4,   Empty,      Empty,    Value 8,  Empty,      Value 3,    Empty,      Empty,      Value 1 ]
  , [Value 7,   Empty,      Empty,    Empty,    Value 2,    Empty,      Empty,      Empty,      Value 6 ]
  , [Empty,     Value 6,    Empty,    Empty,    Empty,      Empty,      Value 2,    Value 8,    Empty   ]
  , [Empty,     Empty,      Empty,    Value 4,  Value 1,    Value 9,    Empty,      Empty,      Value 5 ]
  , [Empty,     Empty,      Empty,    Empty,    Value 8,    Empty,      Empty,      Value 7,    Value 9 ]
  ]

{-
We need basic functions to get rows, columns, and an element given an (x,y) co-ordinate.
-}

-- takes a list, and number (n), and returns a new list of lists where the given list is splitted at every nth element
chunker :: Int -> [a] -> [[a]]
chunker _ [] = []
chunker n xs = take n xs : chunker n (drop n xs) -- add first n to a list, then repeat recursively with rest

-- takes a list of 81 cells and turns it into a grid
createGrid :: [Cell] -> Maybe Grid
createGrid cs
  | length cs /= 81 = Nothing
  | otherwise = Just (chunker 9 cs) 

-- display grid g to the console
showGrid :: Maybe Grid -> IO ()
showGrid Nothing = putStrLn "Nothing"
showGrid (Just g) = putStrLn $ unlines $ map show g

-- gets the nth row of grid g
row :: Int -> Grid -> [Cell]
row n g = g !! n

-- transposes the grid
transpose :: Grid -> Grid
transpose g = [ map (!!n) g | n <- [0..8] ]

-- gets the nth column of grid g
col :: Int -> Grid -> [Cell]
col n g = row n $ transpose g -- as col n = transpose (row n)

-- gets the cell of grid g at co-ordinate (x,y)
elemAtPoint :: Int -> Int -> Grid -> Cell
elemAtPoint x y g = row x g !! y

-- get all elements of the box of grid g at co-ordinate (x,y)
box :: Int -> Int -> Grid -> [Cell]
box x y g = [ elemAtPoint x' y' g | x' <- ts, y' <- rs ]
  where ts = [ t | t <- [0..8], t `div` 3 == x `div` 3] -- get xs such that x falls into the same div 3 group
        rs = [ r | r <- [0..8], r `div` 3 == y `div` 3] -- get ys such that y falls into the same div 3 group

{-
We need a function to check whether a grid is full or not, and if not, find the next empty element.
-}

-- checks if the grid is full of non-empty elements
gridFull :: Grid -> Bool
gridFull g =  let g' = concat g in
              length (filter (/=Empty) g') == length g' -- check if length of non-empty elements is the same as length of all elements

-- find the co-ordinates of the first empty element on the grid
findEmpty :: Grid -> Maybe (Int, Int)
findEmpty g
  | gridFull g = Nothing -- if full we have no co-ordinates
  | otherwise = do
      ind <- elemIndex Empty (concat g) -- otherwise get the index of the element in the flattened grid
      return (ind `div` 9, ind `mod` 9) -- and use modulo tricks to retrieve the co-ordinates

-- takes in a grid, a co-ordinate, and a number
-- if that number put into that co-ordinate constitutes a valid move, return true
-- otherwise return false
validMove :: Grid -> (Int, Int) -> Int -> Bool
validMove g (x,y) n = not $ Value n `elem` ((box x y g) `union` (row x g) `union` (col y g))

-- takes a list and returns a modified version where the value of the index specified by the integer is changed to the new item
-- does NOT check whether the integer is a valid index of the list
modifyNth :: [a] -> Int -> a -> [a]
modifyNth xs n new =  let (h, _ : t) = splitAt n xs in
                      h ++ [new] ++ t

-- takes a grid, a co-ordinate, and a number
-- updates the board by putting the number in the co-ordinate position
-- does NOT check if the move is valid
updateGrid :: Grid -> (Int, Int) -> Int -> Grid
updateGrid g (x,y) n = chunker 9 (modifyNth g' (x*9 + y) (Value n)) -- flatten g, then modify the correct element, then re-grid
                        where g' = concat g

-- unwraps a maybe int tuple
-- does NOT check for nothingness
unwrapTuple :: Maybe (Int, Int) -> (Int, Int)
unwrapTuple Nothing = (0, 0)
unwrapTuple (Just (x, y)) = (x, y)

-- sudoku solver
solve :: Grid -> Maybe Grid
solve g
  | isNothing $ findEmpty g = Just g -- if we have filled all positions, then the sudoku must be finished, so return it
  | otherwise = do -- otherwise 
      cds <- findEmpty g -- get the coordinates of the next empty cell
      let validNums = [ x | x <- [1..9], validMove g cds x] -- test all numbers 1-9 in this position, returning the list of numbers that work
      solveWithNum g validNums cds -- find a potential solved grid by calling the solveWithNum function
      -- if we find a solved grid based on our valid nums then we can continue, otherwise we must backtrack, we have found a wrong input somewhere

solveWithNum :: Grid -> [Int] -> (Int, Int) -> Maybe Grid
solveWithNum _ [] _ = Nothing -- if we get through all valid nums with no success, we return nothing
solveWithNum g (x:xs) cds = do
  let newGrid = updateGrid g cds x -- create a new grid with the next valid grid
  let solvedGrid = solve newGrid -- check if its solvable
  if isJust solvedGrid then solvedGrid else solveWithNum g xs cds -- if its solveable then continue with this one, otherwise keep searching with the valid nums till its solvable

-- checks sudoku by ensuring each number 1-9 is present in each row and column of the grid
checkSudoku :: Maybe Grid -> Bool
checkSudoku Nothing = False
checkSudoku (Just g) = and [ Value x `elem` row y g && Value x `elem` col y g | x <- [1..9], y <- [0..8] ] -- and fold

{-
We need functions to deal with the user inputting their own sudoku.
-}

-- a function to parse into a map function, for the default portable format of sudokus
-- if the character is '0' it is empty, otherwise, digits get converted to cells
-- otherwise, is an invalid character
cellMatcher :: Char -> Cell
cellMatcher c
  | c == '0' = Empty
  | isDigit c = Value (ord c - ord '0')
  | otherwise = Empty

-- read contents of a string, then apply the cell matcher above to each character
readGridFromString :: String -> Maybe Grid
readGridFromString s = createGrid $ map cellMatcher s

-- read contents of a file stream, then apply the cell matcher above to each character
-- and parse that into the grid creator to form a grid structure
readGridFromFile :: FilePath -> IO (Maybe Grid)
readGridFromFile fp = do
  fileContents <- readFile' fp
  return (readGridFromString fileContents)

-- display a grid given a file containing one
showGridFromFile :: FilePath -> IO ()
showGridFromFile fp = do
  grid <- readGridFromFile fp
  showGrid grid

-- solve a grid given a file containing one, then check to ensure it is correct and display this
solveGridFromFile :: FilePath -> IO ()
solveGridFromFile fp = do
  grid <- readGridFromFile fp
  let solved = solveMaybeGrid grid
  showGrid solved
  if checkSudoku solved then putStrLn "Checked: OK" else putStrLn "Checked: FAILED" 

-- a method which takes in a maybe grid and solves it if its not nothing
solveMaybeGrid :: Maybe Grid -> Maybe Grid
solveMaybeGrid Nothing = Nothing
solveMaybeGrid (Just g) = solve g
