Magasabb rendű függvények, lambda függvények
===



# Bevezetés
Haskellben a függvények paraméterül vehetnek fel függvényeket, vagy függvényt téríthetnek vissza értékül. Ha úgy szeretnénk műveleteket végezni egy lista elemein, hogy nem definiáljuk meg konrétan a rekurziót vagy, hogy konkrétan mikor mi történjen, akkor elengedhetetlen, a magasabbrendű függvények használata.

## Magasabb rendű függvények

Először kezdjünk egy kis definícióval, mi is az a magasabb rendű függvény. A számítástechnikában a magasabbrendű függvény olyan függvény, amely a következők legalább egyikét hajtja végre:

* argumentumként egy vagy több függvényt vár paraméterül,
* eredményül egy függvényt ad vissza

Viszont Haskellben csak azt tekintjük magasabb rendű függvénynek, amely paraméterül szinten vár legalább egy függvényt, mivel a `curryzés` (link a curryzésre) miatt minden legalább kétparaméteres függvényt magasabb rendű függvénynek tekinthetnénk.

Ezen ismeretek után nézzünk egy egyszerű példát egy magasabb rendű függvényre, amely egy függvényt vár paraméterül és egy elemet, melyre végrehajtja a kapott függvényt.

~~~{.haskell}
    applyTwice :: (a -> a) -> a -> a
    applyTwice f x = f (f x)
~~~

Itt fontos észrevennünk, hogy az `(a -> a)`-nál fontos szerepe van a zárójeleknek, így tudjuk jelölni, hogy a függvényünk egy ilyen típusú függvényt vár el paraméterül. Ha elhagynánk a zárójelet (`a -> a -> a -> a`), akkor teljesen más típusa lenne a függvényünknek, akkor egy háromparaméteres függvényünk lenne, mely vár három `a` típusú paramétert, és visszatérne egy `a` típusú értékkel.
Ha mindent jól csináltunk, itt egy-két példa az elvárt működésre:

~~~
    > applyTwice (*3) 2
    > 18
    // Kiértékelés menete:
    // ((2 * 3) * 3)
    // (6 * 3)
    // 18

    > applyTwice (++ "ha") "Ha"
    > "Hahaha"
    // Kiértékelés menete:
    // (("Ha" ++ "ha") ++ "ha")
    // ("Haha" ++ "ha")
    // "Hahaha"
~~~

Nézzünk egy rövid példát, írjunk egy olyan függvényt, amely egy számokból álló lista összes elemére elvégzi a kapott számítási függvényt.

~~~{.haskell}
    allSquared :: [Int] -> [Int]
    allSquared []     = []
    allSquared (x:xs) = x^2 : allSquared xs

    allDivTwo :: [Int] -> [Int]
    allDivTwo []     = []
    allDivTwo (x:xs) = div x 2 : allDivTwo xs
~~~

~~~
    > allSquared [1..5]
    > [1, 4, 9, 16, 25]
    // Kiértékelés menete:
    // 1^2 : (allSquared [2..5])
    // 1^2 : (2^2 : allSquared [3..5])
    // 1^2 : (2^2 : (3^2 : allSquared [3..5]))
    // 1^2 : (2^2 : (3^2 : allSquared [4,5]))
    // 1^2 : (2^2 : (3^2 : (4^2 : allSquared [5])))
    // 1^2 : (2^2 : (3^2 : (4^2 : (5^2 : allSquared []))))
    // 1^2 : (2^2 : (3^2 : (4^2 : (5^2 : []))))
    // 1^2 : (2^2 : (3^2 : (4^2 : [25])))
    // 1^2 : (2^2 : (3^2 : [16, 25]))
    // 1^2 : (2^2 : [9, 16, 25])
    // 1^2 : [4, 9, 16, 25]
    // [1, 4, 9, 16, 25]

    > allDivTwo [2,4..10]
    > [1, 2, 3, 4, 5]
    // Kiértékelés menete:
    // div 2 2 : (allDivTwo [4,6..10])
    // div 2 2 : (div 4 2 : (allDivTwo [6,8,10]))
    // div 2 2 : (div 4 2 : (div 6 2 : (allDivTwo [8,10])))
    // div 2 2 : (div 4 2 : (div 6 2 : (div 8 2 : (allDivTwo [10]))))
    // div 2 2 : (div 4 2 : (div 6 2 : (div 8 2 : (div 10 2 : allDivTwo []))))
    // div 2 2 : (div 4 2 : (div 6 2 : (div 8 2 : (div 10 2 : []))))
    // div 2 2 : (div 4 2 : (div 6 2 : (div 8 2 : [5])))
    // div 2 2 : (div 4 2 : (div 6 2 : [4, 5]))
    // div 2 2 : (div 4 2 : [3, 4, 5])
    // div 2 2 : [2, 3, 4, 5]
    // [1, 2, 3, 4, 5]
    
