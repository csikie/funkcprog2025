# Típusosztályok

Bevezetés
---------


Nézzük meg a következő függvényt, amely megvizsgálja, hogy a két paraméterül kapott érték megegyezik-e egymással:

``` haskell
f :: a -> a -> Bool
f x y = x == y
```
Az `a` egy *típusváltozó*, ami azt jelenti, hogy tetszőleges típust felvehet a kiértékelés folyamán. 

***LINK A POLIMORFIZMUSHOZ***

Így az `f` függvényünk kap egy `a` típusú értéket, ami bármi lehet, és egy ugyanolyan, `a` típusú értéket paraméterül, ezekről eldönti, hogy a két érték egyenlő-e, ezt egy `Bool` típusú értékként adja vissza. 

A gondolatmenet jó, a szintaktika hibátlan, mégis az interpreter hibát dob.

``` haskell
  * No instance for (Eq a) arising from a use of `=='
    Possible fix:
      add (Eq a) to the context of
        the type signature for:
          f :: forall a. a -> a -> Bool
  * In the expression: x == y
    In an equation for `f': f x y = x == y
```
***LINK A HIBAÜZENETEKHEZ***

Hiába adunk meg ugyanolyan típusú értékeket, a kiértékelő nem biztos abban, hogy azokon a típusokon értelmezve van az `(==)` függvény.

Ha szeretnénk a lehető legáltalánosabb szignatúrát írni típusváltozók segítségével, de úgy, hogy azok a típusok rendelkezzenek bizonyos speciális tulajdonságokkal, akkor tulajdonképpen szeretnénk azok típusát korlátozni, megszorítani.

A Haskellben erre megoldást nyújthat a **típusmegszorítás**. Nézzük meg, hogy miként alakul az `f` függvényünk, ennek a fényében.

``` haskell
f :: Eq a => a -> a -> Bool
f x y = x == y
```
Bekerült egy `Eq a =>` a típusszignatúrába.
A `=>` bal oldalán fel tudunk soroni, típusosztály-típusváltozó párosokat, ezt nevezzük típusmegszorításnak. Ezt azt jelenti, hogy azokra az `a` típusú értékekre értelmezhető az `f` függvény, amellyek rendelkeznek az `Eq` típusosztály egy példányával. 


Amikor szeretnénk a típusok egy adott tulajdonsággal rendelkező halmazát kijelölni, amellyek rendelkeznek az erre a tulajdonságra jellemző speciális függvényekkel, akkor ezeket **típusosztályoknak** fogjuk nevezni.

A továbbiakban megismerhetjük, a fontosabb típusosztályokat, megtanulhatunk példányokat írni és még sok más hasznos tudást szerezhetünk a funkcionális programozásról.

Nézzük őket sorban.

Eq
---
Kezdjük talán az előbb emlegetett `Eq` típusosztállyal, ebben a részben, rendhagyóan, nem csak egy általános képet szeretnék adni, hanem ennek a típusosztálynak a segítségével elmondanék, néhány egyéb fontos dolgot is.

Az `Eq` típusosztályban az `(==)` és az `(/=)` függvények vannak definiálva. Nézzük meg ezeket hogyan találhatjuk meg:

``` haskell
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
```
Ez azt jelenti, hogy az `Eq` egy paraméterrel deklarált típusosztály. Bármely típus, amely szeretné ezt az `Eq` típusosztályt példányosítani, annak rendelkeznie kell két függvénnyel, `(==)` és a `(/=)` a fent említett típusszignatúrákkal. Például, hogyha szeretnénk az `Int`-re példányosítani, akkor definiálnunk kell a `(==) :: Int -> Int -> Bool` és a `(/=) :: Int -> Int -> Bool` függvényeket. Természetesen az `Int`-re már létezik `Eq` példány, így azt nem kell megtennünk, ezért tekintsük meg a következő adattípust. 

``` haskell
data Napok = Het | Ked | Sze | Csu | Pen | Szo | Vas
```
A `Napok` adattípust, 7 db konstruktorral deklaráltuk, mindegyik a hozzátartozó napot jelképezi. Példányosítsuk az `Eq` típusosztályt!

