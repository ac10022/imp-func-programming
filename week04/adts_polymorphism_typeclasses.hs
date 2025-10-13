import Data.List

{-
Using pattern matching, define a function isJust :: Maybe a → Bool that returns True if its argument is of the form Just x and returns False otherwise.
-}

isJust :: Maybe a -> Bool
isJust (Just _) = True
isJust _ = False

{-
Write a function fromMaybe :: a → Maybe a → a which extracts the value from the given Maybe if it’s a Just and returns the first value of type a otherwise. 
    For example,    fromMaybe 10 (Just 5) = 5 
                    fromMaybe 10 Nothing = 10
-}

fromMaybe :: a -> Maybe a -> a
fromMaybe v m = case m of
    Just n -> n
    _ -> v

{-
Define a function forget :: Either String a → Maybe a using pattern matching. 
(Bonus question: Are there any different behaviours you could give to a function with this type?)
-}

forget :: Either String a -> Maybe a
forget e = case e of
    Left _ -> Nothing
    Right n -> Just n 

{-
Give a type for the expression Just (Right True). Is this the only type you could give it?
-}

-- Maybe (Either a Bool)

{-
The Maybe datatype is often used to represent the possibility of failure: a function may either return the desired “output” (using Just x) or fail and return Nothing. 
    (a) Define a function safeDiv :: Int → Int → Maybe Int using pattern matching such that safeDiv x y performs div x y if y is non-zero. As with the Maybe a datatype, Either a b is often used to represent failure. With this datatype, however, the failure case can provide more information. 
    (b) Define another function safeDiv′ :: Int → Int → Either String Int that performs division safely, but this time provides a String for an error message upon division by zero. 
    (c) Using pattern matching and recursion, write a function checkForErrors::[Either String a] → Either String [a] that recurses through its input list and returns Left msg if it encounters an element of the form Left msg and otherwise, if each element is of the form Right x for some value x, returns this list of values. For example, 
        checkForErrors [Right 10,Right 9] = Right [10,9] 
        checkForErrors [Right 10,Left "Error!",Right 9] = Left "Error!" 
        checkForErrors [Right 10,Left "First error!",Right 9,Left "Second error!"] = Left "First error!"
-}

safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv a b = Just (a `div` b)

safeDiv' :: Int -> Int -> Either String Int
safeDiv' _ 0 = Left "Division by 0 error."
safeDiv' a b = Right (a `div` b)

checkForErrors :: [Either String a] -> Either String [a]
checkForErrors [] = Right []
checkForErrors (x:xs) = case x of
    Left err -> Left err
    Right n -> case checkForErrors xs of
        Left err -> Left err
        Right ys -> Right (n : ys)

{-
Define the following functions over Expr. 
(a) size :: Expr → Int that counts the number of operators in an expression. 
(b) eval :: Expr → Int that evaluates the expression. 
(c) pretty :: Expr → String that prints the expression, as you would expect a mathematical expression to appear.
-}

{-
Add a Sub (subtraction) constructor to the Expr datatype and update the functions size, eval, and pretty to account for it.
-}

data Expr 
    = Lit Int
    | Add Expr Expr
    | Mul Expr Expr
    | Sub Expr Expr

size :: Expr -> Int
size (Lit _) = 0
size (Add x y) = 1 + size x + size y
size (Sub x y) = 1 + size x + size y
size (Mul x y) = 1 + size x + size y

eval :: Expr -> Int
eval (Lit n) = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y
eval (Sub x y) = eval x - eval y

pretty :: Expr -> String
pretty (Lit n) = show n
pretty (Add x y) = pretty x ++ "+" ++ pretty y
pretty (Mul x y) = pretty x ++ "*" ++ pretty y
pretty (Sub x y) = pretty x ++ "-" ++ pretty y

{-
(a) Define a function addTwo :: Int → Int Make sure you include the type annotation. It’s good practice! 
(b) Try passing the function a value of type Double, e.g. addTwo (3.5 :: Double). Why can this expression not be evaluated? 
(c) Change the definition of addTwo so it works for all types with a Num instance. Hint: You should only need to change the type annotation. 
(d) Generate a typeclass error by applying addTwo to a type that is not a member of the Num typeclass. 
(e) Check that your function works for both Int and Double.
-}

addTwo' :: Int -> Int
addTwo' = (+2)

-- 3.5 is not an int

addTwo :: Num a => a -> a
addTwo = (+2)

