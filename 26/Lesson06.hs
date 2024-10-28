module Lesson06 where

-- tails' [1,2,3] == [[1,2,3],[2,3],[3],[]]
-- tails' "abcd" == ["abcd","bcd","cd","d",""]
-- [1,2,3] : [2,3] : [3] : [[]]
tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' l@(_:xs) = l : tails' xs

-- inits' [1,2,3] == [[],[1],[1,2],[1,2,3]]
-- inits' "ab" == ["","a","ab"]
-- inits' [5,10,9,1,0] == [[],[5],[5,10],[5,10,9],[5,10,9,1],[5,10,9,1,0]]
-- segitseg: init fg a rekurzio soran, ++, rekurziv operator elem
-- [[]] ++ [[1]] ++ [[1,2]] ++ [[1,2,3]]
inits' :: [a] -> [[a]]
inits' [] = [[]]
inits' l = inits' (init l) ++ [l]

quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort [y | y <- xs, y <= x] ++ [x] ++  quickSort [y | y <- xs, y > x]

-- seged fg: merge, split, rekurzio
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort list = merge (mergeSort left) (mergeSort right)
  where
    (left, right) = split list
    split [] = ([], [])
    split [x] = ([x], [])
    split (x:y:xs) = let (l, r) = split xs in (x:l, y:r)
    merge [] r = r
    merge l [] = l
    merge l@(x:xs) r@(y:ys)
      | x <= y = x : merge xs r
      | otherwise = y : merge l ys

-- deletions [1,2,3] == [[2,3],[1,3],[1,2]]
-- deletions "alma" == ["lma","ama","ala","alm"]
-- segitseg: lista kifejezes es rekurzio
-- [2,3] : [1,3] : [1,2] : [] 
deletions :: [a] -> [[a]]
deletions [] = []
deletions (x:xs) = xs : [x:y | y <- deletions xs]

-- insertions 1 [] == [[1]]
-- insertions 0 [1,2,3] == [[0,1,2,3],[1,0,2,3],[1,2,0,3],[1,2,3,0]]
-- insertions 'a' "sdfg" == ["asdfg","sadfg","sdafg","sdfag","sdfga"]
-- segitseg: lista kifejezes es rekurzio
insertions :: a -> [a] -> [[a]]
insertions e [] = [[e]]
insertions e l@(x:xs) = (e:l) : [x:y | y <- insertions e xs]