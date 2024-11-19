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
-- Magasabb rendű függvény: Olyan függvény, amely függvényt vár paraéterül.
-- Megj.: ...vagy függvényt ad eredményül, ezt is hozzá szokták tenni,
--        de ebben a nyelvben az teljesen felesleges, mert akkor minden függvény magasabb rendűnek számítana.

{-
Magasabb rendű függvények használata:
Megpróbálhatnánk úgy használni, ahogy eddig tettük, pl.

l = map' f [1,2,3] where
  f x = x + 1

de azért azt elkezdjük látni, hogy:
1. A where-ben/let-in-ben csak ezért egy függvényt definiálni nem igazán karakterhatékony, nem is idiomatikus.
2. Elég sűrűn előfordul, hogy ugyanazt a függvényt kéne többször a where-ben definiálni, az meg csak simán kódduplikáció; az meg egy nyelvben sem szép.

Milyen jó lenne, ha lennének ilyen egyszer használatos függvények, amiket csak odaírok és működik!
Szerencsénk van, ilyenek egy funkcionális nyelvben léteznek, ezeket szokás lambda függvényeknek nevezni.

-- Definíció:
-- Lambda-függvény: Névtelen függvény.

Szintaxisa: (\ <1. paraméter neve> <2. paraméter neve> ... <n. paraméter neve> -> <kifejezés>)
ahol a paraméterek neveire ugyanaz a szabály vonatkozik, mint a sima függvényekben, tehát kisbetűvel kezdődnek.

Ezzel az új eszközzel felvértezve magunkat tudunk egyszer használatos, névtelen függvényeket megadni paraméterül a magasabb rendű függvényeknek.

l = map' (\x -> x + 1) [1,2,3]

Sokkal rövidebb, átláthatóbb, hogy mit szeretnénk kifejezni.

--------------------

Természetesen ezen névtelen függvények használhatók magasabb rendű függvények nélkül is.
pl. (\x -> x + 1) 2, pontosan ugyanúgy működnek, mint a megszokott, névvel rendelkező függvények.
    ^^^^^^^^^^^^^^^ -- Mennyi lesz az eredménye ennek a kifejezésnek?

A lambdákban ugyanúgy lehet mintailleszteni, azonban nem totálisan, csak maximum egy minta van megengedve.
(\True -> False) True == False

-- SZÉP KÓD: Éppen a fenti miatt csak azon értékeket mintaillesszük, amiknek pontosan egy konstruktora van,
             de azt mintaillesszük is (ha csak nem valami nagyon-nagyon triviális dolgot művelünk)! (pl. rendezett n-es)

Mi történik (\False -> True) True esetén?

Két paraméter esetén az alábbi módon néz ki:
(\x y -> 2 * x + 3 * y) 9 10

Mi történik akkor, ha a függvényt bezárójelezzük az első paraméterrel?
((\x y -> 2 * x + 3 * y) 9) 10

Hiba lesz vagy teljesen helyes?
Ha futtatjuk mindkettőt, akkor láthatjuk, hogy mind a kettő ugyanazt az eredményt adta vissza.
Pedig tisztán látható, hogy a második esetben csak egy paramétert adtam át a függvénynek és azt kellett kiértékelnie a zárójelezés miatt.
Ezt Haskell meg is tette, a köztes eredmény egy új függvény lesz, egészen pontosan a (\y -> 2 * 9 + 3 * y) függvény, amelyben az x helyére már be lett helyettesítve
a 9-es érték, és amely függvény már csak egy paramétert vár még. Ezt az úgy nevezett parciális applikálás/függvényalkalmazás teszi lehetővé.

-- Definíció:
-- Parciális applikálás/függvényalkalmazás: A függvénynek átadok legalább egy paramétert, de nem az összeset, így az alkalmazás eredménye egy másik függvény lesz.
-- Totális applikálás/függvényalkalmazás: A függvénynek átadjuk az összes szükséges paraméterét, hogy az eredménye egy konkrét érték legyen, amely nem függvény.

Ez nem egy beépített nyelvi jellemző, hanem matematikai következmény. A típusrendszer mondja meg, hogy pontosan mit csinálhatunk mivel.
Ez azt jelenti, hogy valahol a típusrendszerben meg kéne látszódnia, hogy ezt megtehetjük.
Hol látszódhat? Magának a függvénynek a típusában; azon belül? Mi az a szimbólum a típusban, amivel eddig keveset foglalkoztunk (és nem a =>)?
ghci-ben nézzük meg: :i ->
Mit látunk? A (->) pontosan ugyanolyan típuskonstruktor, mint az Either vagy a Maybe és még sok más. Emellett a nyílnak meg van adva a fixitása is,
amelyből megtudjuk, hogy a (->) infixen használva jobbra köt a lehető leggyengébben.

Ez azt jelenti, hogy ha leírom azt, hogy a -> b -> a vagy azt, hogy a -> (b -> a), ez a két típus teljesen ugyanazt jelenti.
Amely meg azt vonja maga után, hogy pl.
f :: a -> b -> a
f x y = x
és
g :: a -> (b -> a)
g x = \y -> x
teljesen ugyanazok, ahol az f függvényben felvettem mindkét paramétert, a g-ben pedig felvettem egyet és eredményként egy függvényt adok vissza, ahogy a típus leírja.
Továbbá:
h :: (a -> (b -> a))
h = \x -> \y -> x
szintén ugyanaz.

Ezt a folyamatot (f → g → h) szokás curry-zésnek nevezni.
Megjegyzés: Ugyan ez a curry-zés, de a tárgy keretében ha valamilyen számonkérés formájában megkérdezik, hogy "mi a curry-zés lényege?" vagy valami hasonló módon,
            ahol a curry-zésre kérdez rá a kérdés, akkor az a válasz, hogy "Minden függvény egyparaméteres" annak ellenére, hogy ez a curry-zésnek egy következménye.

Hogy tudjuk a parciális applikálást kihasználni?
Vegyük a korábbi példát.

l = map' (\x -> x + 1) [1,2,3]

Ez a felírás még mindig hosszúnak érződik.
Hol lehet rajta még rövidíteni?
A map' függvénynek az a neve, azzal nem lehet csinálni többet.
A lista az meg attól függ, hogy mi mit szeretnénk, azon se lehet igazán rövidíteni.
Akkor csak a lambdában lehet.
Láthatjuk, hogy a (+) első paramétere maga a függvény paramétere; a másik pedig egy 1-es érték.
Tehát lényegében csak egy olyan függvényt kell leírnunk, amelynek az eredménye egy olyan függvény, amely egy számhoz 1-et hozzáad.

Ezt parciális applikálással le tudjuk írni a (+) függvényt használva úgy, hogy (+ 1). (Mivel az összeadás kommutatív, az (1 +) is ugyanezt az eredményt éri el.)
Mi lesz a különbség a (+ 1) és a (+) 1 kifejezések között?

Így összességében a fenti felírást úgy tudjuk tovább rövidíteni, hogy:
l = map' (+ 1) [1,2,3]

Így már sokkal rövidebb, olvashatóbb, érthetőbb, hogy mit csinálunk a listával.
-}

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

