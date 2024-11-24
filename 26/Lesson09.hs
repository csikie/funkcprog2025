module Lesson09 where

-----------------------------------------------------
-- Magasabb rendű függvények (Higher order functions)
-----------------------------------------------------

import Data.Char

-- Motivációként csináld meg az alábbi feladatokat:
-- Definiáld az add2 függvényt, amely egy lista minden eleméhez hozzáad 2-t.
add2 :: Num a => [a] -> [a]
add2 [] = []
add2 (x:xs) = x + 2 : add2 xs

-- Definiáld a mul2 függvényt, amely egy lista minden elemét megszorozza 2-vel.
mul2 :: Num a => [a] -> [a]
mul2 [] = []
mul2 (x:xs) = x * 2 : add2 xs

-- Definiáld a toUpperAll függvényt, amely egy szöveg minden karakterét nagybetűsíti.
toUpperAll :: String -> String
toUpperAll [] = []
toUpperAll (x:xs) = toUpper x : toUpperAll xs

-- Definiáld a negateAll függvényt, amely egy Bool-ok listájának minden elemét negálja.
negateAll :: [Bool] -> [Bool]
negateAll [] = []
negateAll (x:xs) = not x : negateAll xs

-- Legyen adott egy h függvényt:
h :: Num a => Bool -> a
h True = 1
h False = 0

-- Definiáld a hAll függvényt, amely egy Bool-ok listáját átalakítja számok listájává.
hAll :: Num a => [Bool] -> [a]
hAll [] = []
hAll (x:xs) = h x : hAll xs

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

-- Definiáld a map'' függvényt listagenerátorral!
map'' :: (a -> b) -> [a] -> [b]
map'' f l = [f x | x <- l]

-- Definiáld a moreThan2 függvényt rekurzívan, amely egy számokat tartalmazó listából megtartja a 2-nél nagyobbakat.
moreThan2 :: (Num a, Ord a) => [a] -> [a]
moreThan2 [] = []
moreThan2 (x:xs)
  | x > 2 = x : moreThan2 xs
  | otherwise = moreThan2 xs

-- Definiáld az onlyLower függvényt rekurzívan, amely egy szövegből csak a kisbetűket tartja meg.
onlyLower :: String -> String
onlyLower [] = []
onlyLower (x:xs)
  | isLower x = x : onlyLower xs
  | otherwise = onlyLower xs

-- Definiáld a filter' függvényt, amely adott tulajdonsággal rendelkező elemeket tart meg a listából.
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
  | p x = x : filter' p xs
  | otherwise = filter' p xs

-- Definiáld a filter'' függvényt listagenerátorral.
filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p l = [x | x <- l, p x]

-- Definíció:
-- Lambda-függvény: Névtelen függvény.

-- Szintaxisa: (\ <1. paraméter neve> <2. paraméter neve> ... <n. paraméter neve> -> <kifejezés>)
-- ahol a paraméterek neveire ugyanaz a szabály vonatkozik, mint a sima függvényekben, tehát kisbetűvel kezdődnek.

{-
foo :: Int -> (Int -> Int)
foo x = (+) x

-}

-- Definiáld a mapFilter függvényt rekurzívan és listagenerátorral. Csak azon elemekre alkalmazzuk a map-ot, amelyek a szűrés után megmaradtak.
-- Melyiket kényelmesebb definiálni?
mapFilter :: (a -> b) -> (a -> Bool) -> [a] -> [b]
mapFilter _ _ [] = []
mapFilter f p (x:xs)
  | p x = f x : mapFilter f p xs
  | otherwise = mapFilter f p xs 

mapFilter' :: (a -> b) -> (a -> Bool) -> [a] -> [b]
mapFilter' f p l = [f x | x <- l, p x]

-- Definíció:
-- Parciális applikálás/függvényalkalmazás: A függvénynek átadok legalább egy paramétert, de nem az összeset, így az alkalmazás eredménye egy másik függvény lesz.
-- Totális applikálás/függvényalkalmazás: A függvénynek átadjuk az összes szükséges paraméterét, hogy az eredménye egy konkrét érték legyen, amely nem függvény.

-- Definiáld a span' függvényt, amely kettébont egy listát ott, ahol egy adott tulajdonság már nem teljesül.
-- span' even [2,4,6,1,2,3,4] == ([2,4,6],[1,2,3,4])
-- span' (> 0) [5,4,3,2,1,0,-1,-2,-3] == ([5,4,3,2,1],[0,-1,-2,-3])
-- span' (< 0) [1,2,3,4] == ([],[1,2,3,4])
-- span' (> 0) [1,2,3,4] == ([1,2,3,4],[])
span' :: (a -> Bool) -> [a] -> ([a], [a])
span' _ [] = ([], [])
span' p (x:xs)
  | p x = (x:as, bs)
  | otherwise = (as, x:bs)
  where (as, bs) = span' p xs 

-- Definiáld a takeWhile' függvényt, amely egy lista elejéről addig tartja meg az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' p (x:xs)
  | p x = x : takeWhile' p xs
  | otherwise = []

-- Definiáld a dropWhile' függvényt, amely egy lista elejéről addig dobálja el az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' p l@(x:xs)
  | p x = dropWhile' p xs
  | otherwise = l

-- Definiáld a find' függvényt, amely visszaadja az első adott tulajdonságú elemet egy listából, ha létezik olyan.
find' :: (a -> Bool) -> [a] -> Maybe a
find' _ [] = Nothing
find' p (x:xs)
  | p x = Just x
  | otherwise = find' p xs
-- Az eredeti függvény a Data.List-ben található.

-- Definiáld az findIndex' függvényt, amely visszaadja az első adott tulajdonságú elem indexét egy listából, ha létezik olyan.
-- Megj.: Ugyan fel lehet használni az előző függvényt erre, de nem célszerű.
findIndex' :: (a -> Bool) -> [a] -> Maybe Int
findIndex' p l = helper p l 0
  where
    helper _ [] _ = Nothing
    helper p (x:xs) n
      | p x = Just n
      | otherwise = helper p xs (n+1)

-- Definiáld a ($$) függvényt, amely egy függvényt alkalmaz egy értékre.
infixr 0 $$
($$) :: (a -> b) -> a -> b
($$) f x = f x
-- Az eredeti függvény a ($).

{-
addMaybe :: Maybe Int ->  Maybe Int ->  Maybe Int
addMaybe _ Nothing = Nothing
addMaybe Nothing _ = Nothing
addMaybe (Just x) (Just y) = Just $ x + y
-}

-- Definiáld az app2ToFunctions függvényt magasabb rendű függvényeket használva rekurzió nélkül, amely alkalmazza a 2-es értéket egy függvényeket tartalmazó lista minden függvényén.
app2ToFunctions :: Num a => [a -> b] -> [b]
app2ToFunctions l = map ($ 2) l