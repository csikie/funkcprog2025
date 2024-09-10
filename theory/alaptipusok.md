
# Alaptípusok
A típusok egy erőteljes módot adnak a rendszerezésre, osztályokba sorolásra, arra, hogy olyan formátumú részekre bonthassuk az adatokat, amelyekkel könnyebben, gyorsabban megírhatjuk a programunkat. Ezáltal egyszerűbb, átláthatóbb, könnyebben értelmezhető kódot tudunk előállítani.
A típusokat nagybetűs kifejezések jelölik (pl.: Int, Bool, String).

Úgy is értelmezhetjük őket, mint bizonyos értékek halmaza. Például az __Integer__ az egész számok halmazának tekinthető.

Számokat többféleképp tudunk raktározni a különböző feladatok érdekében, ahogy ezt máshol is megszokhattuk.

## Egész szám típusok
__Int__: Ez a típus igazából egy „szűkített” integer. Egész számokra használjuk. Nem rendelkezik törtrésszel. Az __Int__ kötött intervallummal rendelkezik, azaz van egy minimum és egy maximum értéke, amelyek a számítógéptől függenek.  
(Általában egy 64bites számítógépen a maximum értéke az __Int__ típusnak 9223372036854775807, a minimum -9223372036854775808.)


__Integer__: Ennek a típusnak nincsenek határai. Tehát nagyon nagy számokat is lehet velük ábrázolni. Pontosabban akkorát, amekkorát elbír a memória.


Az __Int__ és __Integer__ típusok tehát az egész számokat jelentik, azonban az __Int__ hatékonyabb.  

```
Példák egész számokra:
1
2
199
32442353464675685678
```
```
Nem egész számok:
1.3
1/2
```
## Nem egész szám típusok

A tizedestörteknél jellemző a lebegőpontos ábrázolás alkalmazása, aminek a lényege, hogy a tizedespont „lebeg”, vagyis az ábrázolható értékes számjegyeken belül bárhova kerülhet.
A lebegőpontos ábrázolás előnye a fixpontos számábrázolással szemben az, hogy sokkal szélesebb tartományban képes értékeket felvenni; a számokat reprezentáló adat mennyisége főként az ábrázolható számjegyek mennyiségét határozza meg, és sokkal kisebb mértékben az ábrázolható számok nagyságrendjét.

Példa erre az __1.23__, __12.3__, __123.0__, __1230__ számok, melyek mindegyike 3 értékes számjegyet tartalmaz.
Mivel ebben a példában ugyanazok az értékes számjegyek szerepelnek minden számban, ezért felírhatóak úgy is, hogy egyenlőnek tekinthetőek legyenek: __1.23e2__, __12.3e1__, __123.0__, __1230e-1__.
Látható, hogy a tizedesvessző helye változik csak. Az __e__ pedig az exponens, ami jelen esetben a 10 hatványait jelöli. (pl.: e2 -> 10^2)


__Float__: egyszeres pontosságú lebegőpontos szám.
```hs
circumference :: Float -> Float  
circumference r = 2 * pi * r
```
```
ghci> circumference 4.0  
25.132742
```
__Double__: dupla pontosságú lebegőpontos szám.
(dupla annyi bittel rendelkezik, mint a __Float__)
```hs
circumference' :: Double -> Double  
circumference' r = 2 * pi * r 
```
```
ghci> circumference' 4.0  
25.132741228718345
```

*Lebegőpontos számok esetén érdemes észben tartani, hogy felléphetnek kerekítési hibák, például:*
```
ghci> 1.1 - 1.0
0.10000000000000009
```

## Logikai típus
A Logikai típusok szinte elengedhetetlenek egy program írásakor, hiszen ezek segítségével tudunk feltételekkel dolgozni.

