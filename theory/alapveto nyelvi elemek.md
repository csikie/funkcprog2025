# Alapvető nyelvi elemek

## Egysoros megjegyzés:

```hs
-- megjegyzés a sor végéig
```

Az egysoros megjegyzések a -- jelekkel kezdődnek, és a sor végéig tartanak.

## Többsoros megjegyzések:

```hs
{- több
soros
megjegyzés -}
```

A többsoros megjegyzéseket a {- és -} jelek határolják. A többsoros megjegyzések egymásba ágyazhatók.

## Konstansdefiníciók:

Egyszerűen fogalmazva a haskellben nincsenek olyan változók, amiket imperatív nyelvekben megszokhattunk (pl.: int x = 2).  
Konstansokat azonban van lehetőségünk létrehozni, amelyek értékei nem változtathatók meg.  
Pl.: x = 0

Ha létrehozunk egy ilyen konstanst a kódunkban és aztán annak új értéket akarunk adni, az nem megengedett. A fordító figyelmeztetni is fog, hogy nem lehetséges a többszörös deklaráció. Ezt nevezzük single assignmentnek.  
Definiáláskor nem szükséges meghatároznunk a konstans típusát, mert ezt a fordító magától is kitalálja, azonban megtehetjük.

Pl.:

```hs
alma :: String  -- az alma legyen String típusú
alma = “apple”  -- az alma értéke az “apple” legyen
```

## Függvények

A függvények meghatározott típusu kifejezések. A haskelles függvények hasonlítanak a matematikából ismert függvényekhez, egy bemeneti halmazhoz egy kimeneti halmazt társítanak.
A függvényeket egy argumentumra alkalmazva mindig kapunk egy visszatérési értéket. Ugyanarra a bemenetre mindig ugyanazta a kimenetet fogják adni.

A haskellben minden függvény 1 paraméteres és 1 visszatérési értéke van. Ha olyat látunk, hogy egy függvény több paramétert vár, az valójában több egymásba ágyazott függvényként működik, amelyek mind 1 paraméteresek. Ezt nevezzük curryzésnek, amelyet mélyebben is fogunk vizsgálni egy későbbi részben.

A függvények a Haskellben is azt a célt szolgálják, hogy újra fel tudjuk használni bizonyos részleteit a kódunknak, ezzel megkönnyítve a dolgunkat.

Használatuk:  
A függvény neve kerül előre, majd az argumentumokat soroljuk fel szóközökkel elválasztva. Az argumentumokat nem rakjuk zárójelek közé és nem választjuk el őket vesszővel.

```
Prelude> not True
False

-- A not egy 1 paraméteres függvény, amely visszaadja a kapott kifejezés tagadását.
```

```
Prelude> max 12 5
12

-- A max függvény visszaadja a két megadott érték közül a nagyobbat.
```

Amikor a kódunkban, másik függvényeken belül használunk függvényeket, teljesen ugyanez a szintaxis.

## Függvények definiálása:

Természetesen saját függvényeket is tudunk írni, a következőkben erről lesz szó.

Kezdjük egy egyszerű függvénnyel, amely egy számhoz hozzáad egyet.  
Jelen esetben ez egy egyparaméteres függvény lesz, típus nélkül:

```hs
f x = x + 1
```

_Itt az egyenlőségjel nem értékadást és nem is egyenlőség vizsgálatot jelent._ Definiáló egyenlőséget használunk, amely a bal oldalon lévő kifejezés jelentését tisztázza jobb oldalon.

Az egyenlőségjel bal oldalán:

- **f** a függvény neve,
- **x** a függvénynek adott formális paraméter.

A jobb oldalon pedig a függvény törzse látható. Itt tudjuk megfogalmazni a kívánt kifejezést, a kívánt működés eléréséhez.

Minden függvénynek van egy típusszignatúrája, amit mi most nem határoztunk meg, de ezt a fordító okosan el is tudja dönteni magának a legtöbb esetben.  
Kérdezzük meg, milyen típust vezetett le a fordító. Erre használhatjuk a :t-t

```hs
:t f
f :: Num a => a -> a
```

Az ilyen típusmeghatározásokat a következőképp kell értelmezni:

- Legelöl a függvény neve **_f_**
- A **::** alatt azt érthetjük, hogy az **_f_** függvény a következő típussal rendelkezik...
- Majd, ha előbb a sima nyilakat nézzük (**->**):  
  **a -> a**  
  Ezek a nyilak jelölik, hogy a kapott paraméterekkel a függvény milyen értéket ad vissza. Tehát például egy valamilyen típusú _**‘a’**_ paramétert kap a függvény és egy ugyanilyen típusú értéket kapunk vissza, azaz ugyanúgy _**‘a’**_-val jelölve látható, hogy a visszakapott érték típusa a kapott paraméter típusával egyezik meg.