``` haskell
instance Eq Napok where
    Het == Het   = True
    Ked == Ked   = True
    Sze == Sze   = True
    Csu == Csu   = True
    Pen == Pen   = True
    Szo == Szo   = True
    Vas == Vas   = True
    _   == _     = False
    n1  /= n2    = not (n1 == n2)
```
Eléggé fárasztó és hosszú, hogy minden esetben az összes típusosztályhoz tartozó függvényt kézzel kell megírni. Ezért minden típusosztályhoz létezik **elégséges meghatározás** *(minimal complete definition)*, ami annyit tesz, hogyha azt a feltételt kielégítjük, akkor "ajándékba" megkapjuk a típusosztályhoz tartozó összes függvényt. Ez az `Eq`-ban `(==)|(/=)`, azaz csak az egyiket szükséges megadnunk.

``` haskell
instance Eq Napok where
    Het == Het   = True
    Ked == Ked   = True
    Sze == Sze   = True
    Csu == Csu   = True
    Pen == Pen   = True
    Szo == Szo   = True
    Vas == Vas   = True
    _   == _     = False
```

Valójában, az, hogy ajándékba megkapjuk, annyit jelent, hogy a megadott függvénnyel (függvénnyekkel) van kifejezve az összes többi. Hogy ez az `Eq`-ban pontosan mit jelent, azt megtudhatjuk, ha megnézzük, hogy valójában miképp van deklarálva a `Prelude`-ban:

``` haskell
class Eq a where
  (==), (/=) :: a -> a -> Bool
  x == y = not (x /= y)
  x /= y = not (x == y)
``` 
Ez annyit tesz, hogy azt definiáljuk, ami kényelmesebb a számunkra és a másik automatikusan definiálásra kerül. 

Az `Eq` az abból a szempontból is különleges, hogy a GHC tud számunkra automatikus példányokat létrehozni a saját adattípusainkhoz, ezt a `deriving` kulcsszóval tehetjük meg a következő módon:

``` haskell
data Napok = Het | Ked | Sze | Csu | Pen | Szo | Vas
    deriving Eq
``` 

Így mostmár boldogan használhatjuk ezeket a függvényeket:

``` haskell
*TypeClass> :t Csu
Csu :: Napok
*TypeClass> Szo == Szo
True
*TypeClass> Szo /= Szo
False
*TypeClass> Vas /= Sze
True
*TypeClass> Het == Ked
False
```

Ord
---

Az `Ord` típusosztály úgynevezett *teljes sorbarendezést* követel meg, ami annyit tesz, hogy bármely típus, amely szeretné az `Ord` típusosztályt példányosítani, annak egyértelműen tudnia kell, hogy két értéke közül melyik a kisebb.

``` haskell
class Eq a => Ord a where
  compare :: a -> a -> Ordering
  (<) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
```

Ha megnézzük, a típusosztály definícióját, akkor találkozhatunk, az előbb megismert típusmegszorítással, jelen esetben, ez annyit tesz, hogy ha szeretnénk példányosítani az `Ord` típusosztályt, akkor már rendelkeznünk kell az `Eq` egy példányával. Ha ezt meggondoljuk, akkor nem is tűnik annyira ördögtől valónak, hiszen, ha szeretnénk sorba rendezni az elemeinket, akkor valamilyen módon tudnunk kéne, ha a kettőnek az értéke megeggyezik.

Az **elégséges meghatározás** ebben az esetben, a `compare | (<=)`, azaz csak az egyiket kell definiálnunk. Ha megnézzük a függvényeket a legtöbbjük `Bool` értékkel tér vissza.
<!--
viszont vannak közöttük különlegesebbek is, ezekből nézzünk példákat. Az első legyen a `compare`:
``` haskell
compare :: a -> a -> Ordering
```
Láthatjuk, hogy a visszatérési értéke `Ordering`.

``` haskell
data Ordering = LT | EQ | GT
```
Ez a típus hasonlít a `Napok` adattípusunkhoz, de attól eltérően az egyes konstruktorai többletinformációt hordoznak:
- `LT`, "Less Than", "kevesebb, mint"
- `Eq`, "Equals", "egyenlő"
- `GT`, "Greater Than", "nagyobb, mint"

Nézzük meg, hogyan is működik ez a gyakorlatban:

