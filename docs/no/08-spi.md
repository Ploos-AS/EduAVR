# SPI — Serial Peripheral Interface

!!! abstract "Læringsmål"
    Forklar full-dupleks skifting, klokke, chip select og CPOL/CPHA, og implementer samme blokkerende byteoverføring i AVR Assembly og C.

!!! info "Forutsetninger"
    Du bør forstå GPIO-retning, polling og periferiregistre.

SPI er en synkron seriebuss. ATmega1284P har MOSI, MISO, SCK og SS og kan brukes som kontroller eller periferienhet.

## Første konfigurasjon

De parallelle eksemplene konfigurerer SPI som kontroller, mode 0, MSB først og klokke `F_CPU/16`. SS settes som utgang slik at AVR-en forblir i controller-modus. MOSI og SCK er utganger, mens MISO er inngang.

En overføring starter ved å skrive en byte til SPDR. Maskinvaren skifter samtidig én bit inn og én bit ut for hver SCK-kant. SPIF i SPSR markerer ferdig overføring; SPDR inneholder deretter mottatt byte.

## Under panseret

Sammenlign C- og Assembly-versjonene og finn operasjonene som konfigurerer DDR, SPCR og eventuelt SPSR. Følg deretter én byte fra skriving til SPDR, via venting på SPIF, til lesing av mottatt data.

## Prøv selv

Bygg begge implementasjonene og spor en blokkerende byteoverføring. Endre deretter klokkeinnstillingen og identifiser hvilke registerbiter som endres.

!!! success "Forventet resultat"
    Du kan forklare hvorfor én SPI-overføring både sender og mottar data og identifisere registrene som styrer og rapporterer overføringen.

## Kvalifikasjon

Q0 bygger og disassemblerer begge implementasjonene. Q1 verifiserer modellert SPI-registerkonfigurasjon i simavr. Q2 verifiserer virkelige pinner, spenningsnivåer, klokkesignal og kommunikasjon med en ekstern SPI-enhet.

## Sjekk forståelsen

1. Hvorfor kalles SPI full-dupleks?
2. Hva gjør chip select?
3. Hva angir CPOL og CPHA?
4. Hvorfor kan simulatoren ikke kvalifisere den elektriske SCK-bølgeformen?

!!! tip "Neste"
    Fortsett til [TWI / I2C](09-twi-i2c.md).
