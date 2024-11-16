# Hajtogatások
A hajtogatásokra úgy is lehet fondolni, mint egy zárójelezésre valamelyik oldalról. 2 féle hajtogatás van, jobb és bal oldalról, nevezetesen `foldr` és `foldl`. Ahogy a többi magasabb rendű függvények, a hajtogatások is arra alapulnak, hogy egy előre megírt vázt alkosson. Írjuk meg először rekurzívan a `sumAll` függvényt, ami egy számokból (jelen esetben egészekből) álló listát kap paraméterül és összeadja az elemeit utána a `multiAll` ami egy számokból (jelen esetben egészekből) álló listát kap paraméterül és összeszorozza az elemeit.

```haskell
sumAll :: [Int] -> Int
sumAll [] = 0
sumAll (x:xs) = x + sumAll xs

>sumAll [1..10] --szétbontva: (1+(2+(3+(4+(5+(6+(7+(8+(9+(10+0))))))))))
>55


multiAll :: [Int] -> Int
multiAll [] = 1
multiAll (x:xs) = x * multiAll xs

>multiAll [1..10] --szétbontva: (1*(2*(3*(4*(5*(6*(7*(8*(9*(10*1))))))))))
>3628800
```

Észrevehető, hogy elég hasonló a két függvény, mindkettő a függvény első elemét adja hozzá/szorozza a további lista eredményéhez. Ezek alapján már megpróbálhatjuk megírni a `fold` függvényt, de felmerülhet pár probléma. Amikor leáll a rekurció, a végén mi legyen a neutrális elem? Erre az a megoldás, hogy a függvény kap egy olyan paramétert is, ami az alapesete lesz, így üres listánál sem lesz bajban, mert visszaadja ezt az alapesetet.

```haskell
fold :: (a -> a -> a) -> a -> [a] -> a
fold f a [] = a
fold f a (x:xs) = f x (fold f a xs)
```

Megjegyzés: `(a -> a -> a)` jelöli a két paraméteres függvényt, a következő `a` paraméter az alapesetet, `[a]` a lista, amely elemein a függvény végig megy, végül `a` az eredmény.

Kérdés: Lehet olyan függvényt megadni, ami nem (a -> a -> a) típusú? 

Amit át kell hozzá gondolni, hogy melyik paraméterek függnek egymástól.
Ha `b`-be mutató függvényt adunk meg a `fold`nak, akkor biztosan az eredmény is `b` lesz. Ha a `fold` eredménye `b`, akkor az alapeset is `b` lesz, sőt a függvény masodik paramétere is.

Végül így néz ki a `fold` függvény:

```haskell
fold :: (a -> b -> b) -> b -> [a] -> b
fold f a [] = a
fold f a (x:xs) = f x (fold f a xs)
```

Ezt a függvényt helyettünk már megírták és szabadon használhatod, csak nem `fold`, hanem `foldr` néven.



## Foldr és Foldr1

Volt szó a `foldr`-ről, de a `foldr1`-ről még nem. Hasonlóan működnek, viszont fontos megjegyezni pár különbséget, de először nézzük meg hogyan is működnek.

```haskell
foldr1 :: (a -> a -> a) -> [a] -> a
foldr1 f [x] = x
foldr1 f [x,y] = f x y
foldr1 f (x:xs) = f x (fold f xs)
```

Ami először feltűnhet, hogy más paramétereket vár. Csak `a` típusú paramétereket fogad el és nincs egy neurtális érték sem. Ebből következik, hogy egy erős korlátozás a `foldr`rel szemben, hogy sokkal kevesebb függvény kompatibilis a `foldr1`-gyel, mint a `foldr`rel. Amit még meg kell figyelni, hogy üres listára egy exceptiont dob. **???Erről bővebben Viktor jegyzetében???**

Lássunk egy példát az alkalmazásukra:

```haskell
-- foldr
maxAll :: [Int] -> Int
maxAll x = foldr max (head x) (tail x)
-- maxAll x = foldr max 0 x

-- foldr1
maxAll :: [Int] -> Int
maxAll x = foldr1 max x
```
A `foldr`-es definíciónál, ha a kikommentezett verziót használjuk, akkor üres listára 0-t ad vissza, ez bizonyos esetekben jó viselkedés, máskor viszont nem. Emellett csak akkor jó a kikommentezett verzió, ha természetes számokkal dolgozunk.

A `maxLength` függvényt, ami a leghosszabb lista hosszát adja vissza, már nem tudjuk `foldr1`-gyel megírni, mert listákat kap paraméterül, de `Int`-et kell vissza adnia.

```haskell
maxLength :: [[a]] -> Int
maxLength x = foldr (\a b -> max (length a) b) (length (head x)) (tail x) 
-- maxLength x foldr (\a b -> max (length a) b) 0 x
```
Megjegyzés: a kikommentezett sor is ugyanazt írja le, de valamivel egyszerűbben.