~~~

Nézzük meg, mit csinál a két függvény! Mindkét függvény végigmegy a lista elemein, az egyik négyzetre emeli az adott számot, a másik pedig elosztja kettővel. Viszont ez az egyetlen különbség a két függvény között, ha megfigyeljük maga a listán való végig gyaloglás megegyezik. Mi lenne, ha nem kéne megírnunk külön-külön ezt a két függvényt, hanem elég lenne csak egyet írni? Általánosítsuk kicsit a függvényünket, hogy újra fel tudjuk használni.

~~~{.haskell}
    allApply :: (Int -> Int) -> [Int] -> [Int]
    allApply _ []     = []
    allApply f (x:xs) = f x : allApply f xs
    {-
        Ez a függvény ugyan azt csinálja mint a fentebb megírt kettő, annyi különbséggel,
        hogy itt az f helyébe behelyettesítődik mindig az számítás amit az elején megadunk neki.
    -}
~~~
~~~
    > allApply (^2) [1..5]
    > [1, 4, 9, 16, 25]

    > allApply (`div` 2) [2,4..10]
    > [1, 2, 3, 4, 5]
~~~

Itt már látható, hogy elég volt egyszer megírnunk az `allApply`-t, amivel ki tudtuk váltani az `allDivTwo`-t és az `allSquared` függvényünket, így kettő helyett elég volt egy függvényt írnunk. De az `allApply`-t fel tudjuk használni másra is, például: 3-al szorozzuk meg a lista összes elemét.

Vajon szükséges ezt mindig megtennünk és leírnunk azt, hogy menjünk végig a lista elemein és alkalmazzunk rájuk egy függvényt? Továbbá mi van akkor, ha nem csak `Int`-ek listájára szeretnénk ezt alkalmazni, vagy meg kell ezt írnunk minden típusra külön-külön? Vagy `[Int]`-ból csak `[Int]`-t tudunk előállítani? A válasz, mindegyik kérdésre az, hogy szerencsére nem. A végigmenetelt tekinthetjük egyfajta szerkezeti váznak, ahol nincs megkötve a kezünk, hogy milyen típusú adatok sorakoznak a listában, vagy azokból milyen típusú adatot állítunk elő. Írjunk meg egy olyan függvényt, mely vár egy függvényt, és ezt a függvényt a lista összes elemére elvégzi. Nevezzük ezt a függvényt `map'`-nek. Először szükségünk lesz egy olyan függvényre, ami egy adott típusból egy másikat csinál, tehát szükségünk lesz egy `(a -> b)` típusú függvényre (ahol `b` különbözhet `a`-tól, de nem muszáj különböznie). Továbbá szükségünk lesz egy kezdeti listára, mivel `a`-ból szeretnénk `b`-t előállítani, ezért a paraméterül kapott listánk egy `a`-ból álló lista, tehát `[a]`, és a függvényünk visszaad egy `b`-ből álló listát, tehát egy `[b]` típusú listát. Így tehát definiáltuk a `map'` függvény típusát. 

~~~{.haskell}
    map' :: (a -> b) -> [a] -> [b]
~~~

Használjuk fel az előző függvényünknél megírt rekurziót.

~~~{.haskell}
    map' :: (a -> b) -> [a] -> [b]
    map' _ []     = []
    map' f (x:xs) = f x : map' f xs
~~~

Ezzel elkészítettünk egy olyan általános magasabb  rendű függvényt, mely paraméterül vár egy függvényt és egy listát, végig megy a listánkon és a lista összes elemére alkalmazza a kapott függvényünket. Persze nem kötelező egyik típusból a másikba képeznünk, hiszen egy `Int -> Int` ugyanúgy illeszkedni fog az `a -> b`-re.

Nézzünk egy példát, a feladatunk a következő: kapunk egy számot, és adjuk vissza a számjegyeinek az összegét. Használjuk hozzá az előbb megírt `map'`-t. (a `show` függvény `Int`-ből `String`-et tud készíteni, a `digitToInt` pedig egy `Char`-ból `Int`-et).

