module Lesson10 where

-- Sok függvény (magasabb rendűek is) hasznos a parciális applikálással, vegyük például az alábbiakat.

-- Definiáld az id' függvényt, amely a paraméterét csak visszaadja eredményül.
id' :: a -> a
id' x = x

-- Definiáld a const' függvényt, amely egy két paraméteres függvény első paraméterét adja vissza eredményül mindig.
const' :: a -> b -> a
const' x _ = x 

-- Definiáld a flip' függvényt, amely egy két paraméteres függvényt paramétereit felcseréli!
flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y

-- Add meg a const2' függvényt, most a flip felhasználásával!
const2' :: a -> b -> b
const2' x y = flip' const' x y

-- Definiáld a curry' függvényt, amely egy rendezett párt váró függvény paraméterét szétbontja két önálló paraméterre.
curry' :: ((a, b) -> c) -> a -> b -> c
curry' f x y = f (x, y)

-- Definiáld az uncurry' függvényt, amely egy két paraméteres függvényt átalakít egy rendezett párt váró függvénnyé!
uncurry' :: (a -> b -> c) -> (a, b) -> c
uncurry' f (x, y) = f x y

-- Definiáld az iterate' függvényt, amely egy végtelen listát állít elő úgy, hogy folyamatosan alkalmaz egy függvényt egy értéken,
-- és az egyes részeredményeket adjuk vissza a listában.
-- take 10 (iterate' (+1) 0) == [0,1,2,3,4,5,6,7,8,9]
-- take 10 (iterate' not True) == [True,False,True,False,True,False,True,False,True,False]
iterate' :: (a -> a) -> a -> [a]
iterate' f e = e : iterate' f (f e)

-- Definiáld a repeat' függvényt az iterate' felhasználásával!
repeat' :: a -> [a]
repeat' e = iterate' id' e

{-
A funkcionális programozás erőssége a függvények komponálhatósága, egymás utáni alkalmazása.
Ehhez azonban szükségünk van magára erre a függvényre, amely két függvényt komponál ezzel létrehozva egy új függvényt.
A definíciója ugyanaz, mint matematikában, analízisben.
-}
(∘) :: (b -> c) -> (a -> b) -> a -> c
(∘) g f x = g (f x)
infixr 9 ∘
-- Az eredeti függvény neve (.)

-- Az alábbi feladatokban használjunk függvénykompozíciót!

-- Definiáld azt a függvényt, amely az [1,11,111,1111,11111,...] végtelen listát állítja elő.
numbersMadeOfOnes :: [Integer]
numbersMadeOfOnes = iterate' ((+1) . (*10)) 1 

-- Definiáld azt a függvényt, amely a [3,33,333,3333,33333,...] végtelen listát állítja elő.
numbersMadeOfThrees :: [Integer]
numbersMadeOfThrees = iterate' ((+3) . (*10)) 3

-- Definiáld azt a függvényt, amely az [1,31,331,3331,33331,...] végtelen listát állítja elő.
numbersMadeOfThreesAndOne :: [Integer]
numbersMadeOfThreesAndOne = iterate' ((+1) . (*10) . (+2)) 1
-- numbersMadeOfThreesAndOne = iterate' ((+21) . (*10)) 1

{-
Mivel Haskellben lehetséges a parciális applikálás, lehetséges, hogy a függvényeinket kompozíciókként adjuk meg a paraméterek felvétele nélkül.
pl.

times2plus1 :: Num a => a -> a
times2plus1 x = 2 * x + 1

helyett tudjuk azt, hogy ez a művelet valójában csak két függvény kompozíciójából áll és tudjuk úgy definiálni, hogy:

times2plus1 = (+1) . (2*)
és a két függvény teljesen ugyanaz.

Először a számot meg kell szorozni kettővel, majd utána hozzá kell adni egyet.
A kompozíció matematikai érdekessége, hogy míg mi természetes módon balról jobbra olvasunk, addig a kompozíciókat jobbról balra kell olvasni
annak tekintetében, hogy mit csinál először és mit csinál utána. (Tehát a kompozíció művelete jobbra köt.)

Amikor nem veszünk fel paramétereket és úgy definiálunk függvényeket, azt szokás pointfree stílusnak nevezni.
-- SZÉP KÓD: Addig, amíg nem kell függvénykompozíciókat hegyén hátán használni, próbáljuk meg definiálni a függvényeket minél kevesebb paraméterfelvétellel.
             Meglepően tisztább és olvashatóbb lesz a kód.
Ezt egy példán keresztül megmutatva:
-}
-- Definiáld az any függvényt kétféleképpen. Az any ellenőrzi, hogy egy adott tulajdonságú elem megtalálható-e egy listában.
-- Segítség: Használd az or és a map függvényt a rövid definíció érdekében. Ne használj rekurziót és elágazást.
--           Az or függvény egy listányi Bool-t összevagyol.

-- Vegyük fel az összes paramétert!
any' :: (a -> Bool) -> [a] -> Bool
any' f l = or (map f l)

-- Csak az első paramétert vegyük fel! (Megj.: Olyan nincs, hogy csak a második paramétert vegyük fel.)
any'' :: (a -> Bool) -> [a] -> Bool
any'' f = or . map f

-- any''' = (or .) . map
-- A két definíció közül melyik a legrövidebb, de annyira, hogy a kódjának az értelmezése még intuitív maradjon?

-- Feladatok:

-- Definiáld a dropSpaces függvényt, amely eldobja csak a szóközöket egy szöveg elejéről.
dropSpaces :: String -> String
dropSpaces = dropWhile (==' ')

-- Definiáld a trim függvényt, amely eldobja csak a szóközöket egy szöveg elejéről és végéről.
trim :: String -> String
trim = reverse . dropSpaces . reverse . dropSpaces

-- Definiáld a maximumOfMinimums függvényt! Adott egy listák listája. Keressük meg a legnagyobb elemet a legkisebbek közül.
maximumOfMinimums :: undefined
maximumOfMinimums = undefined

-- Definiáld a mapMap függvényt, amely alkalmaz egy függvényt listák listájában levő elemekre!
mapMap :: undefined
mapMap = undefined

-- Adjuk meg egy névnek a kezdőbetűit, azokat szóközökkel elválasztva!
firstLetters :: undefined
firstLetters = undefined

-- Adjuk meg egy név monogramját! A monogram abban különbözik, hogy pont is van a kezdőbetűk után; minden más része ugyanaz, mint az előző feladatnak!
monogram :: undefined
monogram = undefined

-- Definiáld a sublists függvényt, amely visszaadja egy lista minden lehetséges részsorozatát.
-- Részsorozatnak tekintjük a közvetlen egymást követő elemeket az eredeti listában.
-- Pl. "abcd"-nek részsorozata a "bc", de az "acd" nem.
sublists :: undefined
sublists = undefined

-- Definiáld az until' függvényt, amely addig ismétel egy műveletet egy értéken, amíg az eredményre egy adott tulajdonság nem teljesül.
-- Az eredmény az első olyan érték, amire teljesül a feltétel.
-- Definiáljuk rekurzívan és magasabb rendű függvényekkel is!
-- until' (\x -> x `mod` 5 == 0) (+2) 1 == 5
-- until' (\x -> x `mod` 5 == 0) (+9) 5 == 5
-- until' isLower succ 'A' == 'a'
-- until' isLower succ 'B' == 'a'
until' :: undefined
until' = undefined

until'' :: undefined
until'' = undefined