``` haskell
*TypeClass> compare 5 8
LT
*TypeClass> compare 3 (-3)
GT
*TypeClass> compare 3 3
EQ
*TypeClass> compare (5, 6) (5, 8)
LT
*TypeClass> compare True False
GT
*TypeClass> compare False True
LT
```
A `compare` függvény eldönti, hogy az első paraméterül kapott érték, milyen viszonyban áll a másodikkal. 
-->

Nézzük meg a bevezetésben megismert példánkat, amely megvizsgálja, hogy a két paraméterül kapott érték megegyezik-e egymással. Számíthatunk rá, hogyha a bevezetőben nem volt helyes a kód, akkor most is hibát kapunk. 

``` haskell
f :: a -> a -> Bool
f x y = x == y
```

``` haskell
  * No instance for (Eq a) arising from a use of `=='
    Possible fix:
      add (Eq a) to the context of
        the type signature for:
          f :: forall a. a -> a -> Bool
  * In the expression: x == y
    In an equation for `f': f x y = x == y
```

De mi van abban az esetben, ha a GHC segítőkész tanácsát figyelem kívül hagyva, az alább látható módon próbáljuk fixálni az `f` függvényünket. Ebben az esetben is hibaüzenetet kapunk?

``` haskell
f :: (Ord a) => a -> a -> Bool
f x y = x == y
```

A kérdésre a válasz az, hogy nem. Gondoljuk meg, hogy mégis miért, a megoldás nyitja az `Ord` definíciójában rejlik, nézzük meg mégegyszer az elejét.

``` haskell
class Eq a => Ord a where
```

Hogyha azt `Ord` típusmegszorítást használjuk az azt jelenti, hogy bármely `a` típus, amelyre szeretnénk az `f` függvényt alkalmazni, annak rendelkeznie kell az `Ord` típusosztály egy példányával, de minden típus, amely rendelkezik az `Ord` egy példányával, annak rendelkeznie kell az `Eq` egy példányával, ami azt jelenti, hogy **biztosak** lehetünk benne, hogy definiálva van rájuk az `(==)` függvény. Tehát az `Ord` implikálja az `Eq` típusosztályt és természetesen, annak az összes függvényét is.

***LINK A REKURZIÓHOZ ;)***

Ezzel a definícióval egy sokkal szűkebb típushalmazt kapunk, amelyre működni fog az `f` függvényünk működni, pl-ul a saját `Napok` adattípusunkra sem. Tegyünk ellene és az ismert módon kérjük meg a GHC-t, hogy példányosítsa az `Ord` típusosztályt.

``` haskell
data Napok = Het | Ked | Sze | Csu | Pen | Szo | Vas
    deriving (Eq, Ord)
```

Show 
---
Az `Show` típusosztály emberi szem számára olvasható reprezentációt hoz létre az adattípusokból. Tehát rendelkezik egy olyan függvénnyel, ami `a -> String` típusszignatúrával rendelkezik. Nézzük meg, ez, hogy szerepel ebben a típusosztályba.

``` haskell
class Show a where
  show :: a -> String
  {...}
```

A `Show` típusosztályunk a `show` függvényen kívül tartalmaz egyéb függvényeket, de ezeket ebben a kontextusban nem fogjuk tárgyalni, így fókuszáljunk a `show` függvényre.

Az **elégséges meghatározás** ebben az esetben, a `showsPrec | show`, így csak az egyiket kell definiálnunk.

A `Show` típusosztályt is tudjuk automatikusan példányosítani, ekkor a konstruktornak megfelelő `String` reprezentáció kerül a megfelelő értékek helyére. Ugyanakkor a `Napok` adattípusunkat úgy szeretnénk megjeleníteni, hogy az egyes konstruktoroknak megfelelő napot írja ki. Az egyszerűség kedvéért a `show` függvényt fogom megvalósítani.

``` haskell
instance Show Napok where
    show Het = "Hétfő"
    show Ked = "Kedd"
    show Sze = "Szerda"
    show Csu = "Csütörtök"
    show Pen = "Péntek"
    show Szo = "Szombat"
    show Vas = "Vasárnap"
```

Nézzük meg működés közben:

``` haskell
*TypeClass> Het
Hétfő
*TypeClass> Sze
Szerda
*TypeClass> Vas
Vasárnap
*TypeClass> Csu
Csütörtök
```

