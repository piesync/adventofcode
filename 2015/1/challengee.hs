a :: [Char] -> Int
a = foldr move 0

move :: Char -> Int -> Int
move '(' = succ
move ')' = pred
move _   = id
