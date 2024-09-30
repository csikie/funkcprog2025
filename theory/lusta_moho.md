#Lusta/mohó kiértékelés

A Haskell nyelvben alapvetően két kiértékelési módot különböztetünk meg: a ***mohó*** (eager, strict), valamint a ***lusta*** (lazy) kiértékelési módokat. Mit is jelent ez pontosan?

##Mohó kiértékelés:
Belülről indul, a program először az argumentumok értékét számolja ki és csak ezt követően hajtja végre az adott függvényhez tartozó utasításokat, lépéseket.

##Lusta kiértékelés:
Mindig a legkülső kifejezés (redex) kerül először kiértékelésre. Az argumentumok értékét a program csak akkor számolja ki, ha a visszatérési érték megadásához feltétlenül szüksége van rá.

```
p :: Int -> Int -> Int
p x y = x + 8
```

```
p 7 (2^123)
```

Mohó kiértékelési stratégia esetén először a *7* és a *(2^123)* kifejezések fognak kiértékelődni.
+ A *7* önmagában egy teljesen kiértékelt forma (úgy nevezett normal form, erről a későbbiekben még lesz szó), egyelőre nincs vele több teendő.

+ A *2^123* -at viszont még ki kell számolni.

A hatványozás végrehajtása sok munkát igényel, ugyanakkor ha megnézzük a p függvény definícióját, láthatjuk, hogy a végeredmény kiszámításához nincs szükségünk az y értékének ismeretére, tehát feleslegesen dolgozik vele a program.


Lusta kiértékelési stratégiánál a program először végigszalad a kapott függvényen és mindent, ami nincs teljesen kiértékelve, "becsomagol" és ellát egy "nem kiértékelt kifejezés" címkével, ezáltal úgy nevezett csonkokat (thunk) hoz létre belőlük.

 A fenti kifejezésnél a 7-tel ebben az esetben sincs teendő, hiszen teljesen kiértékelt állapotban van, azonban a (2^123) bekerül egy ilyen csomagba. Mivel az eredményhez nincs szükségünk a hatványozás elvégzésére, ezért a p függvény azonnal meg tud hívódni és a (2^123) eldobódik, sosem kerül kiértékelésre.

Nézzünk meg egy másik példát:

```haskell
f :: Int -> Int
f x = x + x
```

```haskell
novel :: Int -> Int
novel y = 15 + y
```

Lusta kiértékelés | Mohó kiértékelés
------------------|-----------------
***f*** (novel 5) | f (***novel*** 5)
(***novel*** 5) + (***novel*** 5)| f (15 ***+*** 5)
(15 ***+*** 5) + (15 ***+*** 5) | ***f*** (20)
20 ***+*** 20 | 20 ***+*** 20
40 | 40

A novel függvény az *5*-öt, míg az f függvény a (*novel 5*) kifejezést kapta paraméterül. A két eset kiindulási helyzet azonos, de a kiértékelés eltérő módja miatt más úton fogjuk megkapni ugyanazt az eredményt.

**Lusta kiértékelés**
1. A program kívülről kezdi felbontani a kifejezést, vagyis jelen esetben az f függvénnyel indít. Mivel az f függvény a definíciója szerint a kapott argumentumot hozzáadja önmagához, ezért ezen a ponton egyelőre nem számít mi van a zárójelen belül. A program gondolkodás nélkül végrehajtja az f függvényhez rendelt lépéseket, vagyis hozzáadja a kapott argumentumot önmagához, aminek az eredménye a következő kifejezés lesz:*(novel 5) + (novel 5)*.
<br>

2. A következő lépésben ahhoz, hogy az összeadást el tudjuk végezni, ismernünk kell az értékeket, amiket össze szeretnénk adni. Tehát áttérünk a zárójelek felbontására. A lusta kiértékelést ebben az esetben is a függvénnyel kezdi a program, vagyis megnézi, majd behelyettesíti a novel függvényhez tartozó  lépéseket. Eredményül tehát azt kapjuk, hogy *(15 + 5) + (15 + 5)*.
<br>

3. Mivel a program nem tudja tovább halogatni a zárójelben lévő konkrét érték kiszámítását, ezért elkezdi az argumentumokat kiértékelni és elvégzi a hozzájuk tartozó műveleteket, amelynek eredménye: *20 + 20*.
<br>

