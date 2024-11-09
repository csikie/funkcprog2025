module Lesson08 where

-----------------------------
-- Paraméteres típusok
-----------------------------

-- Maybe
data Maybe' a = Nothing' | Just' a


-- Definiáld a safeHead függvényt úgy, hogy minden típusra működjön helyesen!
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

-- Definiáld a safeDiv függvényt, amely a 0-val való osztást kiszűri, tehát ha a második paramétere 0, akkor az eredmény legyen Nothing,
-- egyébként osszuk el az elsőt a másodikkal.
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv a b = Just (div a b)

-- Definiáld az add függvényt, amely két lehetségesen hibás értéket összead. Ha valamelyik érték Nothing, az eredmény legyen Nothing.
add :: Maybe Int -> Maybe Int -> Maybe Int
add Nothing _ = Nothing
add _ Nothing = Nothing
add (Just a) (Just b) = Just (a + b)

-- Definiáld a doubleHead függvényt, amely egy listák listájának veszi az első listájának első elemét, ha az létezik.
doubleHead :: [[a]] -> Maybe a
doubleHead [] = Nothing
doubleHead ([]:_) = Nothing
doubleHead ((x:_):xss) = Just x

-- Definiáld a divHead függvényt, amely egy listának az első elemét elosztja egy második paraméterül kapott egész számmal.
divHead :: [Int] -> Int -> Maybe Int
divHead [] _ = Nothing
divHead _ 0 = Nothing
divHead (x:_) n = Just (div x n)

-- A probléma itt is ugyanaz lesz, mint az előbb. Mit tudunk, ha az eredmény Nothing?

-- Definiáld a lookup' függvényt, amely egy adott kulcsú értéket megkeres egy listában. A lista rendezett párokból áll, amelyeknek az első komponensét tekintjük
-- a kulcsnak, a másodikat pedig az értéknek. Előfordulhat, hogy nincs a listában a kulcs, ekkor Nothing legyen az eredmény.
lookup' :: Eq a => [(a, b)] -> a -> Maybe b
lookup' [] _ = Nothing
lookup' ((x, y):xs) key
  | x == key = Just y
  | otherwise = lookup' xs key

-- Definiáld az elemIndex' függvényt, amely visszaadja az első adott elem indexét egy listából, ha létezik olyan.
-- A típusa legyen minél általánosabb.
elemIndex' :: (Eq a, Num b) => [a] -> a -> Maybe b
elemIndex' [] _ = Nothing
elemIndex' l x = helper l x 0
  where
    helper [] _ _ = Nothing
    helper (x:xs) elem n
      | x == elem = Just n
      | otherwise = helper xs elem (n+1)

-- Legyen adott az alábbi data:
data SelectValue = First | Second

data Either' a b = Left' a | Right' b

-- Definiáld a select függvényt, amelynek három paramétere van, az első eldönti, hogy a következő kettő közül melyiket adjuk vissza.
-- Mi lesz az eredmény típusa?
--               Ez a kettő maradjon a és b
--                       v    v
select :: SelectValue -> a -> b -> Either a b
select First x _ = Left x
select Second _ y = Right y

-- Definiáld az Either' típust, amely két típust tartalmaz, és az egyiket vagy a másikat tárolja.
-- Most már meg tudjuk csinálni a fenti feladatot.

{-
Az előbb definiált Either típusban több információ elfér, mint egy Maybe-ben hibakezelés szempontjából.
Először nézzük a naív módját a hibakezelésnek:
-}
type ErrorOr a = Either String a

-- Definiáljuk újra a doubleHead függvényt, csak most az eredménye egy "ErrorOr a" típusú érték legyen
doubleHeadErrorOr :: [[a]] -> ErrorOr a
doubleHeadErrorOr [] = Left "Empty list!"
doubleHeadErrorOr ([]:_) = Left "Empty inner list!"
doubleHeadErrorOr ((x:_):_) = Right x

-- Definiáld az Error saját típust! A konstruktorai olyanok legyenek, hogy a doubleHead függvény két hibáját tudja jelezni.

data DoubleHeadError = EmptyListDoubleHead | EmptyInnerList
  deriving Show

-- Definiáld a doubleHeadError függvényt!
doubleHeadError :: [[a]] -> Either DoubleHeadError a
doubleHeadError [] = Left EmptyListDoubleHead
doubleHeadError ([]:_) = Left EmptyInnerList
doubleHeadError ((x:_):_) = Right x

-- Definiálj egy másik hibát jelző típust, amely a safeDiv műveletet kezeli.

data DivHeadError = DivisionByZero | EmptyListDivHead
  deriving Show

-- Definiáld a divHead függvényt ezzel az új hibát jelző típussal!
divHeadError :: Integral a => [a] -> a -> Either DivHeadError a
divHeadError [] _ = Left EmptyListDivHead
divHeadError _ 0 = Left DivisionByZero
divHeadError (x:_) n = Right (div x n)

---------------------------------
-- Rekurzív típusok
---------------------------------

{-
Nem csak függvények lehetnek rekurzívak, hanem maguknak a típusoknak a felépítése is lehet rekurzív, pontosabban induktív.
Vegyük példaként a listát? Hogy lehet végtelen listánk? Úgy, hogy a típusában valahol végtelen rekurziót lehet csinálni.

Próbáljuk meg definiálni mi magunk a lista adatszerkezetet. Szükség van két konstruktorra; egy, ami az üres listát reprezentálja, meg egy, ami a legalább egy eleműt.
Ezeket általában Nil-nek és Cons-nak szokás nevezni. A Cons konstruktor infixen használva kössön 5-ös erősséggel jobbra.
-}

data List a = Nil | Cons a (List a)
  deriving Show

infixr 5 `Cons`


-- Definiáljuk a BinTree típust, ami egy ilyen fát tud reprezentálni.
-- Két konstruktora kell legyen, Leaf és Node.
-- Kérjük meg a fordítót, hogy példányosítsa nekünk a Show osztályra a típusunkat.
{-
        4
       / \
      /   \
     3     2
    / \   / \
   1   0 3   7
  / \       / \
10  20     5   9
-}

data BinTree a = Leaf a | Node a (BinTree a) (BinTree a)
  deriving Show

-- Adjuk meg a fenti példában látható fát lineáris jelöléssel (tehát Leaf-ek és Node-ok függvényében)!
t :: BinTree Int
t = Node 4 (Node 3 (Node 1 (Leaf 10) (Leaf 20)) (Leaf 0)) (Node 2 (Leaf 3) (Node 7 (Leaf 5) (Leaf 9)))

-- Definiáld az add1Tree függvényt, amely egy bináris fa minden eleméhez hozzáad egyet.
add1Tree :: BinTree Int -> BinTree Int
add1Tree (Leaf n) = Leaf (n+1)
add1Tree (Node n left right) = Node (n+1) (add1Tree left) (add1Tree right)

-- Definiáld a sumTree függvényt, amely egy bináris fának az elemeit összeadja.
sumTree :: BinTree Int -> Int
sumTree (Leaf n) = n
sumTree (Node n left right) = n + sumTree left + sumTree right

-- Példányosítsd az Eq osztályt a bináris fára.
instance Eq a => Eq (BinTree a) where
  (==) (Leaf n1) (Leaf n2) = n1 == n2
  (==) (Node n1 left1 right1) (Node n2 left2 right2) = n1 == n2 && left1 == left2 && right1 == right2