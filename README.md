# Optimalizácia konfiguračných parametrov predikčných metód

Spoľahlivá a presná predikcia je dôležitá takmer vo všetkých oblastiach ľudskej
činnosti. Každá predikčná metóda je osobitá a obsahuje vlastné konfiguračné
parametre a konštanty, ktoré je potrebné na začiatku nastaviť. Správne nastavené
konfiguračné parametre výrazne ovplyvňujú presnosť výsledku predikčných metód.
Na riešenie tohto problému je vhodnejšie použiť optimalizačné algoritmy, ktoré
dokážu v relatívne krátkom čase nájsť hľadané hodnoty parametrov. Príkladom
optimalizačného algoritmu je napríklad Simplexová metóda, Umelá kolónia včiel
alebo Genetický algoritmus. V práci analyzujte existujúce optimalizačne
algoritmy na výpočet vhodných hodnôt konfiguračných parametrov predikčných
metód. Zamerajte sa na numericko-štatistické algoritmy ako aj na prírodne
a biologicky inšpirované algoritmy. Navrhnite systém, ktorý umožní výpočet
hodnôt konfiguračných parametrov pre zadanú predikčnú metódu, pomocou vybraných
optimalizačných algoritmov. Jadro systému implementujte v jazyku R. Grafické
používateľské rozhranie vytvorte pomocou knižnice Shiny. Porovnajte
a prezentujte výsledky vybraných optimalizačných algoritmov.


# Štruktúra repozitára

V koreni repozitára sa nachádzajú súbory `server.R` a `ui.R`, kde prvý súbor
zabezpečuje logiku aplikácie a všetky volania funkcií a druhý vykresľovanie
a zobrazovanie komponentov. V `global.R` sa nachádza globálna konfigurácia,
ktorej aktuálnosť treba overiť pri nasadzovaní aplikácie.

## conf

Obsahuje konfiguračné súbory vo formáte YAML. Pomocou nich vie skúsení používateľ
pridávať nové algoritmy.


## doc

Dokumentácia k celej záverečnej práci.


## shiny

Pomocné funkcie, ktoré sa volajú z viacerých miest alebo nie sú špecifické pre
žiadnu časť aplikácie.


## src

Očíslované skripty, ktoré sú volané zo `server.R`. Zabezpečujú, aby dáta boli
najskôr načítané, potom spracované pre konkrétnú predikčnú metódu a nakoniec
optimalizované zvolenou optimalizačnou metódou.


## test

Obsahuje skripty, ktoré boli použité na overenie riešenia. Časť z nich používa
aj metódu posuvného okna, kedy boli výsledky zaznamenané aj v priloženom CSV súbore.


## util

Pomocné skripty použité pri návrhu, implementácií a testovaní aplikácie.


## www

Súbory potrebné najmä pre vhodné vykreslenie aplikácie vo webovom prehliadači.