Ezzel szemben a **mohó kiértékelés** rögtön tudni szeretné, hogy mi az az érték, amit az f függvény argumentumként kapott.

1. Elsőként tehát a zárójelben lévő kifejezéssel kezd foglalkozni, azonban mivel itt is egy kiértékelendő függvénnyel találkozik, először kénytelen az f függvényt átmenetileg félretenni és az újonnan talált novel értékét kiszámolni. Tehát mohó kiértékelésnél először a novel függvény lépései hajtódnak végre, ennek eredménye lesz az *f (15 + 5)*.
<br>

2. Mivel a mohó kiértékelés még mindig azt szeretné leginkább tudni, hogy mi az a konkrét érték, amit az f függvény argumentumként kapott, ezért a következő lépésben kiszámolja a (15 + 5) értékét, így a következő állapot amibe eljut a kiértékelés során, az *f (20)* lesz.
<br>

3. A program most már ismeri az f függvényhez tartozó konkrét értéket, így elkezd foglalkozni azzal, hogy mit is kellene tulajdonképpen csinálnia ennek a függvénynek. Ennek következtében megnézi és végrehajtja az f függvényhez tartozó lépéseket, tehát eljutottunk odáig, hogy a  mohó kiértékelés során is megkaptuk a *20 + 20* kifejezést.

Innentől a két kiértékelési mód azonos lépéseket hajt végre, kiszámítja az összeadás értékét, majd visszatérési értékként a 40-et adja meg.


## Előnyök – hátrányok

Mindkét kiértékelési módnak vannak előnyei és hátrányai, azonban ezek az előnyök és hátrányok attól függnek, hogy hol, miként és mire szeretnénk használni az adott programot.

Abban az esetben, ha végtelen listákkal, vagy folyamatos adatfolyamokkal kell dolgoznunk, a lusta kiértékelés lesz célravezetőbb, hiszen ebben az esetben a programnak nem kell látnia a lista végét ahhoz, hogy az elején lévő elemekkel el tudjon kezdeni dolgozni. Ezzel szemben egy ugyanilyen inputtal a mohó kiértékelés nem fog tudni mit kezdeni, hiszen mielőtt bármit is csinálna, mindent tudni szeretne a felhasználandó listáról és a benne lévő elemekről. Mivel jelen esetben végtelen listáról van szó, a mohó kiértékelés sosem fog ennek a folyamatnak a végére jutni, így a program ezen szakasza a végtelenségig fog futni.

Ha műveletigény szempontjából vizsgáljuk a fentebb leírt példát, akkor elmondhatjuk, hogy a mohó kiértékelés lesz a hatékonyabb, hiszen míg ebben az esetben a program minden elemet a lehető legkevesebbszer vizsgál meg és amint lehet, rögtön ki is számítja az értékét, addig a lusta kiértékelés a konkrét érték kiszámításának halogatásával olyan kifejezéseket hoz létre, amik ismétlődő elemekből állnak és ezeket az elemeket esetenként újra és újra ki kell értékelnie.

Általánosságban kijelenthetjük, hogy amennyiben egy függvénynek van tényleges visszatérési értéke, akkor ezt az értéket a lusta kiértékelés biztosan meg fogja találni, azonban a mohó nem feltétlenül jut el ugyanehhez a végeredményhez.

A kiértékelés folyamatának szemléltetéséhez nézzünk meg egy másik példát.

Mohó kiértékelés|Lusta kiértékelés
----------------|------------------
sumM :: (Foldable t, Num a) => t a -> a <br> sumM xs = foldl (+) 0 xs  | sumL :: Num a => [a] -> a <br> sumL [] = 0 <br> sumL (x:xs) = x + sumL xs
*Main> sumM [1,2,3,4,5] <br> 15 | *Main> sumL [1,2,3,4,5] <br> 15
sumM [1,2,3,4,5] <br> foldl' (+) 0 [1,2,3,4,5]  -- (0 + 1) <br> foldl' (+) 1 [2,3,4,5]     -- (1 + 2) <br> foldl' (+) 3 [3,4,5]        -- (3 + 3) <br> foldl' (+) 6 [4,5]           -- (6 + 4) <br> foldl' (+) 10 [5]            -- (10 + 5) <br> foldl' (+) 15 []              -- (15) <br> 15 | sumL [1,2,3,4,5] --> <br> 1 + (sumL [2,3,4,5]) --> <br> 1 +(2 + (sumL [3,4,5])) --> <br> 1+ (2 + (3 + (sumL [4,5])))--> <br> 1+ (2 + (3 + (4 + (sumL [5]))))--> <br> 1+ (2 + (3 + (4 + (5 + (sumL [])))))--> <br> 1+ (2 + (3 + (4 + (5 + 0))))--> <br> 1+ (2 + (3 + (4 + 5)))--> <br> 1+ (2 + (3 + 9))--> <br> 1+ (2 + 12)--> <br> 1+ 14--> <br> 15
*Main> sumM [1..10000000] <br> 50000005000000 | *Main> sumL [1..10000000] <br> *** Exception: stack overflow

