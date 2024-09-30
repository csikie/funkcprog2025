
# MINTAILLESZTÉS

## Bevezető

<figure>
  <img src="alakzatjatek.jpg" alt="Alakzat játék" title="Alakzat játék" >
  <figcaption><i>Ismerős ez a játék?</i></figcaption>
</figure>

A képen látható játékban az a feladatod, hogy az összes alakzat a dobozba kerüljön. Az alakzatokat **csak** az ugyanolyan alakzatú lyukakon tudod eljutattni a dobozba. Nos, a haskell mintaillesztést is ehhez hasonló módon kell elképzelni, ahol az alakzatok a függvény paraméterei és az alakzat lyukak pedig a minták. Bizonyos paraméterek, csak bizonyos mintákra illeszthetők és vannak olyan különböző paraméterek, amelyek ugyanarra a mintára is illeszthetők. Egy példa a haskellben : 1 < 2 és az Igaz is, "belefér" az Igaz lyukba (hiszen az 1 < 2 az igaz), de erről majd később. Szakszavakkal kifejezve a mintaillesztés olyan minták meghatározását foglalja magában, amelyeknek az adatoknak meg kell
felelniük. Ezeket a mintákat a függvényünk sorrendben ellenőrzi, hogy melyiknek felel meg és az adatokat
ezen minták szerint használja fel. Értelmezhető egy egyszerű elágazásnak is. A mintaillesztés a '==' függvényre épül, tehát olyan típusoknál ami nincs Eq osztályban nem fog működni.

## A minták

Nézzük a következő példát: Írjuk meg a myNo nevű függvényünket, ami egy logikai tagadást valósít meg.

```haskell
myNo :: Bool -> Bool
myNo True = False
myNo False = True
```

Tekintsük a paramétereket egy-egy halmaznak. Ebben a példában, mivel a **Bool** csak két elemet vehet fel, ezért két egyelemű halmazunk van, az egyik amiben az Igaz, a másik amiben a Hamis található. A myNo függvényünknek nincs megoldás metszete (nincs a megoldás halmazai között átfedés, vagyis nem lehet egy érték egyszerre Igaz és egyszerre Hamis is). Ebből az következik, hogy mindegy milyen sorrendben vizsgáljuk meg a mintákat (milyen sorrendben követik a függvénydefiníciók egymást).

A függvényparaméterek ahogy jól láthatóak nem változók, hanem minták (méghozzá típus specifikus minták).
A függvényünk úgy működik, hogy kap egy logikai értéket (igaz vagy hamis) és megkeresi az első mintát, ami illeszkedik rá.
Ezután visszaadja a hozzá tartozó értéket. Viszont igaz vagy hamis érték nem csak a True vagy False lehet, hanem egy kifejezés is. Például a myNo (1 < 2) milyen értékkel tér vissza?
Elsőnek kiértékeli az (1 < 2)-őt, ami igaz, tehát myNo True amiből False lesz:

```haskell
myNo (1 < 2)
myNo True
False
```

Nézzünk meg egy másik példát is: Számkitalálós.
Legyen a szerencseszámunk a 2, ha ezt valaki kitalálja gratuláljunk neki, ellenkező esetben pedig üzenjük neki, hogy próbálja újra.

```haskell
guessTheNum :: Int -> [Char]
guessTheNum 2 = "eltalaltad, GRATULALOK!"
guessTheNum x = "nem sikerult, probald ujra!"
```

A függvény paramétere egy **Int** típusú szám lehet. Ha ez a szám 2, akkor az "eltalaltad, GRATULALOK!" szöveget kapjuk eredményül, ha bármilyen más **Int** típusú számmal próbálkozunk, a "nem sikerult, probald ujra!" szöveget kapjuk eredményül. Ez azért van, mert a `2` egy típus specifikus minta a kódrészletben és ez csak a `2` számra illeszkedik (természetesen az is elegendő, ha a kifejezés értéke 2 lesz például a (3-1) is illeszkedik rá). Ez nem azt jelenti, hogy az x nem lehet `2`, hanem a `2`re egy elöző sor mintája már illeszkedni fog. Ezt lejjebb részletesen kifejtem.

## A minták fajtái