Nézzünk meg egy kicsit haladóbb példát. Képzeljük el, hogy szeretnénk megírni a saját listánkat. Elvekben hasonló lesz a `Haskell`-ben megszokotthoz, azaz vagy egy üreslistát fog tartalmazni, vagy egy értéket, amit bele tudunk fűzni egy, már meglévő, listába. Nézzük meg, ezt hogyan implementálhatjuk.

``` haskell
data List a = Nil | Cons a (List a)
```

Azt láthatjuk, hogy az `a` típusú értékek listája, vagy egy ***üres lista***, azaz `Nil` lehet, vagy konstruktálok egy `a` típusú értéket a `Cons`-al, és hozzáfűzöm, az `a`-kat tartalmazó listához.

Nézzük meg, hogyan lehetne az `[1, 2, 3]` listát a saját listánkkal reprezentálni. A következő részben több példával kitérek a szintaktus cukorkákra, jelen esetben elég azt tudnunk, hogy az előbb említett listát, azt a Haskell így reprezentája: `(:) 1 ((:) 2 ((:) 3 []))`. Ennek alapján nézzük meg miként nézhet ki a saját listánkkal.

``` haskell
Cons 1 (Cons 2 (Cons 3 Nil))
```
Láthatjuk, hogy az üreslistához, először egy `3`-as értéket, majd `2`-es, majd az `1`-est. Egyből nem tűnik akkora ördöngösségnek, láthatjuk, hogy szinte teljes egészében a Haskellben látott listával megegyező képet mutat.

De sajnos ez nem túl szép, így próbáljuk példányosítani a `Show` típusosztályt úgy, hogy a listánk `<` kezdődjön és `>` végződjön, közte az elemek `;` legyenek elválasztva.

``` haskell
instance Show a => Show (List a) where
  show l   = "<" ++ showInner l ++ ">" where
    showInner Nil = ""
    showInner (Cons x Nil) = show x
    showInner (Cons x xs) =  show x ++ ";" ++ showInner xs 
```
Nézzük rendre, rögtön az első sorban, láthatunk egy típusszűkítést `Show a => Show (List a)` amely azt mutatja, hogy csak és kizárólag olyan `a` típusú értékekre értelmezzük ezt a példányt, amely már rendelkezik `Show` típusosztállyal. A következő sorban mintaillesztéssel, azt mondjuk, hogyha kapunk valamilyen `l` mintára illeszkedő listát, akkor biztosak lehetünk benne, hogy kellenek a `<>` jelek és közéjük pedig a listánk elemeit szeretnénk megjeleníteni. Tegyünk ezt meg a lokálisan definiált `showInner` segédfüggvényünkkel. Ha egy üreslistánk van, akkor üres Stringet adjunk vissza. Hogyha van valami tárolt értékünk, de utána üres lista van, akkor hívjuk meg a `show` függvényt erre az értékre, ez lesz az alapesetünk a rekurzióhoz. Mindazonáltal ez egy nagyon érdekes sor, később térjünk rá vissza. A következő sor azt írja le, hogyha nem üres lista a tárolt érték utáni üres rész, ilyenkor semmi más dolgunk nincs, mint a `show x`-el megjeleníteni a kívánt értéket utána rakni egy `;` elválasztójelet és rekurzívan meghívni ezt a függvényt, a lista rákövetkező elemjeire.

Most pedig térjünk vissza ehhez a sorhoz: `showInner (Cons x Nil) = show x`
Nézzük meg mégegyszer a `show` típusát:

``` haskell
show :: Show a => a -> String
```
Ennél a hívásnál azt a `show`-t hívjuk meg, amit az előbb definiáltunk? Nem feltétlen, ha mondjuk `Int`-eket tárolunk a saját listánkban, akkor az `Int`-ekre vonatkozó hívódik meg, ha `Char` típusú elemek tárolunk, akkor az a `show` hívódik meg. Mivel szükségszerűen az `Int`-ekre vonatkozó `show` lényegesen máshogy fog viselkedni, mint mondjuk `Napok`-ra vonatkozó, így a két függény hívás is teljesen máshogy fog viselkedni. Ezt **ad-hoc polimorfizmusnak** nevezzük, amikor egy függvény teljesen máshogy viselkedik, hogyha különböző típusú értékekre hívjuk meg.



