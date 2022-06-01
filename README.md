# Data preparation for Covid-19 spread analysis
Project in this repository is one of two outputs of Data academy course of Engeto company, which I have completed in January 2022. It is written in SQL a its main goal is creating a table in required format from different databases, that includes information about Covid-19 spread (numbers of infected, recovered and dead people) in different states and potential factors, that can influence the spread itself (weather, demography, economical indicators, etc.). This table in solved scenatrio should serve as a base for statistical model of Covid-19 spread. Instruction is this:

##########
"Hi,
I am trying to determing factors, the impact speed of coronavirus spread on states level. As a data analyst, I'd like to ask you for help with preparation of data, which I will later statistically process.

Result table will be in a panel format, keys are country and date. I will evaluate a model, that will interpret daily increase of infected cases in specific countries. Numbers of infected cases alone are no use to me - it is neccessary to consider numbers of tests and inhabitants in particular state. From these three variables I can create apropriate variable. I want to explain daily cases of infected people with several types of variables. Each column in the table shall represent one variable. I want to acquire following columns:

### Time variables
- binary variable for workday/weekend
- season of the year (please code that with 0 to 3)

### Variables specific for particular state
- population density - disease could spread faster in countries with higher population density
- GDP per capita - it will be used as an indicator of particulare state economical level of development
- GINI coefficient - does the wealth inequality has an impact on coronavirus spread?
- child mortality - it will be used as an indicator of health system development level
- median age of inhabitants in 2018 - states with older population may be affected severely
- composition of religion in population - it will be used as a proxy variable for cultural specification. I would like to know a percentage share of religion devoters for every religion in given state.
- Difference between life expectancy in 1965 and 2015 - states that have developed recently could react differently than states developed for a long time.

### Weather (impacts people's behavior and also capability of virus to spread)
- average day (not year) temperature 
- number of hours in given day, when precipitation was non-zero
- peak wind speed during a day

Are there any other variables on your mind, that we could use? For what I know, you should do fine with data from these tables: countries, economies, life_expectancy, religions, covid19_basic_differences, covid19_testing, weather, lookup_table.” 


##########

# Zpracování podkladových dat pro analýzu šíření nemoci Covid-19 - SQL

Projekt v tomto repozitáři je jedním ze dvou výstupů kurzu datové analýzy od společnosti Engeto, který jsem absolvoval mezi zářím 2021 a lednem 2022. Je psán v SQL a jeho cílem je vytvoření tabulky v požadovaném formátu z různých databází, která bude obsahovat informace o šíření nemoci Covid-19 (počty nakažených, uzdravený a zemřelých osob) v různých státech po světě a potenciální vlivy, které na šíření mohou mít vliv (počasí, demografie, ekonomické ukazatele, atd.). Tato tabulka má v řešeném scénáři sloužit jako podklad pro statistický model šíření nemoci Covid-19. Zadání zní následovně:

“Od Vašeho kolegy statistika jste obdrželi následující email:

##########

Dobrý den,

snažím se určit faktory, které ovlivňují rychlost šíření koronaviru na úrovni jednotlivých států. Chtěl bych Vás, coby datového analytika, požádat o pomoc s přípravou dat, která potom budu statisticky zpracovávat. Prosím Vás o dodání dat podle požadavků sepsaných níže.

Výsledná data budou panelová, klíče budou stát (country) a den (date). Budu vyhodnocovat model, který bude vysvětlovat denní nárůsty nakažených v jednotlivých zemích. Samotné počty nakažených mi nicméně nejsou nic platné - je potřeba vzít v úvahu také počty provedených testů a počet obyvatel daného státu. Z těchto tří proměnných je potom možné vytvořit vhodnou vysvětlovanou proměnnou. Denní počty nakažených chci vysvětlovat pomocí proměnných několika typů. Každý sloupec v tabulce bude představovat jednu proměnnou. Chceme získat následující sloupce:

### Časové proměnné

- binární proměnná pro víkend / pracovní den
- roční období daného dne (zakódujte prosím jako 0 až 3)

### Proměnné specifické pro daný stát
- hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji
- HDP na obyvatele - použijeme jako indikátor ekonomické vyspělosti státu
- GINI koeficient - má majetková nerovnost vliv na šíření koronaviru?
- dětská úmrtnost - použijeme jako indikátor kvality zdravotnictví
- medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více
- podíly jednotlivých náboženství - použijeme jako proxy proměnnou pro kulturní specifika. Pro každé náboženství v daném státě bych chtěl procentní podíl jeho příslušníků na celkovém obyvatelstvu
- rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu

### Počasí (ovlivňuje chování lidí a také schopnost šíření viru)
- průměrná denní (nikoli noční!) teplota
- počet hodin v daném dni, kdy byly srážky nenulové
- maximální síla větru v nárazech během dne

Napadají Vás ještě nějaké další proměnné, které bychom mohli použít? Pokud vím, měl(a) byste si vystačit s daty z následujících tabulek: countries, economies, life_expectancy, religions, covid19_basic_differences, covid19_testing, weather, lookup_table.”

