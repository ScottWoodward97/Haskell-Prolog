import Data.List
values :: [Int]
values = [1..9]

searchlists :: (Int, Int, Int, Int) -> [[Int]] -> [Int]
searchlists _ [] = []
{-Function returns the first combination that matches the criteria-}
searchlists (a,b,c,d) (x:xs)
 | x!!0 + x!!1 + x!!3 + x!!4 == a &&
 x!!1 + x!!2 + x!!4 + x!!5 == b &&
 x!!3 + x!!4 + x!!6 + x!!7 == c &&
 x!!4 + x!!5 + x!!7 + x!!8 == d = x
 | otherwise = searchlists (a,b,c,d) xs
 
suko :: (Int, Int, Int, Int) -> [Int]
suko(a,b,c,d)
{-Guards against impossible values, max possible value is 30, min is 10-}
{-Uses permutations from Data.List to generate all possible combinations of 1-9-}
 | and (map (`elem` [10..30]) [a,b,c,d]) = searchlists (a,b,c,d) (permutations values)
 | otherwise = []
 
main :: IO()
main
 = do putStrLn(show(suko(22,21,22,13))) -- Will return [4,6,5,9,3,7,8,2,1]
      putStrLn(show(suko(21,15,21,13))) -- Will return [8,5,3,7,1,6,9,4,2]