Enum
----
Az `Enum` típusosztályt, olyan típusokat fed le amellyek "felsorolhatóak", azaz egy adott értéknek tudjuk a "megelőző" és a "rákövetkező" értékét. Ez elsőre egy cseppet absztraktnak tűnhet, de ha megnézzük a definíciókat és egy-két példát, akkor egyből világos lesz számunkra.

``` haskell
class Enum a where
  succ :: a -> a
  pred :: a -> a
  toEnum :: Int -> a
  fromEnum :: a -> Int
  enumFrom :: a -> [a]
  enumFromThen :: a -> a -> [a]
  enumFromTo :: a -> a -> [a]
  enumFromThenTo :: a -> a -> a -> [a]
```
Az **elégséges meghatározás** ebben az esetben, a `toEnum, fromEnum`, így mind a kettőt definiálnunk kell.

Nézzünk meg néhány érdekes függvényt, kezdésnek legyenek a `succ` és a `pred`, amellyek rendre, a *successor* azaz *utód* és a predecessor azaz *előd*, szavak rövidítései, nevük remekül tükrözi működésük.

``` haskell
*TypeClass> succ 't'
'u'
*TypeClass> pred 5
4
*TypeClass> pred 67.8
66.8
*TypeClass> succ 't'
'u'
```

A továbbiakban pedig foglalkozzunk a különböző `[a]`-t képző függvényekkel.

``` haskell
*TypeClass> enumFromTo 1 7
[1,2,3,4,5,6,7]
*TypeClass> enumFromThenTo 1 3 10
[1,3,5,7,9]
*TypeClass> take 20 $ enumFrom 1
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
*TypeClass> take 20 $ enumFromThen 1 5
[1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77]
``` 

Nagyon érdekes eredményeket láthatunk, mert ezek a listák kísértetiesen hasonlítanak ahhoz, amiket a különböző `[1..]` stílusú listák produkálnak. Vessük össze, és gondoljuk meg melyik kifejezések hasonlíthatnak mellyekre.

- enumFromTo 1 7
  - `[1..7]`
- enumFromThenTo 1 3 10
  - `[1,3..10]`
- enumFrom 1
  - `[1..]`
- enumFromThen 1 5
  - `[1,5..]`

Ezek a hasonlóságok kissé sem a véletlen művei, azért vannak a nyelvbe építve, hogy sokkal könnyebben értetővé, olvashatóbbá tegyék azt. Hiszen a `[1,3..10]` kifejezés sokkal szemléletesebben leírja azt, amit szeretnénk, nem úgy, mint a `enumFromThenTo 1 3 10`. Ez a törekvés, amely a nyelvet, egyszerűbben elsajátíthatóvá kívánja tenni, nem csak a `Haskell`-ben figyelhető meg, ez ennél sokkal általánosabb. Ezeket a nyelvi elemeket **szintaktikus cukorkáknak** *(syntactic sugar)* nevezzük, a céljuk az, hogy *édesebbé*, *könnyebben befogadhatóvá* tegyék számunkra a nyelvet. Nézzünk néhány további cukorkát.

``` haskell
*TypeClass> [1,2,3] == (:) 1 ((:) 2 ((:) 3 []))
True
*TypeClass> (1,2) == (,) 1 2
True
*TypeClass> "abc" == (:) 'a' ((:) 'b' ((:) 'c' []))
True
``` 
A kis kitérőnk után, térjünk vissza az `Enum` típusosztályhoz. A GHC csak abban az esetben tud számunkra generálni automatikus példányt, hogyha konstruktoraink *nem* rendelkeznek adattaggal. Így a `Napok` adattípusunkra tudjuk példányosítani az `Enum` típusosztályt.

``` haskell
data Napok = Het | Ked | Sze | Csu | Pen | Szo | Vas
    deriving (Eq, Ord, Enum)
```

Így mostmár boldogan felsorolhatjuk listában a napokat.

``` haskell
*TypeClass> [Het ..]
[Hétfő,Kedd,Szerda,Csütörtök,Péntek,Szombat,Vasárnap]
```

Oh, hát ez közel sem annyira kielégítő, mint az vártuk, mert ha a `Napok` adattípust a napokról mintáztuk, márpedig ez volt az eredeti tervünk, akkor megfigyeléseink szerint, számottevő esetben a vasárnap után hétfő következik és folytatódik minden ugyanúgy. Kénytelenek vagyunk kézzel példányt írni.

