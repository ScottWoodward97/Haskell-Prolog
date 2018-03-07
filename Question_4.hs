import Data.List
grid :: [String]
-- Only upper case allowed
grid = ["IUPGRADEEPEQ", "YTDZMTZVNRXS", "YVCECTIWALZR",
 "PCPGERSWGCRE", "PGLUDVDUCFNS", "ONTDJRRWDFOY", "LVRGAXAIYFKZ",
 "FAUHBGSXTELI", "HEGSPKHWYPOC", "TESZEBABIDKY", "NZWTUROHOIPK",
 "MXTGEADGAVLU", "TESSRMEMORYO", "DIQDTROMTKSL", "IRCTLAPTOPOX"]
 
searchwords :: [String]
-- Only upper case allowed
searchwords = ["LAPTOP", "KEYBOARD", "BUGS", "DISKETTE", "UPGRADE", "MEMORY",
 "HARDWARE", "FLOPPY", "HARDDRIVE", "SOFTWARE", "HELLO"]
 
reversegrid :: [String] -> [String]
{-Will reverse each indivdual row of the grid-}
reversegrid [] = []
reversegrid (x:xs) = reverse x : reversegrid xs
 
{- From the Data.Universe Haskell Package. Diagonalises a matrix-}
diagonals = tail . go [] where
 go b es_ = [h | h:_ <- b] : case es_ of
  []   -> transpose ts
  e:es -> go (e:ts) es
  where ts = [t | _:t <- b]
{- https://hackage.haskell.org/package/universe-base-1.0.2.1/docs/src/Data-Universe-Helpers.html#diagonals -}
  
wordsearch :: [String] -> [String] -> [String]
wordsearch [] _ = []
wordsearch (w:ws) g = findword w g : wordsearch ws g  
  
findword :: String -> [String] -> String
{-Searches each possible direction, returns word and direction it appears-}
findword w g
 | search w g = w ++ " right"
 | search w (reversegrid g) = w ++ " back"
 | search w tg = w ++ " down"
 | search w (reversegrid tg) = w ++ " up"
 | search w dg = w ++ " upright"
 | search w (reversegrid dg) = w ++ " downleft"
 | search w drg = w ++ " upleft"
 | search w (reversegrid drg) = w ++ " downright"
 | otherwise = w ++ " is not in grid"
 where
  tg = transpose g
  dg = diagonals g
  drg = diagonals (reverse g)
 
search :: String -> [String] -> Bool
{-Using 'isInfixOf' from the Data.List library-}
search w (ls:lss)
 | isInfixOf w ls = True
 | lss == [] = False
 | otherwise = search w lss
 
printAll :: [String] -> IO()
{-Function to print each item in a list-}
printAll [] = return ()
printAll (x:xs) 
 = do putStrLn x 
      printAll xs

main :: IO()
main
 = printAll(wordsearch searchwords grid)