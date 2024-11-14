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
-- add2 l = map (\x -> x + 2) l
-- add2 l = map (+2) l 

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
-- negateAll l = map not l

-- Legyen adott egy h függvényt:
h :: Num a => Bool -> a
h True = 1
h False = 0

-- Definiáld a hAll függvényt, amely egy Bool-ok listáját átalakítja számok listájává.
hAll :: Num a => [Bool] -> [a]
hAll [] = []
hAll (x:xs) = h x : hAll xs
-- hAll l = map h l
  -- where
    -- h True = 1
    -- h False = 0

-- Aki esetleg unja már, mi lenne jó, ha mit tudnánk ezek helyett csinálni?
-- Aki még nem unja, van még ∞+1 ilyen feladat.

-- Általánosítsuk az ötletet!
-- Mi lesz a típusa? Hogyan fog a típusban meglátszódni, hogy mi kell nekünk?
map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs

-- Definiáld a map'' függvényt listagenerátorral!
map'' :: (a -> b) -> [a] -> [b]
map'' f l = [f x | x <- l]

-- Definíció:
-- Lambda-függvény: Névtelen függvény.

-- Szintaxisa: (\ <1. paraméter neve> <2. paraméter neve> ... <n. paraméter neve> -> <kifejezés>)
-- ahol a paraméterek neveire ugyanaz a szabály vonatkozik, mint a sima függvényekben, tehát kisbetűvel kezdődnek.

foo :: Int -> (Int -> Int)
foo x = (+) x

------------------------------
-- Milyen más függvényeket lehet még így általánosítani?
-- Nézzünk ezekre is példát.

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

-- Itt is lehetne még sok példafeladatot felírni, de az előzőek alapján remélhetőleg érthető, hogy mi a cél.

-- Definiáld a filter' függvényt, amely adott tulajdonsággal rendelkező elemeket tart meg a listából.
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
  | p x = x : filter' p xs
  | otherwise = filter' p xs

-- Definiáld a filter'' függvényt listagenerátorral.
filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p l = [x | x <- l, p x]

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

-- Definiáld az app2ToFunctions függvényt magasabb rendű függvényeket használva rekurzió nélkül, amely alkalmazza a 2-es értéket egy függvényeket tartalmazó lista minden függvényén.
app2ToFunctions :: Num a => [a -> b] -> [b]
app2ToFunctions = undefined

-- Definiáld a span' függvényt, amely kettébont egy listát ott, ahol egy adott tulajdonság már nem teljesül.
-- span' even [2,4,6,1,2,3,4] == ([2,4,6],[1,2,3,4])
-- span' (> 0) [5,4,3,2,1,0,-1,-2,-3] == ([5,4,3,2,1],[0,-1,-2,-3])
-- span' (< 0) [1,2,3,4] == ([],[1,2,3,4])
-- span' (> 0) [1,2,3,4] == ([1,2,3,4],[])
span' :: undefined
span' = undefined

-- Definiáld a takeWhile' függvényt, amely egy lista elejéről addig tartja meg az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
takeWhile' :: undefined
takeWhile' = undefined

-- Definiáld a dropWhile' függvényt, amely egy lista elejéről addig dobálja el az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
dropWhile' :: undefined
dropWhile' = undefined

-- Definiáld a find' függvényt, amely visszaadja az első adott tulajdonságú elemet egy listából, ha létezik olyan.
find' :: undefined
find' = undefined
-- Az eredeti függvény a Data.List-ben található.

-- Definiáld az findIndex' függvényt, amely visszaadja az első adott tulajdonságú elem indexét egy listából, ha létezik olyan.
-- Megj.: Ugyan fel lehet használni az előző függvényt erre, de nem célszerű.
findIndex' :: undefined
findIndex' = undefined