``` haskell
instance Enum Napok where 
    toEnum n
      | mod n 7 == 0 = Het 
      | mod n 7 == 1 = Ked 
      | mod n 7 == 2 = Sze 
      | mod n 7 == 3 = Csu 
      | mod n 7 == 4 = Pen 
      | mod n 7 == 5 = Szo 
      | mod n 7 == 6 = Vas 

    fromEnum Het = 0
    fromEnum Ked = 1
    fromEnum Sze = 2
    fromEnum Csu = 3
    fromEnum Pen = 4
    fromEnum Szo = 5
    fromEnum Vas = 6
```
Miután kis híján ínhüvelygyulladást kaptunk a rengeteg gépeléstől, nézzük meg mit írtunk, a példány alapján az egyes napokat a 7 szerinti maradékosztályokba soroltuk. Ami annyit jelent, hogy amikor megpróbáljuk a `Vas` értéket `Int` reprezentációra hozni, akkor megkapjuk a `6`-os értéket. Amit, ha eggyel növelünk akkor `7`-et kapunk, amit megpróbáljuk `Napok` típusra váltani a `toEnum` segítségével akkor elvégezzük a megfelelő behelyettesítést, megkapjuk, hogy `mod 7 7`, ami `0`, így a `Het` értékre kerülünk.

Nézzük meg ezzel a módosítással az előbbi kódrészletet.

``` haskell
*TypeClass> succ Vas
Hétfő
*TypeClass> take 10 $ [Het ..]
[Hétfő,Kedd,Szerda,Csütörtök,Péntek,Szombat,Vasárnap,Hétfő,Kedd,Szerda]
``` 

Morzsoljunk el egy könnycseppet, mert ez egyszerűen csodálatos, milyen gyönyörűen működik. Ennek örömmére nézzünk meg egy újabb típusosztályt!


Foldable
--------
A `Foldable` típusosztály mindazon típusokat tartalmazza, amelyek *hajtogathatóak*. Ha nem vagy teljesen tisztában a `foldr` függvénnyel, akkor ajánlom először azt a fejezetet olvasd át. Mert ebben a részben egy másik oldaláról ismerhetjük meg a hajtogatást. Hogyha még nem érzed magad készen erre, nyugodtan visszatérhetsz később is.

***LINK A FOLDR FÜGGVÉNYT TARTALMAZÓ FEJEZETHEZ***

Egy kis összefoglalóként, a hajtogatós függvényeket olyan magasabb rendű függvények, amelyek egy meglévő adatszerkezetet *összehajtogatnak*, azaz valamilyen értéket képeznek belőlük. Később meglátjuk, hogy nem csak listákat tudunk hajtogatni, de most térjünk rá a definícióra. 

``` haskell
class Foldable (t :: * -> *) where
  Data.Foldable.fold :: Monoid m => t m -> m
  foldMap :: Monoid m => (a -> m) -> t a -> m
  foldr :: (a -> b -> b) -> b -> t a -> b
  Data.Foldable.foldr' :: (a -> b -> b) -> b -> t a -> b
  foldl :: (b -> a -> b) -> b -> t a -> b
  Data.Foldable.foldl' :: (b -> a -> b) -> b -> t a -> b
  foldr1 :: (a -> a -> a) -> t a -> a
  foldl1 :: (a -> a -> a) -> t a -> a
  Data.Foldable.toList :: t a -> [a]
  null :: t a -> Bool
  length :: t a -> Int
  elem :: Eq a => a -> t a -> Bool
  maximum :: Ord a => t a -> a
  minimum :: Ord a => t a -> a
  sum :: Num a => t a -> a
  product :: Num a => t a -> a
``` 
Az **elégséges meghatározás** ebben az esetben, a `foldMap | foldr`, így csak az egyiket kell definiálnunk.

Ha szeretnénk megtudni, hogy a `(t :: * -> *)` mit jelent és szeretnénk tudni mik azok a magasabb kindú típusok, akkor olvassuk el a lambda kalkulushoz kapcsolódó fejezetet. 

***LINK A LAMBDA CALCULUSHOZ***