~~~{.haskell}
    f :: Int -> Int
    f n = sum (map' digitToInt (show n))
~~~

Persze nem kell a `map'`-t megírnunk nekünk, Haskellben alapból van egy ilyen függvény, melyet `map`-nek hívnak, egy hasznos kis függvény, érdemes megtanulni használni, hiszen megkönnyíti a dolgunkat és nem feltétlen kell nekünk mindig rekurziót írnunk az adott feladatra.

Persze a `map'`-őt nem csak rekurzívan tudjuk definiálni, hanem ezt meg tudjuk tenni listakifejezéssel is.

~~~{.haskell}
    map'' :: (a -> b) -> [a] -> [b]
    map'' f l = [f x | x <- l]
~~~

Nézzünk egy nem túl komplex példát, hogy miért lesz hasznos magasabbrendű függvényt használnunk. Legyen az a feladatunk, hogy írjunk egy függvényt, mely egy természetes számok intervallumából visszaadja egy `tuple`-ben, hogy az adott szám prím-e.Példa be és kimenet:

~~~
  > wrongPrimeList [0..3]
  > [(False, 0), (False, 1), (True, 2), (True, 3)]
~~~

Írjuk meg a függvényt!

~~~{.haskell}
wrongPrimeList :: [Int] -> [(Bool, Int)]
wrongPrimeList []                              = []
wrongPrimeList (x:xs)
  | x == 0                                     = (False, 0) : wrongPrimeList xs
  | x == 1                                     = (False, 1) : wrongPrimeList xs
  | x == 2                                     = (True, 2) : wrongPrimeList xs
  | and [mod x n /= 0 | n <- [2..(div x 2)+1]] = (True, x) : wrongPrimeList xs
  | otherwise                                  = (False, x) : wrongPrimeList xs
~~~

Ha nem használunk magasabbrendű függvényet, akkor valami hasonló kódot kell hogy kapjunk. Jegyezzük meg, hogy ez a megoldás sem rossz! Viszont már itt is észrevehető, hogy kezd nagyon olvashatatlan lenni a kód és könnyen bele tudunk gabalyodni, hogy mit is írunk. Ez egy ettől bonyolultabb számítást igénylő feladatnál méginkább igaz. Nézzük meg, hogyan nézni ki a megoldás a `map` függvény használatával!

~~~{.haskell}
prime :: Int -> (Bool, Int)
prime 0 = (False, 0)
prime 1 = (False, 1)
prime 2 = (True, 2)
prime x = (isPrime x, x)
  where
    isPrime ::Int -> Bool
    isPrime x = and [mod x n /= 0 | n <- [2..(div x 2)+1]]

goodPrimeList :: [Int] -> [(Bool, Int)]
goodPrimeList l = map prime l
~~~

Először is, ahogy már megtanultuk a `map`-nek szüksége lesz egy függvényre. Ezt a függvényt írtuk `prime` néven, amely egy számot kap és visszaadja egy `tuple`-ben, hogy az adott szám prím-e. Majd a `goodPrimeList` az előző megoldáshoz hasonlóan vár egy `[Int]`, viszont nem ez a függvényünk fogja rekurzívan bejárni a listát, hanem ezt rábízzuk a `map`-re. Így egy sokkal olvashatóbb, és egyszerűbb kódot kapunk.

A `map`-hez hasonló elgondolás miatt került be a nyelvbe a `filter` függvény. A `filter` pontosan azt csinálja, amire a neve utal, megszűri a listát, pontosabban kap egy feltételt és amely elemek eleget tesznek a feltételnek, azok bent maradnak a listában, amik nem, azok kihullanak.

Először írjuk meg rekurzívan:

~~~{.haskell}
filter' :: (a -> Bool) -> [a] -> [a]
filter' f [] = []
filter' f (x:xs)
	 | f x = x : filter' f xs
	 | otherwise = filter' f xs
~~~

Természetesen a `filter` függvényt is a `map`-hez hasonlóan meg lehet írni listakifejezéssel.

~~~{.haskell}
    filter' :: (a -> Bool) -> [a] -> [a]
    filter' p l = [x | x <- l, p x]
~~~

Ahogy a definíció is mutatja, ha egy elemre a feltétel igazat ad vissza, akkor hozzá fűzi az eredmény listához, ha nem, akkor tovább megy.

Írjuk meg `onlyPos` függvényt, ami kiválogatja egy listából a pozitív számokat.

~~~{.haskell}
onlyPos :: [Int] -> [Int]
onlyPos x = filter(>0) x
~~~

Most írjuk meg `filter` segítségével a countSpaces függvényt, ami megszámolja, hogy mennyi szóköz van egy szövegben.

~~~{haskell}
countSpaces :: [Char] -> Int
countSpaces x = length (filter (==' ') x)
~~~

Írjuk meg a uni függvényt, ami 2 listát kap paraméterül és azokat az elemeket adja vissza, amik mindkét listában benne vannak.

~~~{.haskell}
unio :: (Eq a) => [a] -> [a] -> [a]
unio x y = filter ( `elem` x) y
~~~

## További magasabb rendű függvények

#### takeWhile

A `takeWhile` egy olyan magasabbrendű függvény, mely paraméterül vár egy `(a -> Bool)` függvényt, amit predikátumnak szoktunk nevezünk, és vár egy `a` típusú adatokból álló listát. A függvény fogja az eredeti listát, az elemeire alkalmazza a predikátumot, ha igazat kap, akkor azt beleteszi egy új listába, ha hamis, akkor leáll a lista feldolgozása. (A függvény addig veszi az elemeket a listából, amég a predikátum teljesül rá, az első alkalommal, amikor a predikátum nem teljesül az adott elemre, akkor feldolgozás leáll.)

~~~{.haskell}
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile _ [] = []
takeWhile p (x:xs)
  | p x        = x : takeWhile p xs
  | otherwise  = []
~~~
~~~
  > takeWhile (<3) [1..5]
  > [1,2]

  > takeWhile (>3) [1..5]
  > []
~~~

#### dropWhile

A `dropWhile` a `takeWhile` párja. A függvény típusa megegyezik a `takeWhile`-val. A különbség a két függvény között az, hogy amíg a predikátum teljesül az adott elemre, addig a `dropWhile` eldobja ezeket az elemeket. Tehát nem fűzi bele az eredménylistába.

~~~{.haskell}
dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile _ []          = []
dropWhile p l@(x:xs)
  | p x                 = dropWhile p xs
  | otherwise           = l
~~~

~~~
  > dropWhile (<3) [1..5]
  > [3,4,5]

  > dropWhile (>3) [1..5]
  > [1,2,3,4,5]
~~~

#### any

Az `any` magasabbrendű függvény vár egy `(a -> Bool)` típusú függvényt paraméterül, és egy `a` típusú adatokból álló listát. A függvény `True`-t ad vissza, ha a listában legalább egy elemre teljesül a kapott predikátum. Egyébként `False`.

~~~{.haskell}
any :: (a -> Bool) -> [a] -> Bool
any _ []     = False
any p (x:xs) = p x || any p xs
~~~

~~~
  > any even [1..5]
  > True

  > any even [1,3..11]
  > False
~~~

#### all

Az `all` magasabbrendű függvény az `any` függvény párja. Ez a függvény is egy `Bool` értéket ad vissza, viszont annak függvényében, hogy ha az összes elemre teljesül a paraméterül kapott predikátum, akkor ad vissza `True`-t. Egyébként `False`.

~~~{.haskell}
all :: (a -> Bool) -> [a] -> Bool
all _ []     = True
all p (x:xs) = p x && all p xs
~~~

~~~
  > all (<10) [1..5]
  > True

  > all odd [1,2,3]
  > False
~~~

#### zipWith

A `zipWith` egy olyan magasabbrendű függvény, amely egy `(a -> b -> c)` típusú függvényt vár el paraméterül, és két listát, az első lista `a` típusú elemekből álljon, a másik pedig `b` típusú elemekből. A `zipWith` mindig a rövidebb lista végéig megy. A bejárás során a lista azonos indexű elemeire alkalmazza a paraméterül kapott kétparaméteres függvényt, majd ha az egyik lista elfogyott, a rekurzió megáll.

~~~{.haskell}
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ [] _          = []
zipWith _ _ []          = []
zipWith f (x:xs) (y:ys) = f x y : zipWith f xs ys
~~~

~~~
  // Tudjuk használni például két vektor skaláris szorzatához
  > sum (zipWith (*) [1,2,3] [3,2,1])
  > 14

  // Vagy tudjuk mátrixok összeadásához használni
  > zipWith (zipWith (+)) [[1..3],[1..3],[1..3]] [[1..3],[1..3],[1..3]]
  > [[2,4,6],[2,4,6],[2,4,6]]
~~~

#### span

A `span` vár egy `(a -> Bool)` típusú függvényt paraméterül, illetve egy `a`-kból álló listát. Eredményül egy `tuple`-t ad vissza, amelynek az első eleme a leghosszabb előtagja a paraméterül kapott listának, amely kielégíti a predikátumot (esetleg üres). A `tuple` második eleme a kapott lista fennmaradó része. 

~~~{.haskell}
span :: (a -> Bool) -> [a] -> ([a],[a])
span p l = (takeWhile p l, dropWhile p l)
~~~

~~~
  > span (< 9) [1,2,3]
  > ([1,2,3],[])

  > span (< 0) [1,2,3] 
  > ([],[1,2,3])

  > span (< 3) [1,2,3,4,1,2,3,4]
  > ([1,2],[3,4,1,2,3,4])
~~~

#### break

A `break` a `span` függvény ellentettje, itt a `tuple` első eleme egy olyan lista mely a predikátumot ki nem elégítő elemeket tartalmazza (esetleg üres). A második eleme pedig a paraméterül kapott lista fennmaradó része.

~~~{.haskell}
break :: (a -> Bool) -> [a] -> ([a],[a])
break p = (takeWhile go l, dropWhile go l) 
  where
    go x = not (p x)
-- break p = span (not . p)
~~~

~~~
  > break (==' ') "Haskell is fun!"
  > ("Haskell", " is fun!")
~~~

## Függvénykompozíció
A függvénykompozíciót úgy kell felfogni, mint matematikában. Tekintsük az alábbi két függvényt a matematikában: $f(x) = x^2$ és $g(x) = 2x$. Vegyük a két függvény kompozícióját $(f \circ g)(x) = f(g(x))$. Ez azt jelenti, hogy először végre hajtjuk egy számon a $g$ függvényt majd ennek eredményére hajtódik végre az $f$ függvény. Pl.: $(f \circ g)(2) = f(g(2)) = f(4) = 16$. Haskellben ezt a `(.)` operátor jelöli, típusa:

~~~{.haskell}
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) g f x = g (f x)
~~~