-- Definiáld a ($$) függvényt, amely egy függvényt alkalmaz egy értékre.
infixr 0 $$
($$) :: (a -> b) -> a -> b
f $$ a = f a
-- Az eredeti függvény a ($).

{-
addFoo :: Maybe Int -> Maybe Int -> Maybe Int
addFoo _ Nothing = Nothing
addFoo Nothing _ = Nothing
addFoo (Just x) (Just y) = Just (x + y)

addFoo :: Maybe Int -> Maybe Int -> Maybe Int
addFoo _ Nothing = Nothing
addFoo Nothing _ = Nothing
addFoo (Just x) (Just y) = Just $ x + y
-}


-- Definiáld az app2ToFunctions függvényt magasabb rendű függvényeket használva rekurzió nélkül, amely alkalmazza a 2-es értéket egy függvényeket tartalmazó lista minden függvényén.
-- [(+1), (*3), (div 10)]
app2ToFunctions :: Num a => [a -> b] -> [b]
app2ToFunctions l = map ($ 2) l

-- Definiáld a span' függvényt, amely kettébont egy listát ott, ahol egy adott tulajdonság már nem teljesül.
-- span' even [2,4,6,1,2,3,4] == ([2,4,6],[1,2,3,4])
-- span' (> 0) [5,4,3,2,1,0,-1,-2,-3] == ([5,4,3,2,1],[0,-1,-2,-3])
-- span' (< 0) [1,2,3,4] == ([],[1,2,3,4])
-- span' (> 0) [1,2,3,4] == ([1,2,3,4],[])
span' :: (a -> Bool) -> [a] -> ([a], [a])
span' _ [] = ([], [])
span' f (x:xs)
  | f x = (x: as, bs)
  | otherwise = ([], x:xs)
  where
    (as, bs) = span' f xs

-- Definiáld a takeWhile' függvényt, amely egy lista elejéről addig tartja meg az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' f (x:xs)
  | f x = x : takeWhile' f xs
  | otherwise = []

-- Definiáld a dropWhile' függvényt, amely egy lista elejéről addig dobálja el az elemeket, amíg egy adott tulajdonság folyamatosan teljesül.
dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' f l@(x:xs)
  | f x = dropWhile' f xs
  | otherwise = l

-- Definiáld a find' függvényt, amely visszaadja az első adott tulajdonságú elemet egy listából, ha létezik olyan.
find' :: (a -> Bool) -> [a] -> Maybe a
find' _ [] = Nothing
find' f (x:xs)
  | f x = Just x
  | otherwise = find' f xs
-- Az eredeti függvény a Data.List-ben található.

-- Definiáld az findIndex' függvényt, amely visszaadja az első adott tulajdonságú elem indexét egy listából, ha létezik olyan.
-- Megj.: Ugyan fel lehet használni az előző függvényt erre, de nem célszerű.
findIndex' :: (Num b, Eq b) => (a -> Bool) -> [a] -> Maybe b
--findIndex' _ [] = Nothing
findIndex' f l = helper f l 0
  where
    helper _ [] _ = Nothing
    helper f (x:xs) n
      | f x = Just n
      | otherwise = helper f xs (n+1)

-- Definiáld az any' függvényt, amely megmondja, hogy van-e olyan elem egy listában, amelyre egy adott tulajdonság teljesül.
any' :: (a -> Bool) -> [a] -> Bool
any' _ [] = False
any' f (x:xs) = f x || any' f xs

-- Definiáld az all' függvényt, amely megmondja, hogy minden elemre egy listában teljesül-e egy adott tulajdonság.
all' :: (a -> Bool) -> [a] -> Bool
all' _ [] = True
all' f (x:xs) = f x && all' f xs

-- Definiáld a foldr' függvényt rekurzívan.
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ e [] = e
foldr' f e (x:xs) = f x (foldr' f e xs)

-- Definiáld a foldl' függvényt rekurzívan.
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' = undefined