Hogy könnyebben megértsük az egész `Foldable` típusosztályt, először példányosítsuk a saját listánkra, emlékezés képpen, nézzük meg a definícióját és közvetlen utána a példányát.

``` haskell
data List a = Nil | Cons a (List a)

instance Foldable List where
  foldr f e Nil = e
  foldr f e (x `Cons` xs) = f x (foldr f e xs)
```
Ez a definíció nem sokban különbözik az ismert listás verzióhoz. Pusztán az `[]` kicseréltük `Nil`-re és használuk a `Cons` konstruktorunkat. Tekintsünk is meg egy eggyel érdekesebb példát. 

A következőkben egy bináris fa rekurzuív algebrai adatszerkezetet fogunk definiálni. Tekintsük úgy, hogy a bináris fánk lehet üres, lehet, hogy egy levélben egy tetszőleges `a` típusú értéket tárolunk, illetve az is megeshet, hogy elágazik, ilyenkor is eltárolunk egy `a` típusú értéket, illetve egy bal- és egy jobboldali részfát. A definíció után tekintsük meg a `foldr` definícióját, amivel példányosítottuk is a `Foldable` típusosztályt.



``` haskell
data Tree a = Empty | Leaf a | Node (Tree a) a (Tree a)

instance Foldable Tree where
  foldr f acc Empty = acc
  foldr f acc (Leaf key) = f key acc
  foldr f acc (Node left key right) = foldr f foldedKey left where
      foldedKey   = f key foldedRight
      foldedRight = foldr f acc right
```

Nézzük végig függvénydefiníciót sorjában. Ha egy üres fát szeretnénk hajtogatni, akkor nincs más dolgunk, mint visszaadni az akkumuláló paramétert. Ha egy levelet szeretnénk hajtogatni, akkor az abban található értékre és az akkumuláló paraméterre alkalmazzuk a függvényünket, most jön a legérdekesebb eset, a rekurzív. Mivel a `foldr`-t szeretnénk definiálni, így először a jobb részfát hajtogatjuk, ezt lokálisan definiáltuk. Azután következik a tárolt elem és végül, a bal oldali részfát is összehajtogatjuk. Ezzel be is fejeztük a függvényünket, így a `Foldable` típusosztály összes függvényét megkaptuk.


Num
---
A `Num` típusosztályt a legtöbb numerikus típus implementálja, hogyha megnézzük az osztály definícióját, látszik, hogy általános aritmetika műveletek szerepelnek a függvények között.

``` haskell
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
```

Az **elégséges meghatározás**, a `(+), (*), abs, signum, fromInteger, (negate | (-))`, így kis híján az összes függvényt definiálnunk kell. A legtöbb numerikus típusosztályra jellemző, hogy a legtöbb függvény részét képzni az elégséges meghatározásnak, így továbbá nem emelem ki.


Ugyan a Haskell nem definiál törvényeket a `Num` típusosztályra, ugyanakkor, a közös megegyezés azt mondja, illik hogy a `(+)` és a `(*)` függvények matematikai gyűrűt alkossanak és rendelkezzenek a következő tulajdonságokkal:

1. (+), (*) asszociatívítása
    - (x + y) + z = x + (y + z)
    - (x * y) * z = x * (y * z)
2. (+) kommutativítása
    - x + y = y + x
3. fromInteger 0 az összeadás egységeleme
    - x + fromInteger 0 = x
4. Egy elem és negáltjának összege az egységelemet adja 
    - x + negate x = fromInteger 0
5. fromInteger 1 a szorzás egységeleme
    - x * fromInteger 1 = x 
    - fromInteger 1 * x = x
6. (*)-nak a (+)-ra nézve mindkét oldali disztibutivítása
    - a * (b + c) = (a * b) + (a * c) 
    - (b + c) * a = (b * a) + (c * a)


A legtöbb numerikus típus mint a `Float, Double, Rational, Integer, Int`, rendelkeznek a `Num` egy példányával.

Már csak megszokásból is példányosítsuk egy erre alkalmas típust.

``` haskell
data Tort = T Integer Integer
    deriving Eq

instance Show Tort where
    show (T a b) = show a ++ "/" ++ show b 

szamlalo :: Tort -> Integer
szamlalo (T a _) = a

egyszerusit :: Tort -> Tort
egyszerusit (T a b)
    | b == 0    = error "nevezo 0"
    | b < 0     = T (div (-a) g) (div (-b) g)
    | otherwise = T (div a g) (div b g)
    where 
        g = gcd a b 

mkTort :: Integer -> Integer -> Tort
mkTort a b = egyszerusit (T a b) 
``` 