* típus specifikus minta: True, False, 2, „szoveg”,’c’, (a , b) -megj. itt az a és b változók-
* változó(formális paraméter): a, b, x, xs
* joker: A joker és a változó minden kifejezésre illeszkedik. A különbséget [később](#joker) tárgyaljuk.

## Típus specifikus minta

A következő példa karakterekből képez neveket.  
Csináljuk meg azt, hogy ’a’-ból Albert, ’b’-ből Béla és ’c’-ből Cecíliát képzünk.

```haskell
charToName :: Char -> [Char]
charToName 'a' = "Albert"
charToName 'b' = "Bela"
charToName 'c' = "Cecilia"
```

Most, ha kipróbáljuk a, b vagy c betűvel a hozzá tartozó szöveget
kapjuk, de vajon mi történik, ha ettől eltérőt használunk? Nézzük meg!

```haskell
*Main> charToName 'a'  
"Albert"
*Main> charToName 'b'  
"Bela"
*Main> charToName 'c'  
"Cecilia"
*Main> charToName 'd'  
"*** Exception: D:\\suli\HASKELL\repos\EFOP\2019_2020_2\hippenmayer_robert\PatterMatchingExamples.hs:(10,1)-(12,26): Non-exhaustive patterns in function charToName
```

Egy hibát kaptunk: A minták nem elég kimerítőek a függvényünkben, ami azt jelenti, hogy nem minden eset van definiálva.
Például a d vagy e karakterekre nem adtunk meg mintát, ezzel a függvényünk nem tud mit kezdeni így hát kivételt dob.
Nos, akkor írjuk át úgy, hogy bármilyen karakterre jó legyen.

## Változó mint minta

Nem mindegy a sorrend, hiszen a függvényünk fentről lefelé haladva ellenőrzi a mintákra való illeszkedést.
Ez akkor nagyon fontos ha a paraméter lehetőségeknek nincs metszete. Például a logikai kifejezéseknek nincs metszete, de listáknál az 5 elemű és a 6 elemű is legalább 1 elemű lista (a játékra hivatkozva itt a legalább 1 elemű lista a "nagy" lyuk amibe a 2,3,4.. elemű listák beleférnek).  

```haskell
charToName :: Char -> [Char]
charToName x = "Nem tudom"
charToName 'a' = "Albert"
charToName 'b' = "Bela"
charToName 'c' = "Cecilia"
```

Ha így módosítjuk a függvényünket, akkor minden karakter illeszkedni fog az x-es sorra. Tehát a többi sort "kihagyja" (igazából nem hagyja ki, hanem az összes lehetőség illeszkedik a legelső lehetőségre, ami egy változó).
Erre egyébként minket a GHCI is figyelmeztet(csak figyelmeztet, tehát lefordul) a következő szöveggel:

```haskell
warning: [-Woverlapping-patterns]    Pattern match is redundant
```

Ebből az következik, hogy az 'a','b','c'-re is a "Nem tudom" lesz a válasz.

```c
*Main> charToName 'a'
"Nem tudom"
*Main> charToName 'b'
"Nem tudom"
*Main> charToName 'c'
"Nem tudom"
*Main> charToName 'd'
"Nem tudom"
```

Tehát nagyon fontos a sorrend!

```haskell
charToName :: Char -> [Char]
charToName 'a' = "Albert"
charToName 'b' = "Bela"
charToName 'c' = "Cecilia"
charToName x = "Nem tudom"
```

Így már jól fog működni.

<div id="joker"></div>

## Joker minták

Használtuk már a változókat és a típus specifikus mintákat, de mik is azok a joker minták? A változó és joker minden mintára illeszkedik
és a különbség közöttük annyiban merül ki, hogy a változókat feltudjuk ( felfogjuk) használni, míg a joker-t nem (nem is tudjuk!).
A változóknak ezért van nevük is, hogy tudjunk rájuk hivatkozni. Készítsük el a saját logikai ÉS függvényünket ezeknek a felhasználásával.

```haskell
myAnd1 :: Bool -> Bool -> Bool
myAnd1 True True = True
myAnd1 False True = False
myAnd1 True False = False
myAnd1 False False = False

myAnd2 :: Bool -> Bool -> Bool
myAnd2 True True = True
myAnd2 False _ = False
myAnd2 _ False = False

myAnd3 :: Bool -> Bool -> Bool
myAnd3 True x = x
myAnd3 _ _ = False
```

A függvényünket úgy készítettük el, hogy a mintákat kombináltuk. Az első paraméternek igaznak kell lennie,
hogy az első mintára illeszkedhessen hiszen az x mindenre illeszkedik. A második paramétertől függ az eredmény,
mert ha hamis a második akkor hamis az eredmény, (igaz ÉS hamis = hamis) és ha igaz akkor igaz (igaz ÉS igaz = igaz).
A második mintában jokereket használtunk,mert tudjuk, hogy ha már az első Hamis akkor a logikai ÉS sem lehet más csak hamis. Fontos itt kitérni a Haskell
kiértékelési stratégiájára. A második sorban a jokereket nem kell kiértékelje, csak visszaadnia a False-t így simán lehet az, hogy például 0-val való osztásra is tud eredményt adni.
myAnd False (1/0 == 5). Ez azért jó mert végtelen függvényekre és végtelen listákra is ad eredményt a függvényünk.

## Listák

Jelölések:

* Üres lista minta: [ ]
* Egyelemű lista minta: [a]
* Kételemű lista minta: [a, b]
* …
* Nemüres (legalább Egyelemű) lista minta: (a:b)

A lista két alapvető konstruktora amiből felépíthető a többi az a '[ ]' üreslista és a ':' .
Például az egyik gyakori minta listákra az ( x : xs). Ahol az x és xs változók, tehát lehetne akár (xs : x) vagy (fejelem : listatobbi),
illetve ezzel tudjuk a lista hosszát is ellenőrizni a következőképpen: legyen a lista (a : b : c : xs),
ahol a az első elem, b a második elem, c a harmadik elem és xs a lista maradéka. Ennél a példánál a lista csak akkor illeszkedik a mintára,
ha legalább három elemű. Ebből következik, hogy a legalább 4 elemű lista jelölése: (a : b : c : d : xs) és a legalább 2 elemű lista jelölése: (a : b : xs) Megjegyzés: A lista mintákat zárójelbe kell tenni, tehát a használata a következő: (x : xs). Fontos még tudni,
hogyha a lista egyelemű akkor az (x : xs) kifejezésben az x a lista első elemét, az xs pedig a '[ ]' üres listát jelenti. Értelemszerűen a legalább 2,3,4..n listákra is ez igaz, hogy az utolsó változó minta a '[ ]' üres listát jelenti.

Következő feladatként készítsük el a saját head függvényünket, ami a lista első elemét adja vissza.

```haskell
myHead1 :: [a] -> a
myHead1 [] = error "ures listanak nincs elso eleme"
myHead1 (x:xs) = x

myHead2 :: [a] -> a
myHead2 [] = error "ures listanak nincs elso eleme"
myHead2 (x:_) = x
```

Egy másik feladatban használjuk egyszerre mind a három mintafajtát és döntsük el egy listáról, hogy 0 az első eleme-e.
Itt is megfigyelhető, hogy a Haskell kiértékelési stratégiájának köszönhetően végtelen listákra is működik. isZeroFirst [0..], isZeroFirst [4..]

## Rendezett n-es véges listák

Például a rendezett pár (tuple) egy rendezett 2-es lista. Leggyakoribb jelölése: (a, b), ahol ’a’ az első elem és ’b’ a második elem. A hagyományos listáktól eltérően nem homogén. Tehát az elemek lehetnek különböző típusúak például: (1, "alma"), ettől függetlenűl ha egy paraméter nem homogén rendezett párt vár például a fent említett (Int, String)-et, akkor nem kaphat paraméterül egy (String, Int)-et. Például az (1, "alma") jó paraméter, míg az ("alma", 1) hibát fog kiváltani.
Készítsünk egy olyan függvényt, ami egy rendezett pár (tuple) elemeit felcseréli.

```haskell
swap :: (a,b) -> (b,a)
swap (a,b) = (b,a)
```

Példa a rendezett 3-as lista első és utolsó elemének felcseréléséhez:

```haskel
swap3 :: (a,b,c) -> (c,b,a)
swap3 (a,b,c) = (c,b,a)
```