__Bool__: Logikai típus.  
Két értéke lehet: __True__ vagy __False__.
```
Prelude> :i Bool
data Bool = False | True        -- Defined in `GHC.Types'
```

## Karakter típus
Mivel sok esetben nem csak számokkal dolgozunk, létfontosságú a karakterek reprezentálása is, amelyek segítségével a karakterláncok (Stringek) is megvalósíthatók lesznek.

__Char__: Egy karaktert reprezentál. Két aposztróf között jelöljük.
```
Prelude> :t 'a'
'a' :: Char
```

## String
Ha már karakterek léteznek, a szöveg típusnak is elérkezett az ideje.

A __String__ karakterekből álló lista, azaz a __[Char]__ *alias*-a. (Tehát a __String__ a __[Char]__ szinonimája)

A Stringeket idézőjelekkel jelöljük:
```
Prelude> "ez egy szoveg"
"ez egy szoveg"
```
Ha lekérjük a típusát, látható, hogy egy karakterek listájaként értelmezi:
```
Prelude> :t "ez egy szoveg"
"ez egy szoveg" :: [Char]
```
Igazából megadhatnánk a következőképpen is:
```
Prelude> ['e','z',' ','e','g','y',' ','s','z','o','v','e','g']
"ez egy szoveg"
```
Itt érzékelhető, hogy miért kaptunk erre egy egyszerűbb módszert az idézőjelek által, hiszen nem lenne kellemes minden karakterhez plusz három billenytyűleütés mellékelése.
*Ezért lesz az idézőjelekkel írt szöveg __szintaktikus cukorka__.*


**Fontos** megjegyezni, hogy az __*'a'*__ és __*"a"*__ nem ugyanazt jelenti. Míg az előbbi egy karakter, az utóbbi egy Stringet jelöl.
```
Prelude> :t 'a'
'a' :: Char

Prelude> :t "a"
"a" :: [Char]
```


## Tuple
Most, hogy átnéztük az egyszerűbb típusokat, következhet ezek használata egy összetettebb verzióban.
A Tuple értékek felsorolását teszi lehetővé, amelyek akár különböző típussal is rendelkezhetnek. Így úgymond egy értékként adhatunk át több értéket egyszerre.

```
Prelude> :t ('a', 2::Int, 0.4::Double, "hello", True)
('a', 2::Int, 0.4::Double, "hello", True) :: (Char, Int, Double, [Char], Bool)
```

Ebben a példában látható, hogy egy felsorolásba pakoltunk egyész számot, nem egész számot, karaktert, stringet és logikai értéket is.  
Tulajdonképpen bármilyen értéket tehetünk egy Tuple-be, akár lehet benne Tuple vagy lista is. 
Egy tuple-t rendezett párnak nevezünk ha két elemet tartalmaz. Egyéb esetben rendezett n-es az elemek számának megfelelően.

Két különböző típusszignatúrával rendelkező tuple két teljesen különböző típusnak tekinthető. Ez ugyanígy elmondható a különböző méretűekre is.

## Lista
A lista is több értéket tárol, azonban a tuple-lel ellentétben a listák homogén típusúak, azaz csak azonos típusú elemeket tartalmazhatnak. Tehát lehet például egy Int-ekből álló vagy egy karakterekből álló listám, de nem lehet olyan, ami egy pár Int-et és egy pár karaktert tartalmaz. A méretük változhat a rajtuk végzett műveletek során.  
A listákat szögletes zárójelekkel jelöljük és az elemeket benne vesszővel soroljuk fel. Pl.: `[1,2,3]`.  
Üres lista: `[]`. Ez nagyon hasznos lesz a függvények írásakor.  
Akárcsak a Stringnél, a listák jelölése is *szintaktikus cukorka*, ugyanis például a `[1,2,3]` lista a következő kifejezésnek egyszerűsített alakja: `1:2:3:[]`.  
Tehát a `"hello"` szintaktikus cukorka arra, hogy `['h','e','l','l','o']`, ami pedig szintaktikus cukorka arra, hogy `'h':'e':'l':'l':'o':[]`.



A későbbiekben lesz szó a listagenerátorokról, amelyek nevéből is adódik, hogy listát tudunk generálni.


### Megjegyzések
A __minBound__ és a __maxBound__ függvények használhatók a kötött típusok minimum és maximum értékének lekérdezésére.  
Pl.:
```
Prelude> maxBound :: Int
```

Ahogy a típuslekérdezéseknél is láthattuk, a `::` jelöli, hogy milyen típussal rendelkezik az adott érték. Ezt alkalmazhatjuk akár az interpreterben, akár a kódunkban egy érték típusának kikötésére, amikor nem szeretnénk, hogy a fordító önállóan döntse el azt helyettünk.
Pl.: A **2** lehet Int, Double, Float, stb.


A tuplenek elméletben nincs korlátozott mérete, azonban a legtöbb implementáció a haskellben maximum 15 elemű tuple-re van értelmezve. (A 15-nél több elemű tuplere az alapértelmezett kiíratás sem működik.)

Egy lista lehet végtelen elemű is.