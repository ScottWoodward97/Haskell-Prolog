import Data.Char
{-A list of words, must be strictly lowercase-}
dictionary :: [String]
dictionary = ["cold", "rabbit", "shoe", "board", "ass", "pie", 
	"bad", "and","cat", "or", "wit", "orange", "paint", "dog"]

split :: String -> (String, String)
{-Splits a word into a binary alternade-}
split [] = ([],[])
split [e] = ([e], [])
split (x1:x2:xs)
{-Converts to lowercase to prevent false negatives-}
 = ((toLower x1):ls, (toLower x2):rs)
  where
   (ls, rs) = split xs

alternade :: String -> [String] -> Bool
alternade x d 
{-Searches a list of words for the alternades-}
 = and (map (`elem` d) [a,b])
  where
  (a,b) = split x
  
main :: IO()
main
 = do putStrLn(show(alternade "pained" dictionary)) --Will return  True
      putStrLn(show(alternade "muppet" dictionary)) -- Will return False