import Data.Char
{-A 'key' to store each roman numeral and its associated value-}
values :: [(String, Int)]
values = [("M", 1000), ("CM", 900), ("D",500), ("CD", 400), ("C",100), ("XC", 90),
 ("L", 50), ("XL",40), ("X",10), ("IX",9), ("V", 5), ("IV", 4), ("I", 1)]
 
returnStr :: [(String, Int)] -> [String]
{--Returns a list of the characters in the key-}
returnStr []  = []
returnStr(x:xs) = fst(x) : returnStr xs

returnVal :: String -> [(String,Int)] -> Int
{-Returns the associated value of the given string-}
returnVal [] _ = 0
returnVal _ [] = 0
returnVal x (y:ys)
 | x == fst(y) = snd(y)
 | otherwise = returnVal x ys
 
returnNextCharVal :: Int -> [(String, Int)] -> (String, Int)
{-Returns the Char,Value tuple of the largest value that is 
  smaller than the given integer-}
returnNextCharVal 0 _ = ("",0)
returnNextCharVal x (y:ys)
 | x >= snd(y) = y
 | otherwise = returnNextCharVal x ys

romanToInt :: String -> Int
romanToInt [] = 0
romanToInt [x] = returnVal [x] values
romanToInt (x1:x2:xs)
 {-Checks for pair of characters before single-}
 | [c1,c2] `elem` strs  = returnVal [c1,c2] values + romanToInt xs
 | [c1] `elem` strs = returnVal [c1] values + romanToInt (x2:xs)
 {-Case for invalid character-}
 | otherwise = 0 + romanToInt(x2:xs)
  where
   strs = returnStr values
   {-Converts to upper case using toUpper from Data.Char-}
   c1 = toUpper x1
   c2 = toUpper x2

intToRoman :: Int -> String
{-Subtracts the next biggest possible value from the total and 
  appends the associated character to a string-}
intToRoman 0 = ""
intToRoman n 
 | n > 0 = s ++ intToRoman(n - v)
 {-Check for negative value-}
 | otherwise = "Invalid value entered"
  where 
  (s,v) = returnNextCharVal n values
  
main :: IO()
main
 = do putStrLn(show(romanToInt "MCMXIX")) -- Will return 1919
      putStrLn(show(intToRoman 1805)) -- Will return "MDCCCV"