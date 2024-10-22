module Lesson07 where

-- Definiáld a deletions függvényt, amely egy elemet töröl egy listából az összes lehetséges módon!
-- deletions [1,2,3] == [[2,3],[1,3],[1,2]]
-- deletions "alma" == ["lma","ama","ala","alm"]
deletions :: [a] -> [[a]]
deletions [] = []
deletions (x:xs) = xs : [x:y | y <- deletions xs]

-- Definiáld az insertions függvényt, amely beszúr egy elemet egy listába az összes lehetséges módon!
-- insertions 1 [] == [[1]]
-- insertions 0 [1,2,3] == [[0,1,2,3],[1,0,2,3],[1,2,0,3],[1,2,3,0]]
-- insertions 'a' "sdfg" == ["asdfg","sadfg","sdafg","sdfag","sdfga"]
insertions :: a -> [a] -> [[a]]
insertions e [] = [[e]]
insertions e l@(x:xs) = (e:l) : [x:y | y <- insertions e xs]

-------------------------
-- Típusszinonimák
-------------------------

-- Típusszinonimák szintaxisa az alábbiként néz ki Haskellben:
-- type <Típusnév> [típusparaméterek...] = <Létező típus>
-- type String = [Char]

-- Feladatok:
-- Definiáld a Point típusszinonimát, amely jelöljön egy Integer-ekből álló rendezett párt.

type Point = (Integer, Integer)

-- Definiáld a moveX függvényt, amely egy pontot az X-tengely mentén eltol egy adott értékkel.
-- Használjuk az előbb definiált Point típust.
moveX :: Integer -> Point -> Point
moveX n (x, y) = (x + n, y)

type Name = String
type BirthDay = String
type Address = String
type Age = Int
type Person = (Name, BirthDay, Address, Age)

person :: Person
person = ("Csiki Erik", "1998-06-18", "Budapest", 26)

type Euro = Int

foo :: Euro -> Age -> Int
foo euro age = euro + age

------------------------------
-- Saját típus: data
------------------------------

-- data <Típusnév> [típusparaméterek...] = Kontruktor [típusparaméterek...] | Kontruktor2 [típusparaméterek...] | ..

-- Feladatok:
-- Definiáld a Day típust, amelynek 7 paraméter nélküli konstruktora van: Mon, Tue, Wed, Thu, Fri, Sat, Sun.

data Day = Mon | Tue | Wed | Thu | Fri | Sat | Sun
  deriving Show 

-- Segítség: Konstruktorokkal mit lehet csinálni?
nextDay :: Day -> Day
nextDay Mon = Tue
nextDay Tue = Wed
nextDay Wed = Thu
nextDay Thu = Fri
nextDay Fri = Sat
nextDay Sat = Sun
nextDay Sun = Mon

-- Példányosítsuk kézzel az Eq osztályt a Day típusra!
-- instance <Tipusosztaly> <Tipus> where

instance Eq Day where
    (==) Mon Mon = True
    (==) Tue Tue = True
    (==) Wed Wed = True
    (==) Thu Thu = True
    (==) Fri Fri = True
    (==) Sat Sat = True
    (==) Sun Sun = True
    (==) _ _ = False

------------------------------------------
-- Paraméteres konstruktorok
------------------------------------------

-- Definiáld a Fruit típust, amelynek legyen három konstruktora: Grape, Apple, Pear.
-- Ez után definiáld a FruitBatch típust, amelynek egy konstruktora van: FruitBatch, és ennek a konstruktornak két paramétere van, egy Fruit és egy Integer.

data Fruit = Grape | Apple | Pear
  deriving Show

data FruitBatch = FruitBatch Fruit Integer
  deriving Show

-- Definiáld a sumFruits függvényt, amely megszámolja egy listányi FruitBatch-ben, hogy hány darab gyümölcsünk van.
-- Nem válogatjuk külön a gyümölcsöket, csak a gyümölcsök száma az érdekes összesen.
sumFruits :: [FruitBatch] -> Integer
sumFruits [] = 0
sumFruits (FruitBatch _ n:xs) = n + sumFruits xs

-- Definiáld az sumDifferentFruits függvényt, amely összeadja egy listányi FruitBatch-ben, hogy a különböző gyümölcsökből hány darabunk van.
-- Ez előtt tegyük egy kicsit beszédesebbé a típust. Definiálj 3 típusszinonimát Integer-re: NumberOfApples', NumberOfGrapes', NumberOfPears'

type NumberOfApples' = Integer
type NumberOfGrapes' = Integer
type NumberOfPears' = Integer

sumDifferentFruits :: [FruitBatch] -> (NumberOfApples',NumberOfGrapes',NumberOfPears')
sumDifferentFruits [] = (0, 0, 0)
sumDifferentFruits (x:xs) = (a + as, g + gs, p + ps)
  where
    (as, gs, ps) = sumDifferentFruits xs
    (a, g, p) = getFruit x
    getFruit (FruitBatch Apple n) = (n, 0, 0)
    getFruit (FruitBatch Grape n) = (0, n, 0)
    getFruit (FruitBatch Pear n) = (0, 0, n)

-- Ennek egy megoldása ugyan egyszerű, de körülményes.
-- Definiáld a NumberOfApples, NumberOfGrapes, NumberOfPears típusokat, mindhárom típusnak legyen egy konstruktora a típussal azonos névvel, azoknak egy Integer paramétere.
-- A fenti három típus legyen a Num osztály példánya és a műveletek működjenek pontosan ugyanúgy, mint az Integer-en.

-- Definiáljuk újra a sumDifferentFruits' függvényt a helyes típussal. (Most már nehezebben lesz lehetséges összeadni az almákat a körtékkel, természetesen még mindig lehet.)
--sumDifferentFruits' :: [FruitBatch] -> (NumberOfApples,NumberOfGrapes,NumberOfPears)
sumDifferentFruits' = undefined