Ahogy a típusból is látszik kap 2 függvényt és először a második értékelődik ki, ennek eredményét kapja meg az első paraméterként. 

~~~{.haskell} 
  map ((1+) . (2*)) [1,2,3]
  [3,5,7]

  (reverse . dropWhile (==' ') . reverse . dropWhile (==' ')) "  Haskell  "
  "Haskell"
~~~


## $ operátor
A $ operátor típusa:

~~~{haskell}
:i ($)
($) :: (a -> b) -> a -> b 	-- Defined in ‘GHC.Base’
infixr 0 $

f $ x = f x
~~~

A dollár operátor használatával alapvetően zárójelpárokat spórolhatunk meg. De tulajdonképpen minden olyan esetben jól jön, amikor a függvényalkalmazás operátorát akarjuk explicite alkalmazni, például:

~~~{.haskell}
  map ($ 10) [sqrt, (* 2), (^2)]
~~~

A dollár operátor jobbra kötő 0 erősségű operátor, ezért `sin $ cos $ 4 + log 1` helyes zárójelezése `sin $ (cos $ (4 + log 1))`. A dollár definíciója szerint "nem csinál semmit", így a végeredmény `sin (cos (4 + log 1))`. **FONTOS** az `1 + sin (2 + 3)` helyett nem írhatjuk hogy `1 + sin $ 2 + 3`, mert ez a következő (hibás) kifejezést rövidíti: `(1 + sin) (2 + 3)`.


