[🇬🇧 English](README.md) | [🇪🇪 Eesti keel](README.et.md)
# 🪸 CoralChain – Visuaalne tööriistade kogum plokiahela põhitõdede uurimiseks

**CoralChain** on kergekaaluline, veebipõhine plokiahela simulatsiooniraamistik, mis on ehitatud Ruby ja Sinatra abil. See ühendab hulga visuaalseid ja interaktiivseid tööriistu, mille eesmärk on illustreerida peamisi kontseptsioone nagu plokiahela struktuur, mitme sõlme sünkroniseerimine ja konsensusmehhanismide võrdlus. Projekt pakub ligipääsetavat ja praktilist viisi plokiahelate toimimise uurimiseks lihtsustatud ja õpetlikes stsenaariumites.

## Omadused

- **Ploki toimingud ja verifitseerimine**  
  - Loo ja vaata plokke kohandatavate andmete ning valitava konsensusmeetodiga  
  - Kontrolli ahela terviklikkust räsilinkide, indeksite ja digitaalallkirjade kaudu  
  - Simuleeri andmete võltsimist ja jälgi mõju reaalajas visuaalse tagasiside abil  

- **Mitme sõlme interaktsioon ja sünkroniseerimine**  
  - Käivita paralleelselt plokiahelaid sõlmes A, sõlmes B ja Byzantiumi sõlmes X  
  - Simuleeri Byzantiumi käitumist, sh võltsitud ahela levitamine ja ülekirjutamise katsed  
  - Vaata ahelate erinevusi, kahvleid ja sünkroniseerimist sõlmede vahel  
  - Rakenda "pikima kehtiva ahela" reeglit konfliktide lahendamiseks  

- **Konsensus ja võrgu simulatsioon**  
  - Uuri PoW-, PoS- ja PoA-mehhanisme kohandatavate parameetritega  
  - Hinda ja võrdle konsensuse tõhusust reaalajas graafikute ja statistika abil  
  - Ekspordi ahela andmed ja katsetulemused CSV- või Markdown-vormingus  
  - Simuleeri kuulujutupõhist sõnumiedastust visuaalse viivituse ja pahatahtliku sekkumisega  

## Tehnoloogiad

- **Keel**: Ruby  
- **Raamistik**: Sinatra  
- **Esikülg**: ERB-mallid, Chart.js

## Juurutamine

Projekti käivitamiseks tee järgmist:

```bash
# Klooni repositoorium
git clone https://github.com/Xinjian-Zhang/coralchain.git
```

```bash
cd coralchain
```

```bash
# Paigalda sõltuvused
bundle install
```

```bash
# Käivita server
ruby app.rb
```

Vaikimisi on rakendus kättesaadav aadressil: http://localhost:4567

### 🐳 Dockeriga juurutamine (soovitatav)

CoralChaini kiireks käivitamiseks konteinerkeskkonnas kasuta järgmist:

```bash
# Klooni repositoorium
git clone https://github.com/Xinjian-Zhang/coralchain.git
cd coralchain
```

```bash
# Ehita ja käivita konteiner
docker-compose up --build
```

Kui kõik töötab, külasta aadressi:

http://localhost:4567

See käivitab CoralChaini iseseisvas Docker-konteineris, mis võimaldab seda uurida ilma Ruby't või sõltuvusi käsitsi paigaldamata.

## Projekti kohta

**Autor**: Xinjian Zhang  
**Asutus**: Tartu Ülikool  
**Kuupäev**: Mai 2025  

- GitHub: [github.com/xinjian-Zhang/coralchain](https://github.com/xinjian-Zhang/coralchain)  
- Veebileht: [xinjian-zhang.github.io/coralchain-web](https://xinjian-zhang.github.io/coralchain-web)

## Tänusõnad

Suur tänu **dr Mubashar Iqbal**ile juhendamise ja toe eest kogu projekti jooksul.

## Litsents

See projekt on litsentsitud MIT-litsentsi alusel. Vaata [LICENSE](LICENSE) faili üksikasjade jaoks.
