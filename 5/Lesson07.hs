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

-- A függvény írása közben esetleg tapasztalható, hogy senki nem állít meg abban, hogy az almát hozzáadjam a körtékhez.
-- Ennek egy megoldása ugyan egyszerű, de körülményes.
-- Definiáld a NumberOfApples, NumberOfGrapes, NumberOfPears típusokat, mindhárom típusnak legyen egy konstruktora a típussal azonos névvel, azoknak egy Integer paramétere.

data NumberOfApples = NumberOfApples Integer
  deriving Show

data NumberOfGrapes = NumberOfGrapes Integer
  deriving Show

data NumberOfPears = NumberOfPears Integer
  deriving Show

-- SZÉP KÓD: Ha egy típusnak pontosan egy konstruktora van, akkor az a legsűrűbb esetben jó, ha azonos nevű a típussal.
-- Ez nem probléma, hogy a konstruktor azonos nevű a típussal, hiszen a típus és az értékkonstruktorok két külön névtérben élnek.

-- A fenti három típus legyen a Num osztály példánya és a műveletek működjenek pontosan ugyanúgy, mint az Integer-en.

instance Num NumberOfApples where
  (NumberOfApples a) + (NumberOfApples b) = NumberOfApples (a + b)
  (NumberOfApples a) * (NumberOfApples b) = NumberOfApples (a * b)
  abs (NumberOfApples a) = NumberOfApples (abs a)
  signum (NumberOfApples a) = NumberOfApples (signum a)
  fromInteger a = NumberOfApples (fromInteger a)
  negate (NumberOfApples a) = NumberOfApples (negate a)

instance Num NumberOfGrapes where
  (NumberOfGrapes a) + (NumberOfGrapes b) = NumberOfGrapes (a + b)
  (NumberOfGrapes a) * (NumberOfGrapes b) = NumberOfGrapes (a * b)
  abs (NumberOfGrapes a) = NumberOfGrapes (abs a)
  signum (NumberOfGrapes a) = NumberOfGrapes (signum a)
  fromInteger a = NumberOfGrapes (fromInteger a)
  negate (NumberOfGrapes a) = NumberOfGrapes (negate a)

instance Num NumberOfPears where
  (NumberOfPears a) + (NumberOfPears b) = NumberOfPears (a + b)
  (NumberOfPears a) * (NumberOfPears b) = NumberOfPears (a * b)
  abs (NumberOfPears a) = NumberOfPears (abs a)
  signum (NumberOfPears a) = NumberOfPears (signum a)
  fromInteger a = NumberOfPears (fromInteger a)
  negate (NumberOfPears a) = NumberOfPears (negate a)

-- Definiáljuk újra a sumDifferentFruits' függvényt a helyes típussal. (Most már nehezebben lesz lehetséges összeadni az almákat a körtékkel, természetesen még mindig lehet.)
sumDifferentFruits' :: [FruitBatch] -> (NumberOfApples,NumberOfGrapes,NumberOfPears)
sumDifferentFruits' [] = (NumberOfApples 0, NumberOfGrapes 0, NumberOfPears 0)
sumDifferentFruits' (x:xs) = (a + as, g + gs, p + ps)
  where
    (as, gs, ps) = sumDifferentFruits' xs
    (a, g, p) = getFruitCount x
    getFruitCount (FruitBatch Apple n) = (NumberOfApples n, NumberOfGrapes 0, NumberOfPears 0)
    getFruitCount (FruitBatch Grape n) = (NumberOfApples 0, NumberOfGrapes n, NumberOfPears 0)
    getFruitCount (FruitBatch Pear n) = (NumberOfApples 0, NumberOfGrapes 0, NumberOfPears n)

------------------------------------------------------------
-- Komplex számok reprezentálása

-- Nem analízisen vagyunk, így nem mászunk bele nagyon mélyen a komplex számokba, minket a számítógépen való ábrázolása fog érdekelni.
{-
Aki esetleg nem ismeri, nem hallott róla:
A gyökvonás műveletét csak nemnegatív számokon lehet elvégezni; √4 = 2; √2 ≈ 1.414...
x² + x + 1 = 0, másodfokú képlettel azt kapjuk, hogy
       -1 ± √(1 - 4 * 1 * 1)   -1 ± √(-3)
x₁,₂ = ───────────────────── = ──────────; gyök alatt negatív szám szerepel, tehát az egyenletnek nincs valós megoldása.
               2 * 1               2

Hangsúly azon, hogy nincs VALÓS megoldása!

A komplex számok ebből az ötletből születtek, hogy "mi lenne, ha a gyök alatti negatív szám mégis értelmes lenne?"

A komplex egységet i-vel szokás jelölni, és azt tudjuk róla, hogy i² = -1 (tehát i = √(-1))
Így lényegében két dimenziós számokat kapunk, amelyeknek van valós része (azon részben nincs i), illetve van képzetes része (ahol van i).
Az ilyen komplex számok (halmaz jelölése: ℂ) formája a következő: a + b*i, ahol a,b ∈ ℝ

Hogyan reprezentáljuk ezt Haskellben? Könnyen! Saját típussal; látjuk, hogy az "a" és "b" részek külön meg vannak említve, így ezeket kell csak elkódolni.
(Ahol "a" a valós rész, "b" a képzetes rész.)

Definiáljunk egy saját típust Complex névvel, ami a komplex számokat reprezentálja! Az egy konstruktorának a neve legyen azonos a típussal!
A konstruktornak a szükséges paraméterei Double-ök legyenek.
Ne legyen rajta semmilyen deriving.
-}

