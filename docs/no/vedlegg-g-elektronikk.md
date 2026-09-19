# Vedlegg G — Elektronikk for AVR-programmerere

## Formål
Koble register-nær firmware til den elektriske kretsen.

En flytende input har ingen pålitelig logikkverdi. Lær pull-up/down, active-low, terskler og debounce. GPIO har strømgrenser; LED trenger motstand og større last trenger drivertrinn.

EduBoard RGB0 og BUZZ0 synliggjør skillet mellom MCU-signal og lastdriver.

Decoupling gir en lokal høyfrekvent strømvei; bulk-kapasitans har en annen rolle. Clock-kilde, frekvens, fuses og timingberegninger henger sammen.

TTL/CMOS UART er ikke RS-232, og 5 V og 3,3 V er ikke automatisk kompatible.

ADC-resultater avhenger av referanse, kildeimpedans, støy, jord og layout.

## Vane
Tegn hele banen: MCU-pin → beskyttelse/driver/passiver → connector/load → returvei.