## Kiértékelési "csalások"

A Haskell alapvetően lusta kiértékelési stratégiára építkezik, azonban akadnak olyan esetek, amikor hatékonyság szempontjából a mohó kiértékelés célravezetőbb. Ilyen eset pl. az alapvető matematikai műveletek elvégzése, vagy alap esetben a mintaillesztés.

Előfordulhatnak azonban olyan esetek, amikor valamilyen oknál fogva mi magunk szeretnénk eldönteni, hogy az egyes elemek lusta vagy éppen mohó módon legyenek kiértékelve, vagy csak egyszerűen szeretnénk kihasználni az egyes kiértékelési módok előnyeit. A Haskell erre is lehetőséget ad:


### Lusta mintaillesztés:

Mint azt már említettük, a mintaillesztés alapvetően mohó kiértékeléssel zajlik. Természetesen ez alól is vannak kivételek.
**Where** és a **let in** használatát követően a mintaillesztés lustává válik.
A **~** segítségével megadhatjuk a programnak, hogy az adott mintát lusta módon értékelje ki

A lusta mintaillesztésre minden típus-helyes kifejezés illeszkedik. Amikor a *~* jellel megváltoztatjuk a kiértékelés típusát, akkor jelezzük a fordítónak, hogy az adott helyen lesz majd egy olyan érték, amit ő ugyan még nem lát, de amikor kelleni fog, az az érték a rendelkezésére fog állni. A fordító "elhiszi" nekünk ezt ,az információt, így minden további szűrés nélkül folytatja a munkáját. Emiatt azonban a mintában lévő kifejezés lényegében egyelőre nem lesz sem ellenőrizve, sem kiértékelve. Ha a program eljut abba a fázisba, hogy szüksége van az adott értékre és mi valóban "igazat" mondtunk, akkor minden gond nélkül fut tovább. Azonban ha valami miatt a várt érték mégsem áll rendelkezésre, akkor futás idejű hibát fogunk kapni.

Nézzük meg az alábbi palindromize elnevezésű függvény két változatát, ami a paraméterként kapott palindrom kifejezést változatlan formában visszaadja, a nem palindrom kifejezésekből viszont palindrom kifejezést hoz létre.

Egy kifejezés akkor palindrom, ha visszafelé olvasva önmagát adja. Pl. "kék", "Kész a szék.", stb..

**Lusta mintaillesztéssel**

```haskell
palindromize :: Eq a => [a] -> [a]
palindromize l = pal l ++ (drop (length (pal l)) l) ++ reverse (pal l)
   where pal l@(~(x:xs))
          | l == reverse l = []
          | otherwise = x: pal xs
```


**"Sima" mintaillesztéssel:**

```haskell
palindromize :: Eq a => [a] -> [a]
palindromize l = pal l ++ (drop (length (pal l)) l) ++ reverse (pal l)
   where pal l@(x:xs)
          | l == reverse l = []
          | otherwise = x: pal xs
```

Normál paraméter megadása esetén mind a két függvény jól végrehajtódik és azonos eredményt adnak. Azonban ha bemenő paraméterként üres listát adunk meg, akkor a normál mintaillesztés esetén – mivel az üres lista nem illeszkedik a (x:xs) mintára – a program Exception-t dob. Ezzel szemben a lusta mintaillesztést alkalmazó verzió gond nélkül visszaadja eredményül az üres listát. 

