module StringMatchers where

class SMatcher x where
    matches :: String -> x -> Bool

{-
Exercise 1. Show that the predicate type String -> Bool has an instance of SMatcher.
-}

instance SMatcher (String -> Bool) where
    matches :: String -> (String -> Bool) -> Bool
    matches s f = f s

{-
The usual way to do match strings is with regular expressions. Here is a typical CFG for regular expressions (regex). It just says that a regular expression can be built up inductively in the following way: 
    • ε, which matches the empty string, is a regex. 
    • A regex can match for a single character 
    • Given two regexes r1 and r2, the expression r1 + r2 which matches for either r1 or r2 is a regex. 
    • Given two regex r1 and r2, the expression r2 · r2, which is their concatenation and matches for r1 followed by r2, is a regex. 
    • Given a regex r, the expression r∗, which matches for any number (even 0) of repetitions of matches for r, is a regex.
-}

data Regex
    = Empty
    | Match Char
    | Either Regex Regex
    | Conc Regex Regex
    | Kleene Regex

{-
Exercise 2. What strings should abstar match against? 
-}

abstar :: Regex
abstar = Kleene (Either (Match 'a') (Match 'b'))

-- corresponds to Regex (a|b)*

{-
Exercise 3. Implement a Show instance for Regex. If you aren’t sure what you need to do to implement this, check :i Show in ghci. You can implement it however you like, but if you need inspiration, you can use the CFG above.
-}

instance Show Regex where
    show Empty = ""
    show (Match c) = [c]
    show (Either r1 r2) = show r1 ++ "|" ++ show r2
    show (Conc r1 r2) = show r1 ++ show r2
    show (Kleene r) = "(" ++ show r ++ ")*"

-- >>> show (Kleene (Either (Match 'a') (Match 'b')))
-- "(a|b)*"

{-
Exercise 4. Write a function matchString :: String-> Regex which takes a string and creates a Regex which matches against exactly that string.
-}

matchString :: String -> Regex
matchString = foldr (Conc . Match) Empty

-- >>> matchString "hello"
-- hello

{-
Exercise 5. Implement splits :: [a]-> [([a], [a])], which for any list, gives all its possible splittings.
-}

splits :: [a] -> [([a], [a])]
splits [] = [([], [])]
splits (x:xs) = ([], x:xs) : map (\(a,b) -> (x:a, b)) (splits xs)

-- >>> splits [1..5]
-- [([],[1,2,3,4,5]),([1],[2,3,4,5]),([1,2],[3,4,5]),([1,2,3],[4,5]),([1,2,3,4],[5]),([1,2,3,4,5],[])]

{-
Exercise 6. Show that a Regex can be used to match against a string by implementing an instance of SMatcher.
-}

instance SMatcher Regex where
    matches :: String -> Regex -> Bool
    matches [] Empty = True
    matches [a] (Match b) = a == b
    matches s (Either a b) = matches s a || matches s b
    matches s (Conc a b) = or [ matches x a && matches y b | (x, y) <- splits s ]
    matches [] (Kleene r) = True
    matches s (Kleene r) = or [ matches x r && matches y (Kleene r) | not $ null s, (x, y) <- splits s ]
    matches _ _ = False

-- >>> matches "abab" abstar 
-- True

{-
Extension (DFA). A discrete finite automaton (DFA) consists of a set of states, one of which is “initial” and some subset of which is “final”, and a transition function between them: given a state and some input (in this case a character) it moves to another state.
-}

data DFA state = DFA { transition :: state -> Char -> state , initial :: state , final :: state -> Bool }

abstar' :: DFA Int
abstar' = DFA { initial = 1, final = \x -> x == 1 || x == 3, transition = abstarT }

abstarT :: Int -> Char -> Int
abstarT 1 'a' = 2
abstarT 2 'b' = 3
abstarT 3 'a' = 2
abstarT _ _ = 0 -- use 0 as junk state

{-
DFAs can also be used to match for strings. Show how you can implement an instance of SMatcher for DFA.
-}

mhelper :: String -> state -> DFA state -> Bool
mhelper [] currState dfa = final dfa currState
mhelper (x:xs) currState dfa = mhelper xs (transition dfa currState x) dfa 

instance SMatcher (DFA state) where
    matches :: String -> DFA state -> Bool
    matches s dfa = mhelper s (initial dfa) dfa

-- >>> matches "ab" abstar'
-- True