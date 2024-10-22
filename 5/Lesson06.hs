module Lesson06 where

---------------------------------------
-- Elágazások
---------------------------------------

{-
fact n
  | ide valami logikai kif = eredmeny
  | ... = ...
  | ... = ...
fact 2
  | .. =..
-}

fact n
-- < =
  | n < 1 = 1
  | otherwise = n * fact (n-1)

-- Adott az alábbi függvény:
f :: [Integer] -> Integer
f [2,4,6,x]
    | x > 10 = 0
    | x < 0  = 1
f [x,y]
    | x + y > 10 = x * y
    | x - y < 10 = 2
f (x:xs)
    | x > 0 || x < 0 = f xs
f [] = -100
-- GHCi-ben való futtatás nélkül az alábbi kifejezéseknek mi lesz az eredményük?
-- f [2,4,6,11] == 0
-- f [2,4,6,-8] == -1
-- f [2,4,6,8] == 48
-- f [1,2,4,6,11] == 0
-- f [1,2,3,4] == 2
-- f [-3,-2,9] == 2
-- f [0,11] == 0
-- f [0,11,15,-2] == Non-exhaustive patterns in function f
-- f [2] == -100
-- f [0] == Non-exhaustive patterns in function f

-- Feladatok:
-- Definiáld a take' függvényt, amely adott darabszámú elemet megtart egy lista elejéről.
-- Ha több elemet kéne megtartani, mint amennyi van, akkor tartsuk meg az összeset.
-- Ha a szám negatív, kezeljük úgy, mintha 0 lenne.
-- Mi lesz a függvény legáltalánosabb típusa?
take' :: (Num a, Ord a) => a -> [b] -> [b]
take' _ [] = [] 
take' n (x:xs)
  | n <= 0 = []
  | otherwise = x : take' (n-1) xs

-- Definiáld a drop' függvényt, amely adott darabszámú elemet eldob egy lista elejéről.
-- Ha több elemet kéne eldobni, mint amennyi van, akkor dobjuk el az összeset.
-- Ha a szám negatív, kezeljük úgy, mintha 0 lenne.
-- Mi lesz a függvény legáltalánosabb típusa?
drop' :: (Num a, Ord a) => a -> [b] -> [b]
drop' _ [] = []
drop' n l@(x:xs)
  | n <= 0 = l
  | otherwise = drop' (n-1) xs

-- Definiáld a replicate' függvényt, amely adott darabszámú azonos elemet generál.
-- Ha a szám negatív, azt kezeljük úgy, mintha 0 lenne.
-- Mi lesz a függvény legáltalánosabb típusa?
replicate' :: Integral a => a -> b -> [b]
replicate' n e
  | n <= 0 = []
  | otherwise = e : replicate' (n-1) e

-- Nehezebb rekurziok

-- tails' "abc" == ["abc","bc","c",""]
tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' (x:xs) = (x:xs) : tails' xs

-- init, ++
-- inits "abc" == ["","a","ab","abc"]
inits' :: [a] -> [[a]]
inits' [] = [[]]
inits' l@(x:xs) = inits' (init l) ++ [l]

-- Definiáld a quickSort függvényt, amely a quick sort műveletét végzi el, azon módszerrel rendezi a lista elemeit.
-- A quick sort úgy rendezi az elemeket, hogy először választunk egy összehasonlítási pontot, értéket (angolul "pivot"),
-- és az összes elemet ezen elemhez képest rendezzük. Az attól kisebbek balra, az attól nagyobb vagy egyenlők pedig jobbra lesznek; magát a pivot-ot pedig a két rész közé helyezzük.
-- Az így keletkezett két részt természetesen ugyanúgy rendezni kell az azonos algoritmussal.
-- A "pivot" az első elem legyen, láncolt lista esetén az a legegyszerűbb választás.
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort l@(x:xs) = quickSort [y | y <- xs, y <= x] ++ [x] ++ quickSort [y | y <- xs, y > x]

-- split, merge seged fg-ek
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort l = merge (mergeSort left) (mergeSort right)
  where
    (left, right) = split l
    split [] = ([], [])
    split [x] = ([x], [])
    split (x:y:xs) = let (l,r) = split xs in (x:l, y:r)
    merge z [] = z
    merge [] z = z
    merge l@(a:as) r@(b:bs)
      | a <= b = a : merge as r
      | otherwise = b : merge l bs