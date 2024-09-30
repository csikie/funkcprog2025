# ESETSZÉTVÁLASZTÁS

## Bevezetés

Míg a mintákat (és a mintaillesztést) arra használjuk, hogy megbizonyosodjuk arról, hogy az érték valamilyen
formában megfelel-e ( például egy konkrét szám) és dekonstruáljuk azt (például listákat fejelemre és maradék részre bontjuk: x:xs),
az esetszétválasztás során különböző feltételek mentén vizsgáljuk, hogy a paramétereink közül valamelyik (vagy akár több is)
megfelel-e egy bizonyos kritériumnak, tehát igaz vagy hamis.

## Őrfeltételek (guards)

Az őrfeltételek mondhatni az `if` és a `case` kifejezések ötvözete. A `case` kifejezésre azért hasonlít mert a kifejezéshez/értékhez 2 vagy több lehetséges ág ( tehát nem csak igaz-,hamis-ág) tartozhat. És az `if` kifejezésre azért hasonlít mert ezeknek a kifejezéseknek muszáj logikai értékkel rendelkezniük, hiszen ez alapján dönti el, hogy az az ág legyen a visszatérési érték.  
A gyakorlatban így néz ki:
-függvényünk neve változókkal-
| <kifejezés> = <visszatérési érték>
..
| <kifejezés> = <visszatérési érték>
| <peldaul: otherwise> = <visszatérési érték>
Az `if` kifejezéssel ellentétben itt nem kötelező a "hamis" ág és lehet úgy is csinálni a kifejezést, hogy mindig teljesüljön, például a lekezeletlen/váratlan helyzetekre. Erre az esetre az "otherwise" (egyébként) kulcsszót szoktuk használni ( de lehetne simán csak True-t is).
A felépítése úgy működik, hogy egy "`|`" (AltGr+w) után egy egyenlőség található jobb és bal oldallal. A bal oldalon a kifejezésnek egy logikai értékkel kell visszatérnie és ha az True (tehát igaz) akkor az egyenlőség jobb oldala lesz a mi függvényünk visszatérési értéke, különben megy tovább.
Fontos megjegyezni, hogy a függvény neve és paraméterei után nincs "=" !
Tekintsük meg ehhez a következő testtömegindexes feladatot.

```haskell
bmiIndex :: Double -> String
bmiIndex bmi
     | bmi <= 18.5 = "Alultaplalt vagy!"
     | bmi <= 25.0 = "Normalis testsuly!"
     | bmi <= 30.0 = "Tulsulyos vagy!"
     |otherwise    = "Sulyosan elhiztal!"
```

## Láthatóság (where)

Haskellben lehetőségünk van egy függvényünkhöz változókat és segédfüggvényeket írni. Ehhez használhatjuk például a where kulcsszót. Nézzük meg az elöző testömeg indexes feladatot, de most nem az index alapján, hanem számoljuk ki a testsúlyunk és a magasságunk függvényében.

```haskell
bmiTell :: Double -> Double -> String
bmiTell weight height
    | weight / height ^ 2 <= 18.5 = "Alultaplalt vagy!"
    | weight / height ^ 2 <= 25.0 = "Normalis testsuly!"
    | weight / height ^ 2 <= 30.0 = "Tulsulyos vagy!"
    | otherwise                   = "Sulyosan elhiztal!"
```

```haskell
bmiTell2 :: (RealFloat a) => a -> a -> String
bmiTell2 weight height
    | bmi <= 18.5 = "Alultaplalt vagy!"
    | bmi <= 25.0 = "Normalis testsuly!"
    | bmi <= 30.0 = "Tulsulyos vagy!"
    | otherwise   = "Sulyosan elhiztal!"
    where bmi = weight / height ^ 2
```

Ahogy jól látható az őrfeltételünkben egy (később deklarált) változóra a **bmi**-re hivatkozunk, viszont a mi függvényünk két teljesen más változót, a **weight** és **height** használja. Erre azért van lehetőségünk mert a where(ahol) kulcsszó után értéket adtunk neki:

```haskell
where bmi = weight / height ^2
```

## Kiegészítés

## `If` kifejezés

Ez a kifejezés a legjobban az imperatív nyelvek `if` elágazásának felel meg. A legfontosabb különbség az az, hogy míg a Haskell esetében az `if` egy kifejezés (amely értékre konvertálódik),
addig az imperatív nyelvek `if` kifejezése egy utasítás(amely végrehajtásra kerül).
A gyakorlatban így néz ki:

```haskell
if <igaz vagy hamis kifejezés>
    then <igaz-érték esetén>
else <hamis-érték esetén>.
```

Na de nézzünk hozzá egy szemléltető példát is. Írjunk meg egy olyan függvényt ami eldönti egy számról, hogy páros vagy páratlan. Mivel azt fogjuk ellenőrizni, hogy páros legyen a függvényünk neve isEven.
Fontos tudni azt is, hogy `else` ág nélkül fordítási hibát kapunk, tehát hiába készítűnk egy olyan függvényt amiben az if után True-t írunk, ez a fordítónak nem elég, le kell kezelni a hamis ágat is.
(kep)
(kep)
Ahogy láthatjuk is elég hasonló az imperatív `if` utasításhoz. Itt is lehet else-if ágakat használni.
(kep)
Ebben a feladatban azt néztük, hogy egy szám osztható-e hárommal és öttel is. (Meglehetett volna egyszerűbben is oldani, de a szemléltetés kedvéért oldottam meg így)