Ennek az az oka, hogy a lusta mintaillesztés miatt a program csak annyit érzékel, hogy minta szerint paraméterül egy listát kell kapnia. Az üres lista is lista, ennél tovább azonban a fordító nem vizsgálódik. Elhiszi nekünk, hogy amikor neki szüksége lesz majd erre a listára, akkor az rendelkezésére fog állni a megfelelő elemekkel, így ebben az esetben sosem ellenőrződik le, hogy a kapott lista valóban illeszkedik-e az adott mintára. Mivel a szükséges helyen a program megkapja a megígért listát (jelen esetben az üres listát), ezért a kapott értékkel folytatódik a kiértékelés és a
"| l == reverse l = []" ág miatt visszatérési értékül megkapjuk az üres listát.


### Seq függvény:

Vannak olyan esetek, amikor – bár alap esetben lusta mintaillesztés történne – mégis valami miatt a mohó kiértékelésre lenne szükségünk. Erre a problémára, illetve a szükségtelen lustaság elkerülésére nyújthat alternatív megoldást a seq függvény.

```haskell
seq :: a -> b -> b
```

A függvény működését a következőképpen lehet reprezentálni:

```haskell
_|_ `seq` b = _|_
a `seq` b = b
```

A ``_|_`` (bottom) jelölést akkor használjuk, ha az adott kifejezésnek nincs valós visszatérési értéke. Ilyen lehet pl. ha hibás a kifejezés vagy ha végtelen ciklusba kerül a program, ekkor ugyanis nem fogunk konkrét visszatérési értéket kapni.

Ha megnézzük a seq függvény működését, láthatjuk, hogy két paramétert kap értékül. Amennyiben az első paraméter valamilyen oknál fogva nem rendelkezik visszatérési értékkel, akkor a seq függvény sem fog visszaadni semmit. Ha azonban az első paraméter kapcsán nem áll fenn ilyen jellegű probléma, akkor a függvény a második paraméter értékével fog visszatérni.

A seq függvény működésével kapcsolatban érdemes megjegyezni, hogy önmagában a függvény azt nem garantálja, hogy az első paraméter hamarabb fog kiértékelődni, mint a második. Az egyetlen garancia a függvény részéről csak annyi, hogy mielőtt a függvény visszatérne egy értékkel, az első és második paramétere is kiértékelődik, azt azonban nem mondja meg, hogy ez a kiértékelés milyen sorrendben történik meg.


### ! (Bang Patterns):
Lusta helyett mohóvá teszi az adott minta kiértékelését. Lényegében ugyanazt csinálj mint az imént taglalt seq függvény.


### Normal form / Weak head normal form

A kifejezések kiértékelése során két eltérő állapotot különböztetünk meg:

Normal form-ról beszélünk akkor, ha a kifejezés teljesen kiértékelődik, nem található benne több elvégezhető művelet vagy függvényhívás, amit tovább lehetne bontani. Ezzel szemben a Weak head  form nem feltétlenül törekszik a kifejezés teljes kiértékelésére.

Weak head normal form esetén 3 alapesetet különíthetünk el. Amennyiben a kifejezésben konstruktor, parciális applikáció, lambda kifejezés található, a program csak addig jut el biztosan, hogy ezek első előfordulását megállapítja, ezen felül azt hogy, ezekhez milyen argumentumok vagy egyéb elemek tartoznak, már nem feltétlenül veszi számításba.


##Gyakorló feladatok

###1. Feladat:
Adottak az alábbi függvények:

```haskell
f :: Int -> Int -> Int
f x y = x * y

g :: Num a => a -> a -> a
g x y = x + 7;

```

Lesz-e tényleges eredményük az alábbi függvényhívásoknak?
- Ha nem, akkor fordítási vagy futtatási hibát kapunk?
- Ha igen, akkor mi lesz a konkrét eredmény?

1) ``f 2 5``
2) ``g (-6) 0``
3) ``g 0 6``
4) ``f 1.2 412``
5) ``g (f 10 32) 9``
6) ``f (g 3.1 8.2) (g 1.9 0)``
7) ``(g 13 6.5 + 25 - realToFrac (f 4 2) - 7) / 5``
8) ``fromIntegral(120 `div` (f 6 4) * 2) - (g 13.0 26.2 + g (-17.0) (-13.4))``
9) ``f (g 3 ((f 0 0 + f 2 9 - g 9 1)`mod` 12)) 36`` 
10) ``((210 `mod` f (g 0 (g (g 13 5) (g 13 5))) 2) + (f 3 (f (f 1 1) 2))) `div` f ((g (-14) 13) + 7) 21``

###2.Feladat:
Adottak az alábbi függvények:


