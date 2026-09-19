# Vedlegg G — Elektronikk for AVR-programmerere

## Formål
Koble registernær firmware til den elektriske kretsen den styrer.

## Digitale innganger
En flytende input har ingen pålitelig logikktilstand. Lær pull-up/pull-down-oppførsel, active-low-kobling, inputterskler og hvorfor en knapp er en elektrisk komponent og ikke en ideell boolsk variabel.

## Outputs og strøm
GPIO-pinner har elektriske grenser. LED-strøm krever motstand; laster som trenger mer strøm krever et drivertrinn. Respekter per-pin-, port- og device-grenser fra databladet.

## Drivere
Transistorer/MOSFET-er lar et lavstrøms MCU-signal styre en større last. EduBoard RGB0 og BUZZ0 synliggjør bevisst dette skillet.

## Debounce
Mekaniske kontakter bouncer. Software-debounce er en policy lagt oppå fysisk oppførsel; Exercise 12 kobler de to sammen.

## Decoupling
Lokale decoupling-kondensatorer gir en kort høyfrekvent strømvei nær IC-ens forsyningspinner. Bulk-kapasitans arbeider på en annen tids-/energiskala.

## Clocks
Clock-kilde, frekvens, fuse-konfigurasjon og timingberegninger henger sammen. Timer-/UART-feil kan skyldes feil clock-antakelse.

## Logikknivåer
TTL/CMOS MCU-logikk er ikke RS-232. På samme måte er 5 V- og 3,3 V-systemer ikke automatisk kompatible. Identifiser spenningsdomener før boards kobles sammen.

## Analog
ADC-målinger avhenger av referanse, kildeimpedans, støy, jording og layout. En numerisk ADC-kode er ikke automatisk en nøyaktig spenningsmåling.

## Vane
For hver peripheral-lab: tegn hele banen MCU-pin → beskyttelse/driver/passive komponenter → connector/load → returvei.