## Lambda függvények

A lambdák alapvetően névtelen függvények, amiket akkor használunk, ha csak egyszer van szükségünk a függvényre. Általában lambdát azzal a céllal készítünk, hogy odaadjuk egy magasabbrendű függvénynek. Úgy tudunk lamdát készíteni, hogy írunk egy `\` (azért a vissza perjel lett erre kitalálva, mert ez hasonlít leginkább a görög lambda betűre $\lambda$ ) aztán felsoroljuk a paramétereket, amelyeket szóközökkel szeparálunk el. Ezután jön `->` aztán jöhet a függvény törzse. Nézzünk egy két példát.

~~~{.haskell}
  filter (\e -> elem e "alma") "abcde"
  "a"

  (\x -> x^2) 2
  4

  (\x -> fst x) ("Haskell", True)
  "Haskell"

  (\(x,y) -> x) ("Haskell", True)
  "Haskell"
  -- Ez a kettő ekvivalens, lambdában is tudunk mintát illeszteni

  (\f x y -> f x y) (++) "Ha" "ha"
  "Haha"
~~~

## Feladatok

Számoljuk meg egy adott tulajdonságú elem előfordulásait egy listában. A függvény neve legyen `count`, add meg a függvény típusát is!

~~~
  count (==3) [1,2,3,4,5,4,3,2,1] == 2
  count ("alma" `isPrefixOf`) (words "almafa alma nem alma") == 3
~~~

Adott elemek listájának listája. Keressük meg a legnagyobbat a legkisebb elemek közül! A függvény neve legyen `maximumOfMinimums `, add meg a függvény típusát is!

~~~
  maximumOfMinimums [[1,2], [3,4]] == 3
  maximumOfMinimums [[4,2,2], [3,4], [1..10], [5]] == 5
~~~

Alkalmazzunk egy függvényt listák listájában levő elemekre! A függvény neve legyen `mapMap `, add meg a függvény típusát is!

~~~
  mapMap (+1) [[1,2], [3,4]] == [[2, 3], [4, 5]]
~~~

Alkalmazzunk egy függvényt egy lista elemeire, de csak azokra az elemekre melyekre teljesül az adott predikátum. Add meg a függvény típusát is!

~~~
  filterMap (>2) (*2) [1,2,1,4,3] == [8,6]
  filterMap (\x -> mod x 2 == 0) (*2) [1,2,1,4,3] == [4,8]
~~~

A `uniq l` legyen az `l`-beli elemek listája, de minden elem csak egyszer szerepeljen! Add meg a függvény típusát is!

~~~
  uniq "Mississippi" == "Mips"
~~~

Definiáld újra az elem függvényt, mely megnézi, hogy egy elem része-e egy listának! Használj magasabb rendű függvényt!

~~~
  elem' 'n' "Finn"
  elem' 'H' "Harry"
  not (elem' 'h' "Harry")
  elem' True [False, False, True]
  not (elem' True [False, False, False])
~~~

Definiáld a `hasAny` függvényt, mely megvizsgálja, hogy egy lista elemei közül valamelyik előfordul-e egy másik listában!

~~~
  hasAny "abc" "I like Haskell"
  hasAny [5,9] [4, 3, 2, 0, 9]
  not (hasAny ["haskell", "python"] ["c", "java"])
~~~

Definiáld a `replacePred` függvényt, amely kap egy predikátumot, a cserélendő elemet, és egy listát. Minden elemre amelyikre teljesül a predikátum, ott a függvény kicséréli a lista elemét a cserélendő elemmel. Add meg afüggvény típusát is.

~~~
  replacePred even 55 [1,2,3,4,5] == [1,55,3,55,5]
  replacePred isUpper 'x' "DdDd" == "xdxd"
  replacePred (\x -> even x && mod x 3 == 0) 42 [10,20,30] == [10,20,42]
~~~

Definiál egy függvényt amely kap egy predikátumot és eldönti, hogy a lista összes eleme eleget tesz-e a predikátumnak. Használj magasbbrendű függvényt! Add meg a függvény típusát is!

~~~
  allCorrect even [2,4,6,8]
  allCorrect odd [1,3,5,7]
  not $ allCorrect isLower "Haskell"
~~~

Adjuk meg azt a függvényt, amely kiválogatja azokat a listákat egy listából, amelyeknek az összes eleme kielégít egy adott predikátumot, majd az így kapott listákat összefűzi! Add meg a függvény típusát! Használj magasbbrendű függvényt!

~~~
  allSatisfies even [[0,2],[2,4]] == [0,2,2,4]
  allSatisfies odd [[0,2],[2,4]] == []
  allSatisfies isUpper ["HASKELL", "is", "IS", "FUN"] == "HASKELLISFUN"
~~~

Állapítsd meg, hogy számok listája között minden lista összege külön-külön azonos-e. Használ magasabbrendű függvényt és add meg a függvény típusát!

~~~
  quasiMagicSquare [] 
  quasiMagicSquare [[5,8,3]]
  quasiMagicSquare [[5,2,8], [5,5,5], [2,9,4], [1,3,11]] 
  not (quasiMagicSquare [[5,2,8], [5,5,5], [2,6,4], [1,3,11]]) 
  not (quasiMagicSquare [[5,2,8], [5,5,5], [2,9,4], [1,3,1]]) 
~~~