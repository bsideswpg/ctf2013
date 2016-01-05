import System.Environment
import Data.Char
import Data.List

scramble str = transpose $ map (\tup -> [fst tup, snd tup]) [ (if even x then x^3 else x, x^2) | x <- (reverse $ map ord str) ]

scrambled_flag =
  [
    [115,1481544,51,107,99,97,1124864,95,103,1331000,105,1331000,111,
     105,55,99,1331000,117,1061208,95,1124864,103,105,1124864],

    [13225,12996,2601,11449,9801,9409,10816,9025,10609,12100,11025,
     12100,12321,11025,3025,9801,12100,13689,10404,9025,10816,10609,11025,10816]
  ]

main = do
  args <- getArgs
  if scrambled_flag == (scramble $ head args) then
    putStrLn "Win!"
  else
    putStrLn "Lose!"