A reacionális számokat kívánjuk ábrázolni két egész segítségével. Az `Eq` típusosztályhoz automatikus példányt kérünk, a `Show`-t pedig saját ízlésünk szerint, klasszikus tört alakban írjuk fel. Néhány segédfüggvényt definiáltunk, hogy a `Num` példányunk egy kicsit könnyebb legyen. A tört egyszerűsítéséhez használt `gcd` függvény, a `Prelude`-ból ismert. Segítségével két szám legnagyobb közös osztóját kaphatjuk meg az euklideszi algoritmus segítségével. Nézzük meg a `Num` példányát.


``` haskell
instance Num Tort where
    (+) (T a b) (T c d) = mkTort (a*d + c*b) (b*d)
    (*) (T a b) (T c d) = mkTort (a*c) (b*d)
    negate (T a b) = T (-a) b
    abs (T a b) = T (abs a) (abs b)
    -- signum x 
    --     | szamlalo c == 0 = (T 0 1)
    --     | szamlalo c < 0 = (T (-1) 1)  
    --     | szamlalo c > 0 = (T 1 1)
    --     where
    --         c = egyszerusit x
    signum x = (T c 1)
        where
            c = signum $ szamlalo $ egyszerusit x
    fromInteger a = (T a 1)
```

A `Num` példányosításánál a törtekre vonatkozó egyszerű aritmetika szabályokat fogjuk alkalmazni. Minden esetben, amikor új törtet állítunk elő, a legegyszerűbb alakban kívánjuk tárolni, így az `mkTort` függvényt használjuk. 


Ha megnézzük a függvényeket láthatjuk, hogy a legáltalánosabb műveletek megvannak, kivéve az osztást, mert néhány numerikus típus nem támogatja azt. Ha belegondolunk ez nem is olyan meglepő, hiszen ha kettő `Int` típusú értéket szeretnénk elosztani, akkor nem valószínű, hogy minden kerekítés nélkül egy szép egésszámot kapnánk. Ha szeretnénk, hogy tudjunk osztani, akkor a `Fractional` típusosztályra van szükségünk.

Fractional
----------
A `Fractional` típusosztályban található meg a `(/)` függvény, illetve a reciprok kiszámítására használható `recip`.

```Haskell
class Num a => Fractional a where
  (/) :: a -> a -> a
  recip :: a -> a
  fromRational :: Rational -> a
```

Többek között a `Float, Double, Rational`, rendelkeznek a `Fractional` egy példányával.

Integral
--------
Ahogy a `Fractional` tört műveleteket támogat, úgy az `Integral` egész számokhoz kapcsolódókat. 

```Haskell
class (Real a, Enum a) => Integral a where
  quot :: a -> a -> a
  rem :: a -> a -> a
  div :: a -> a -> a
  mod :: a -> a -> a
  quotRem :: a -> a -> (a, a)
  divMod :: a -> a -> (a, a)
  toInteger :: a -> Integer
```

Két legismertebb típusa az `Int` és az `Integer`. A kettő közötti különbségről az alapvető típusok részben olvashatsz.

***LINK AZ ALAPVETŐ TÍPUSOKHOZ***

Floating
--------
A `Floating` típusosztály mindenféle trigonometrikus és hiperbólikus függvényekkel kecsegtet, nézzük hát őket.

```Haskell
class Fractional a => Floating a where
  pi :: a
  exp :: a -> a
  log :: a -> a
  sqrt :: a -> a
  (**) :: a -> a -> a
  logBase :: a -> a -> a
  sin :: a -> a
  cos :: a -> a
  tan :: a -> a
  asin :: a -> a
  acos :: a -> a
  atan :: a -> a
  sinh :: a -> a
  cosh :: a -> a
  tanh :: a -> a
  asinh :: a -> a
  acosh :: a -> a
  atanh :: a -> a
```

Két ismert típus, a `Float`, amely egyszeres pontosságú és a `Double`, amely kétszeres pontosságú lebegőpontos szám.