data Complex = Complex Double Double

-- Példányosítsuk értelemszerűen a következő osztályokat Complex-re: Eq, Show, Num, Fractional.
-- Eq: Az egyenlőségvizsgálat értelemszerű, két komplex csak akkor egyenlő, ha két szám valós része, illetve a két szám képzetes része megegyezik.

{-
Show: Jelenítsük meg a komplex számokat úgy, ahogy matematikában is szokás írni azokat, alapértelmezett formában a + bi.
      Ez azt jelenti, hogy az alábbiak szerint járjunk el egyes speciális esetekben:
      -- Ha b == 1, akkor az 1-est ne írjuk ki, pl 2 + i legyen 2 + 1i helyett kiírva.
      -- Ha b == 0, akkor csak a valós rész legyen kiírva.
      -- Ha b < 0, akkor a - bi formában legyen kiírva.
      -- Következetesen járjunk el b == -1 esetén is.
-}

instance Show Complex where
  show (Complex a b)
    | b == 0 = show a
    | b == 1 = show a ++ " + i"
    | b == -1 = show a ++ " - i"
    | b > 0 = show a ++ " + " ++ show b ++ "i"
    | otherwise = show a ++ " - " ++ show (abs b) ++ "i"

{-
Num: Mivel a komplex számok... hát... számok, ezért meg kell mondani, hogy ezen számok hogy viselkednek az alapműveletekkel.
     -- Nézzük meg :i-vel, hogy miket kell definiálni.
     -- Összeadás, kivonás, szorzás remélhetőleg értelemszerű.
     -- abszolútérték: komplexek esetén a két dimenziós számot reprezentáló vektor hosszát jelenti. Használjuk a Pitagorasz-tételt a számoláshoz.
     -- signum: Előjel függvény. Komplexek esetén az "adott irányú" egységvektort jelenti, tehát nincs más dolgunk, mint az eredeti számot elosztani a szám abszolútértékével.
                (Megj.: Ezt nem tudjuk közvetlen megtenni, de részenként már tudunk osztani, hiszen a komplex szám két Double-lel van reprezentálva.)
     -- fromInteger: Ez az a függvény, aminek a segítségével egy leírt számliterál be tud állni tetszőleges típusú szám helyére,
                     pl. ahogy 2 lehet Int, lehet Double, lehet Float; különböző típusok esetén ez a függvény alakítja át az Integer-t a megfelelőre.
                     Megj.: Mivel Integer-t, tehát egész számot alakítunk át, ezért az eredményben mindig mennyi lesz a képzetes rész?
-}

instance Num Complex where
  (Complex a b) + (Complex c d) = Complex (a + c) (b + d)
  (Complex a b) - (Complex c d) = Complex (a - c) (b - d)
  (Complex a b) * (Complex c d) = Complex (a * c - b * d) (a * d + b * c)
  abs (Complex a b) = Complex (sqrt (a^2 + b^2)) 0
  signum (Complex a b) = let magnitude = sqrt (a^2 + b^2) in Complex (a / magnitude) (b / magnitude)
  fromInteger a = Complex (fromInteger a) 0

{-
Fractional: Komplex számokat osztani is lehet. :i-vel nézzük meg, hogy miket kell definiálni egy Fractional-ben:
            -- (/) vagy recip: osztás vagy reciprok, mindkettő remélhetőleg értelemszerű.
            -- fromRational: Ahogy a számok Integer-ről vannak átalakítva; a törtek Rational-ről vannak átalakítva.
                             A Rational egy még eddig nem látott típus, lényegében a racionális számokat kódolja el, definíció szerint két egész szám hányadosa.
                             A Rational típus a Data.Ratio modulban található meg.
                             :bro Data.Ratio-val meg lehet nézni, hogy a modulban milyen függvények találhatók.
                             Ez a függvény a tizedesponttal felírt számokat alakítja a megfelelő típusúra (Double-re, Float-ra, stb.)
-}

instance Fractional Complex where
  (Complex a b) / (Complex c d) = Complex ((a * c + b * d) / (c^2 + d^2)) ((b * c - a * d) / (c^2 + d^2))
  fromRational a = Complex (fromRational a) 0