Fontos, hogy amint a fenti definíció és a `foldr` típusa is mutatja a lista utolsó eleme lesz az első paraméter, erre nagyon látványos példa az osztás.


```haskell
foldr (/) 4 [4,24,6] --(4/(24/(6/4)))
foldr (/) 1.5 [4,24] --(4/(24/1.5))
foldr (/) 16 [4]     --(4/16)
foldr (/) 0.25 []
0.25
```
## Foldl

A `foldr` testvére a `foldl`. Annyiban különböznek egymástól, hogy a `foldl` balról hajtogat (zárójelez).

```haskell
foldl (/) 96 [2,3,4] --(((96/2)/3)/4)
foldl (/) 48 [3,4]
foldl (/) 16 [4]
foldl (/) 4 []
4
```
A `foldl` rekurzívan:
```haskell
myfoldl ::  (b -> a -> b) -> b -> [a] -> b
myfoldl f a [] = a
myfoldl f a (x:xs) = myfoldl f (f a x) xs
```

### Foldr vs Foldl
Bár hasonlóan működnek nem szabad összekeverni a kettőt.

Az `allTrue` függvényt ha `foldr`-rel írjuk meg, akkor már az első `False`-nál leáll, de ha `foldl`-lel, akkor végig megy a listán. Ez nagyon hosszú listáknál jelentős különbség.

```haskell
allTrue1 :: [Bool] -> Bool
allTrue1 x = foldr (\y acc -> y && acc) True x

allTrue2 :: [Bool] -> Bool
allTrue2 x = foldl (\acc y -> y && acc) True x

```

Azért `True` a kezdőérték, mert üres listára is igaz, hogy csak `True` van benne.

Írjuk meg a saját `reverse` függvényünket. `Foldr`-rel igen csak bonyolult lenne, de `foldl`-lel ez az egyszerű függvény megfordít egy listát:

```haskell
myreverse :: [a] -> [a]
myreverse x = foldl (\a b -> b:a) [] x
```

## Mohó hajtogatás

A `foldl'` a foldl mohó változata, erre azért van szükség, mert ha megvárjuk, míg a memóriába betöltse az összes műveletet, elég hosszú listák esetén a lusta kiértékelésnél elfogy a memória.

```haskell
foldl (+) 0 [1..100000000]
*** Exception: stack overflow
foldl' (+) 0 [1..100000000]
5000000050000000
```

## Scan

A scanl és scanr függvények úgy működnek, mint a `foldl` és `foldr`, azzal a különbséggel, hogy megtartja a részeredményeket (a kezdő értékkel együtt). Ez azért jó, mert így tudjuk ellenőrizni, hogy a hajtogatás valóban azt csinálja, amire mi gondoltunk.

```haskell
scanl :: (b -> a -> b) -> b -> [a] -> [b]
scanl (+) 0 [1,6,3,7,2]
[0,1,7,10,17,19]

scanl1 :: (a -> a -> a) -> [a] -> [a]
scanl1 (*) [2,6,1,3]
[2,12,12,36]

scanr :: (a -> b -> b) -> b -> [a] -> [b]
scanr (-) 1 [1,6,3,7,2]
[-8,9,-3,6,1,1]

scanr1 :: (a -> a -> a) -> [a] -> [a]
scanr1 (/) [2048,64,4,2]
[64.0,32.0,2.0,2.0]



fact'' :: Int -> [Int]
fact x = scanl1 (*) [1..x]

sumFact :: Int -> Int
sumFact x = sumAll(fact x) 
```

# Gyakorló feladatok
1. Írj egy `myLength` függvényt (hajtogatással), ami egy lista hosszát adja meg.

```
myLength "alma" == 4
```

2. Írj egy `myReserve` függvényt (hajtogatással), ami megfordít egy listát.

```
myReserve "alma" == "amla"
```

3. Írj egy `myDropWhile` függvényt, ami elhagyja az elemeket, amíg a predikátum teljesül.

```
myDropWhile (< 3) [1, 0, 4, 3, 2, 5] == [4, 3, 2, 5]
```

4. Írj egy `repElem` függvényt, ami annyiszor írja ki egy lista elemét, ahányadik a listában

```
repElem "aba" == "abbaaa"
```

5. Írj egy `funcWay` függvényt, ami paraméterül egy számokból áló listát kap, 1-et ad vissza, ha monoton növő, -1-et, ha monoton fogyó, 0-t, ha egyik sem. Egy elemű és üres listára 0-t adjon vissza.

```
funcWay [1,2,3,4] == 1
funcWay [4,3,2,1] == -1
funcWay [1,3,2,4] == 0
```

6. Írd meg a `myFilter` függvényt, ami kiválogat egy listából a predikátumnak megfelelő elemeket.

```
myFilter even [1,2,3,4,6,9,11] == [2, 4, 6]
```