- A kettős nyíl (=>) előtt meghatározhatjuk, hogy az utána lévő értékek milyen típusúak. Ezt nevezzük megszorításnak.  
  **Num a =>**  
  Itt egy csoportot/halmazt adhatunk meg. Ez tehát azt jelenti, hogy a => után használt _**‘a’**_ paraméterek a **Num** típusosztályból származó típusú értékek lesznek. A típusosztályokat később tárgyaljuk, jelen pillanatban elég, ha ezt úgy értelmezzük, hogy a **Num** numerikus értékeket jelöl.

## Kétparaméteres függvény, típussal:

```hs
g :: Integer -> Integer -> Integer
g a b = a * b
```

A függvényeknek mi is meghatározhatjuk a típusát. Jelen példában két paramétert kap a függvény és láthatjuk, hogy itt már 3 típusmeghatározás szerepel a típusszignatúrában.  
A legutolsó nyíl után szerepel a visszatérő érték típusa. Ez előtt pedig sorban a kapott paraméterek.  
Az Integer -> Integer -> Integer tehát azt jelenti, hogy a két kapott paraméterünk Integer típusú és a függvény egy Integer típusú értéket ad vissza.

Ezt a kétparaméteres függvényt a következőképp alkalmazhatjuk:

```
g 2 3       -- eredmény: 2
```

Azaz a függvény neve után írjuk a két számot, amit paraméterként adunk át a függvénynek.  
Ebből látható az is, hogy a függvény definiálásakor ezt gyakorlatilag ugyanígy írtuk az egyenlőségjel bal oldalára, viszont mivel nem tudjuk milyen számot fog kapni a függvény ezért azokat elneveztük a-nak és b-nek.

A függvény definiálásakor meg lehetne adni egy konkrét számot:  
pl.: g 3 b = 0, ami azt jelentené, hogy bármikor amikor egy 3-as számot adunk át első paraméterként, a függvény 0-át ad vissza).  
Ezeket nevezzük mintaillesztésnek, amelyről később még bőven lesz szó.

Eddig láthattunk egyszerű függvényeket a típus meghatározásával és egy egyszerű definícióval.  
Azonban egy függvényt több sorban is tudunk definiálni, amelyekben megadhatjuk, hogy különböző esetekben hogyan működjön a függvény.  
A sorok egymás után kell, hogy elhelyezkedjenek, ezt nem szakíthatja meg egy másik függvény definíciója vagy konstansdefiníció. (_Természetesen a kommentek ez alól kivételt képeznek_)

## Függvény- és változónevek

Az elnevezéseknél fontos odafigyelnünk a kis- és nagybetűkre, mert ezeket a haskell megkülönbözteti, ráadásul nem mindegy, hogy hogyan kezdjük az egyes elemink neveit.  
A függvény- és változónevek betűkből és számokból állhatnak és kisbetűvel vagy \_-al **kell** kezdődniük. Valamint tartalmazhatják az aláhúzás és az egyszeres idézőjel karaktereket is: f_1, f', f''.

## Operátorok

Az előbbi függvényeknél láthattuk, hogy azokat prefix módon tudjuk használni, azaz a kifejezés elején szerepel a függvény neve és utána a paraméterek.

```
Prelude> id 4       --az id függvény visszaadja a paraméterként kapott értéket
4
```

Amikor például két számot adunk össze a '+' operátort használjuk, és ezt úgy tesszük, hogy a két operandus közé írjuk az operátorunkat.  
Az ilyen operátorok is függvények, azonban nem prefix, hanem infix módon alkalmazzuk őket.

```
Prelude> 1 + 2
3
```

Akár a függvényeinket is tudjuk operátorként használni. Ezt úgy tehetjük meg, hogy függvény nevét a két operandusunk közé írjuk infix módon, akárcsak egy aritmetikai operátornál, annyi változtatással, hogy két "kis felső vonást" (Másnéven: _backtick_, _backquote_. Magyar billentyűzetkiosztáson az **_AltGr + 7_** billentyűkombinációval érhetjük el.) alkalmazunk:

```
Prelude> 20 `div` 4     --a div függvény két egész szám osztására alkalmazható
5
```