-- >>> addTwo 'c'
-- No instance for `Num Char' arising from a use of `addTwo'
-- In the expression: addTwo 'c'
-- In an equation for `it_aOsM': it_aOsM = addTwo 'c'

-- >>> addTwo 3
-- 5

-- >>> addTwo 3.5
-- 5.5

{-
Rock Paper Scissors 
(a) Define a type that represents the three possible choices a player can make: Rock, Paper, or Scissors. 
(b) Define an Eq instance for this type. 
(c) That was tedious! Imagine if we asked you do that for chess moves instead… Use the deriving keyword to do it for you instead. While you are at it, also derive a Show instance. 
(d) Define the function shoot :: RPS → RPS → Bool that adjudicates a two player game of rock paper scissors, resulting in True when player one wins and False when they draw or lose.
-}

data RPS = Rock | Paper | Scissors
    deriving (Eq, Show)

rpsEq :: RPS -> RPS -> Bool
rpsEq Rock Rock = True
rpsEq Paper Paper = True
rpsEq Scissors Scissors = True
rpsEq _ _ = False

-- >>> rpsEq Rock Scissors
-- False

-- >>> rpsEq Rock Rock
-- True

-- >>> show Rock
-- "Rock"

shoot :: RPS -> RPS -> Bool
shoot p1 p2
    | p1 Prelude.== Rock && p2 Prelude.== Scissors = True
    | p1 Prelude.== Scissors && p2 Prelude.== Paper = True
    | p1 Prelude.== Paper && p2 Prelude.== Rock = True
    | otherwise = False

-- >>> shoot Rock Rock
-- False

{-
Typeclass Laws 
(a) Define an Ord instance for your rock paper scissors type, such that if player1 ⩽ player2 is true, for some player1 :: RPS and player2 :: RPS, then either player2 won, or it’s a draw. 
(b) Typeclasses often come with its own laws — rules that outline what is expected of its instances. For example, instances of the Eq class are expected to statisfy the law of “reflexivity” which says that any value is equal to itself: (x == x) = True for any x. Check out the laws for the Ord typeclass here: https://hackage.haskell.org/package/base-4.18.1.0/docs/Data-Ord.html. Which of these laws does your Ord instance break? 
(c) Typeclass instances that do not behave lawfully can cause problems. For example, the sort :: Ord a ⇒ [a] → [a] function provided by Data.List assumes that the typeclass instance Ord a is lawful and may have unexpected behaviour if it is unlawful. Find an example where the unlawfulness of your Ord RPS instance causes problems.
-}

-- (<=) :: RPS -> RPS -> Bool
-- p1 <= p2 = not (shoot p1 p2)

-- >>> Rock Main.<= Scissors
-- False

-- Transitivity and antisymmetry

-- sort [Rock, Paper, Scissors] would be unlawful as the order of the elements creates a cycle
-- i.e. Rock <= Paper, Paper <= Scissors, Scissors <= Rock, so there is no 'smallest' and 'largest' element 

data Suit = Hearts | Diamonds | Clubs | Spades 
    deriving (Show, Eq)
type Pip = Int
type Rank = Either Pip Court
data Card = Joker | Card Suit Rank 
    deriving Show

{-
Define a datatype Court with constructors Ace, Jack, Queen, and King.
-}

data Court = Ace | Jack | Queen | King
    deriving (Show, Eq, Ord)

{-
Define the Eq instance for Cards (you may derive an Eq instance for Court, but define the one for Card by hand).
-}

(==) :: Card -> Card -> Bool
Joker == Joker = True
Card s1 r1 == Card s2 r2 = s1 Prelude.== s2 && r1 Prelude.== r2
_ == _ = False

-- >>> (Card Hearts (Left 1)) Main.== (Card Hearts (Left 1))
-- True

{-
Define the function snap :: Card → Card → String using pattern matching and guards. It should return "SNAP" if the rank of two cards match, regardless of their suits, and "..." otherwise.
-}

snap :: Card -> Card -> String
snap (Card _ r1) (Card _ r2) = if r1 Prelude.== r2 then "SNAP" else "..."
snap _ _ = "..."

-- >>> snap (Card Hearts (Left 1)) (Card Spades (Left 1))
-- "SNAP"

{-
Define the Ord instance for Cards (without deriving it, though you can derive Ord for Court, if and only if you’ve ordered the constructors from low to high) according to the following rules: 
    • Joker is the most valuable card. 
    • Spades are more valuable than any other suit. 
    • After Spades, Hearts are the most valuable suit. 
    • After that it is just the value of the card that is considered, with Aces being low.
-}

(<=) :: Card -> Card -> Bool
_ <= Joker = True
Joker <= Card _ _ = False
Card _ _ <= Card Spades _ = True
Card s _ <= Card Hearts _ = s /= Spades
Card Spades _ <= Card _ _ = False
Card Hearts _ <= Card _ _ = False
Card _ r1 <= Card _ r2 = r1 Prelude.<= r2 

-- >>> (Card Hearts (Left 1)) Main.<= Joker
-- True

-- >>> Joker Main.<= (Card Hearts (Left 1))
-- False

-- >>> (Card Hearts (Left 1)) Main.<= (Card Spades (Left 1))
-- True

-- >>> (Card Spades (Left 1)) Main.<= (Card Hearts (Left 1))
-- False

-- >>> (Card Spades (Left 1)) Main.<= (Card Clubs (Left 1))
-- False

-- >>> (Card Hearts (Left 1)) Main.<= (Card Clubs (Left 1))
-- False

-- >>> (Card Diamonds (Left 2)) Main.<= (Card Diamonds (Left 1))
-- False

-- >>> (Card Diamonds (Right Ace)) Main.<= (Card Diamonds (Right King))
-- True

-- >>> (Card Diamonds (Right King)) Main.<= (Card Diamonds (Right Ace))
-- False

{-
Imagine you are playing a simple card game where you have to play a card from your hand that is more valuable than a particular card on the table, if you can’t play a more valauble card you lose the game! 
Write a function play::[Card] → Card → Maybe Card that takes a list of cards in your hand and the card on the table and returns the first card in your hand that is more valuable than the one on the table, if it exists, and returns Nothing if you lose. 
For example, 
    play [Card Hearts (Left 2),Card Spades (Right King),Joker] (Card Spades (Left 3)) = Just (Card Spades (Right King)) 
    play [Card Clubs (Left 5)] Joker = Nothing
-}

play :: [Card] -> Card -> Maybe Card
play [] _ = Nothing
play (c:cs) tb
    | tb Main.<= c = Just c
    | otherwise = play cs tb

-- >>> play [Card Hearts (Left 2),Card Spades (Right King),Joker] (Card Spades (Left 3))
-- Just (Card Spades (Right King))

-- >>> play [Card Clubs (Left 5)] Joker
-- Nothing