```haskell
h :: Bool -> Bool -> Bool
h _ y =  y || y

i :: Bool -> Bool -> Bool
i x y = (x /= True) == y

j :: Bool -> Bool
j x = not x
```

Mi lesz az eredménye az alábbi függvény hívásoknak?

1) ``h True False || h False True``
2) ``i (i (i True True) False) True``
3) ``j True && h False (not False)``
4) ``False && i False False || j False && j False``
5) ``i (j True) (h True False) && j True || j False``
6) ``False || i False True || h True True``
7) ``i True (j True) == h ( i True True) (j True)``
8) ``h True False == False || True && j False == False || True``
9) ``(False /= True || i False True == not (j False) && h (not True) False) && not (j False)``
10) ``not (not (j True)) || (h True False) == i True True && False /= j True``

###3. Feladat

Mi lesz az eredménye az alábbi függvény hívásoknak?

1) ``(head (' ' : "Haskell") == 'H') /= (110 `mod` 5 == 0)``
2) ``2^10 `div` head (take 2 [0,2,20])``
3) ``sum (filter even [0,1,2,3,4,5,4,3,2,1,0])``
4) ``fromIntegral (div 0 5) / 0.0``
5) `` (&&) (all odd [0,1,3,7,3]) (length (nub [1,2,1,1,2,1,2]) == 2))``

###Megoldások

Sorszám| 1. Feladat     | 2. Feladat | 3.Feladat
-------|----------------|------------|------------
**1.** | 10             |True        |True
**2.** | 1              |True        |futási hiba
**3.** | 7              |False       |12
**4.** | fordítási hiba |True        |NaN
**5.** | 327            |True        |False
**6.** | fordítási hiba |True        |
**7.** | 6.0            |False       |
**8.** | 0              |True        |
**9.** | 360            |False       |
**10.**| futási hiba    |False       |

##Kitekintés
A lusta- és mohó kiértékelési stratégia nem csak a funkcionális nyelvekben van jelen. Megtalálható a Java-ban, C-ben, C#-ban és lényegében az összes programozási nyelvben. Itt most a Java-ban használt elemekre mutatunk 1-1 példát.

A Java mohó kiértékelést használ függvényhívásoknál és egyes operátoroknál. Ilyenkor az argumentum vagy operandus értékelődik ki először és csak utána a művelet.

```java
int a = 10;
int b = 20;
int c;

c = a + b;
c.toString();
```

Léteznek a Java-ban lusta operátorok is, pl.: ``&&``( ÉS operátor), ``||``(VAGY operátor).

```java
if(a == b && a != 20) {
   System.out.println("Az első kifejezés hamis");
} else if (b == 20 || a == 20) {
   System.out.println("Az első kifejezés igaz");
}
```
+ A ``&&`` csak akkor ad vissza ``true`` értéket, ha mind a két kifejezés ``true`` értékű. Ha az első kifejezésról megállapítja, hogy ``false``, akkor a másodikat már nem fogja kiértékelni, mivel az eredmény mindenképpen csak ``false`` lehet.

+ A ``||`` akkor ad vissza ``true`` értéket, ha a kapott kifejezésekből legalább az egyik értéke ``true``. A fenti példában nincs szükséges kiértékelni a ``a == 20`` kifejezést, mivel a ``b == 20`` ``true``-val tér vissza, ezért a ``||`` operátorhoz tartozó logikai vizsgálat a második kifejezéstől függetlenül is biztosan ``true`` értéket fog adni.


##Felhasznált irodalom

http://lambda.inf.elte.hu/Index.xml
http://learnyouahaskell.com/chapters
https://tech.fpcomplete.com/blog/2017/09/all-about-strictness/
https://mmhaskell.com/blog/2017/1/16/faster-code-with-laziness
https://www.schoolofhaskell.com/school/starting-with-haskell/introduction-to-haskell/6-laziness
https://www2.cs.sfu.ca/CourseCentral/383/tjd/haskell_lazy_and_strict.html
https://www.reddit.com/r/haskell/comments/9z6v51/whats_the_difference_between_head_normal_formhnf/
https://riptutorial.com/haskell/example/17344/normal-forms
https://takenobu-hs.github.io/downloads/haskell_lazy_evaluation.pdf
https://medium.com/@aleksandrasays/brief-normal-forms-explanation-with-haskell-cd5dfa94a157