Ilyen használat esetén a függvény alapvetően **infixl 9** tulajdonságokat kapja meg, ha mi nem adtunk meg neki mást. (Ezekről a tulajdonságokról és beállításukról a _Kötés és kötési erősség_ résznél lesz szó)

Azonban, ha operátorként szeretnénk használni függvényünket, erre jobb megoldás, ha ezt definíció során jelezzük neki.

## Operátorok definiálása:

Saját operátorokat is létre tudunk hozni, amelyeket így infix módon tudunk alkalmazni.  
Az operátornevek nem ASCII szimbólumokból és a következő ASCII szimbólumokból állnak: !?.#$%@&\*+-~^/|\<=>:  
Ezeket a karaktereket bármilyen kombinációban, egyszerre akármennyit, akár többször is felhasználva alkalmazhatjuk.  
Mivel már vannak definiálva operátorok a nyelvben, ezért kivételt képeznek a következők: =, .., |, <-, ->, =>, ::, \, @, ~.

```hs
(|*-*|) :: Double -> Double -> Double
a |*-*| b = a * b + 1
```

```
*Main> 3.5 |*-*| 2.0
8.0
```

Az operátor definiálásakor a típusban zárójelek közé kell tennünk magát az operátort, majd a definíció során, mivel az operátorokat infix módon használjuk, ezért az operátort a két paraméter közé kell írnunk.

Ugyanakkor az operátorokat is lehet prefix módon alkalmazni, ha zárójelek közé tesszük és utána kapja meg a paramétereket.

```
Prelude> (*) 4 3
12
```

A prefix módon használt operátorok kötési erőssége a függvényalkalmazások erősségével egyezik meg (azaz a legerősebb).

Függvényként definiálás is lehetséges, ha ugyanúgy írjuk meg a definíciót, ahogy az előbbi alkalmazásban is látható:

```hs
(/*-*/) x a = a+2+x
```

Ez ugyanúgy működik fordítva is, azaz függvényt is lehet operátorként definiálni a _backtick_ használatával.

A fentebb megírt függvényen bemutatva:

```hs
g :: Integer -> Integer -> Integer
a `g` b = a * b
```

## Kötés és kötési erősség

A matematikából már ismertek lehetnek ezek a tulajdonságok, mint asszociativitás és precedencia.
A ghci-től kérhetünk információkat egy adott függvényről (vagy operátorról) a :info (röviden :i) parancs használatával.

```
Prelude> :info (+)
class Num a where
  (+) :: a -> a -> a
  ...
        -- Defined in `GHC.Num'
infixl 6 +
```

Az :info kiírja nekünk az operátor (vagy függvény) típusát és a kötést és kötési erősséget, ha rendelkezik ilyenekkel.

Egy operátor kötése lehet:

- **infix**  
  Nemkötő (nincs meghatározva az asszociativitás), csak azt jelzi, hogy infix az operátorunk.
  Ebben az esetben, ha zárójelezés nélkül alkalmazzuk egymás után az operátort többször egy kifejezésben, a fordító hibát fog jelezni, mivel az azonos precedencia miatt nem tudja melyik kiértékelést hajtsa végre hamarabb.
- **infixl**  
  Balra kötő (bal asszociatív), infix operátor.
- **infixr**  
  Jobbra kötő (jobb asszociatív), infix operátor.

A kötési erősséget, avagy precedenciát, egy **0-9** közötti szám jelöli.
Mindig a nagyobb erősségű operátort fogja először alkalmazni a program.

Operátor kötésének és kötési erősségének beállítása az infix, infixl, infixr kulcsszavakkal:

```hs
infixr 7 |*-*|
```

```
*Main> :info |*-*|
(|*-*|) :: Double -> Double -> Double
infixr 7 |*-*|
```

## Margó szabály

Haskell kód írásakor oda kell figyelnünk a sortördelésekre és behúzásokra.  
Ha egy kifejezést új sorban szeretnénk folytatni nem elegendő, ha ez csak így megtesszük. A sor megtörése után az új sor elejét bentebb kell kezdenünk legalább 1db szóközzel, hogy a fordító úgy értelmezze, ahogy mi szeretnénk.
Pl.:

```hs
-- hibás kód
plusplus x =
x + 1

--helyes kód
plusplus x =
 x + 1
```

A fordító azért is szólni fog, ha egy sort csak úgy bentebb kezdünk.  
Az összetartozó kódrészletek egy "szinten" helyezkedjenek el. Ez például őrfeltételeknél elég látványosan alkalmazható.  
A későbbiekben ez a szabály mégfontosabb lesz, ha átlátható kódot szeretnénk írni.
