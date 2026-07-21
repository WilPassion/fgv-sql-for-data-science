--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
------------------------------------------ MODULO 1 - CONSULTANDO DADOS
-------------------------------------- UNIDADE 1 - O ESSENCIAL SOBRE CONSULTAS
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- 1. Consulta simples
SELECT * FROM co2_emissions_pc;
-----------------------------------------------------------------------------------------------------------------------

-- 2. Otimizando - em consultas de testes usar o LIMIT em grandes tables
SELECT *
FROM co2_emissions_pc
LIMIT 10;
-----------------------------------------------------------------------------------------------------------------------

-- 3. Otimizando - Evite Funções em Cláusulas WHERE, pois primeiro o bd 
-- varre as linhas para depois encontrar o valor "=" 
-- evite
SELECT "Date" AS "Data", low
FROM petrobras
WHERE EXTRACT(MONTH FROM "Date"::date) = 3; --::date transforma os dados para tipo data (2001-08-11)

SELECT low
FROM petrobras
WHERE "Date" LIKE '%-03%';

-- prefira
SELECT "Date" AS "Data", low
FROM petrobras
WHERE "Date" BETWEEN '2001-03-01' AND '2001-03-01';

------------------------------------------ EXERCÍCIOS------------------------------------------------------------------

-- Selecione, da tabela co2_emissions_pc, todos os países e anos cuja emissão seja igual a 0,2. Observe
-- que os dados estão no formato americano, no qual o . (ponto) é o separador de decimais. Indique se os 
-- países Guatemala e Lituânia estão na lista.

-- teste
SELECT country AS "País", ref_year AS "Ano", co2_pc AS "Taxa Emissão"
FROM co2_emissions_pc
WHERE country IN ('Guatemala', 'Lituânia');


SELECT country AS "País", ref_year AS "Ano", co2_pc AS "Taxa Emissão"
FROM co2_emissions_pc
WHERE co2_pc = 0.2 
	AND country IN ('Guatemala', 'Lituânia');
-----------------------------------------------------------------------------------------------------------------------

-- Selecione, da tabela country, a classificação de quatro e oito regiões e das quatro categorias de renda 
-- do Banco Mundial para o Brasil.
SELECT *
FROM country
WHERE country LIKE 'Indonesia';
	
SELECT country AS "País", four_regions AS "4 Regiões",
       six_regions AS "6 Regiões", wb4income AS "Renda"
FROM country
WHERE country LIKE 'Brazil';

SELECT country AS "País", four_regions AS "4 Regiões",
       six_regions AS "6 Regiões", wb4income AS "Renda"
FROM country
WHERE country = 'Brazil';
-----------------------------------------------------------------------------------------------------------------------

-- Selecione, da tabela country, o nome de todos os países com a classificação de renda do Banco Mundial 
-- em três níveis (coluna wb3income) igual a Middle income. Indique se a China, a Indonésia e a Malásia 
-- estão na lista.
SELECT country AS "País", wb3income AS "Renda"
FROM country
WHERE wb3income = 'Middle income'
	AND country IN ('Indonesia', 'China', 'Malaysia');
-----------------------------------------------------------------------------------------------------------------------

-- Selecione, da tabela gdp_pc, o PIB per capita dos países no ano de 2017. Indique qual o valor de Mônaco.
SELECT * FROM gdp_pc;

SELECT country
FROM gdp_pc
WHERE country ILIKE 'monaco';

SELECT country AS "País", ref_year AS "Ano", gdp_pc AS "PIB"
FROM gdp_pc
WHERE ref_year = 2017 AND country ILIKE 'monaco';
-----------------------------------------------------------------------------------------------------------------------

-- Selecione, da tabela life_expectancy, os países e anos de referência cuja expectativa de vida ao nascer 
-- era de 36.5 anos. Indique quais foram os anos em que os nascidos no Chile tinham esta expectativa de vida.
SELECT * FROM life_expectancy;

SELECT *
FROM life_expectancy
WHERE country = 'China';

SELECT country, ref_year
FROM life_expectancy
WHERE tot_years = 36.5; 

SELECT *
FROM life_expectancy
WHERE tot_years = 36 AND country IN ('China');
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela petrobras e o campo Close para fazer a sua pesquisa, indique qual o preço de fechamento
-- das ações da Petrobras no dia 8 de dezembro de 2022.
SELECT * FROM petrobras;

SELECT "Date" AS "Data", "Close" AS "Preço" 
FROM petrobras
WHERE "Date" IN ('2022-12-08');
-----------------------------------------------------------------------------------------------------------------------

--Utilizando a tabela gdp_pc, indique qual país tem PIB per capita menor do que 400 dólares.
SELECT * FROM gdp_pc;

SELECT country AS "País", gdp_pc AS "PIB"
FROM gdp_pc
WHERE gdp_pc < 400;
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela life_expectancy, indique os dois países que têm projeção de expectativa de vida acima de 94 anos.
SELECT * FROM life_expectancy;

SELECT country, tot_years
FROM life_expectancy
WHERE tot_years > 94;
-----------------------------------------------------------------------------------------------------------------------

-- Selecione todas as linhas da tabela petrobras com o valor de Close diferente de Adj Close. Indique se este evento
-- aconteceu no dia 16 de agosto de 2000.
SELECT * FROM petrobras;

SELECT *
FROM petrobras
WHERE "Close" != "Adj Close" AND "Date" = '2000-08-16';

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-------------------------------------- UNIDADE 2 - OPERADORES ESPECIAIS E LÓGICOS
-- AND, OR, NOT, BETWEEN, NULL, IN, LIKE
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- NULO
SELECT *
FROM population
WHERE tot_pop IS NULL;

SELECT *
FROM population
WHERE tot_pop IS NOT NULL;

-- BETWEEN
SELECT * FROM child_mortality;

SELECT country,
	   ref_year,
	   tot_deaths
FROM child_mortality
WHERE tot_deaths BETWEEN 570 AND 630;
--

SELECT *
FROM petrobras
WHERE "Date" BETWEEN '2020-02-20' AND '2020-03-20';
--
-- OR / NOT

SELECT country, wb_regions
FROM country
WHERE wb_regions = 'North America'
   OR wb_regions = 'Latin America & Caribbean';
   
SELECT country, wb_regions
FROM country
WHERE NOT (wb_regions = 'North America'
   OR wb_regions = 'Latin America & Caribbean');

SELECT country,
	   ref_year,
	   tot_deaths
FROM child_mortality
WHERE tot_deaths BETWEEN 57 AND 63
	AND (country = 'China' OR country = 'Brazil'); -- use parênteses para ordem de leitura
--
-- LIKE

SELECT country, mean_babies
FROM fertility
WHERE ref_year = 2021
	AND country LIKE '%land';
	
SELECT country, mean_babies
FROM fertility
WHERE ref_year = 2021
	AND country LIKE '%Guinea%';

------------------------------------------ EXERCÍCIOS------------------------------------------------------------------

-- Indique se há linhas com valores nulos no campo gdp_pc na tabela gdp_pc.
SELECT *
FROM gdp_pc
WHERE gdp_pc IS NULL;

-- Na tabela child_mortality, indique se há linhas com valores nulos no campo tot_deaths.
SELECT tot_deaths AS "Óbitos"
FROM child_mortality
WHERE tot_deaths IS NULL;
-----------------------------------------------------------------------------------------------------------------------

-- Segundo o Ministério da Saúde, as taxas de mortalidade infantil (TMI) são classificadas 
-- em altas (50 ou mais), médias (20-49) e baixas (menos de 20). Utilizando a tabela child_mortality
-- e o campo tot_deaths, encontre todos os países que alcançaram taxas de mortalidade baixas com uma 
-- variação de 5%, ou seja, com valor de 20±5%. Indique em que ano o Brasil atingiu essa TMI.
SELECT * FROM child_mortality;

SELECT country, tot_deaths, ref_year
FROM child_mortality
WHERE country IN('Brazil') AND (tot_deaths BETWEEN 19 AND 21);
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela life_expectancy e o campo tot_years, indique qual a expectativa de vida do 
-- brasileiro nos anos de 2019 a 2023. Liste os valores, observe o que ocorreu e comente as prováveis causas.
SELECT * FROM life_expectancy;

SELECT ref_year, tot_years	
FROM life_expectancy
WHERE (country LIKE 'Brazil') 
	AND (ref_year BETWEEN 2019 AND 2023);
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela population, selecione os países cuja população ultrapassou 200 milhões de habitantes 
-- em 2023. Use notação científica para representar a população na consulta e indique a população de cada país 
-- selecionado nos resultados.	
SELECT * FROM population;

SELECT country AS "País", 
	   ref_year AS "Ano", 
	   tot_pop AS "Total População"
FROM population
-- Notação Científica: 200 milhões ($200.000.000$) possui o número 2 seguido de 8 zeros ($2 \times 10^8$). No SQL, escrevemos isso como 2e8
WHERE tot_pop > 2e8 
	AND ref_year = '2023';
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela co2_emissions_pc, indique as emissões de CO2 no Brasil, na China e nos Estados Unidos, 
-- de 2019 a 2021. Compartilhe as suas observações sobre a pesquisa.
SELECT country, ref_year, co2_pc
FROM co2_emissions_pc
WHERE country IN ('China', 'Brazil', 'USA')
	AND ref_year BETWEEN 2019 AND 2021; 

-- Utilizando a tabela country, selecione os países europeus de renda média baixa. Use a classificação Gapminder 
-- de oito regiões geográficas (campo eight_regions com valor europe_east e europe_west), para verificar os países, 
-- e a classificação de quatro faixas de renda do Banco Mundial (campo wb4income com o valor Lower middle income), 
-- para verificar a renda. Indique se todos os países são do leste europeu.
SELECT * FROM country;

SELECT country, eight_regions, wb4income
FROM country
WHERE eight_regions IN ('europe_east', 'europe_west') AND wb4income LIKE ('Lower middle income');


-- Utilizando a tabela co2_emissions_pc e o operador IN, indique as emissões de CO2 no Brasil, na China e nos 
-- Estados Unidos, de 2019 a 2021. Compartilhe as suas observações sobre a pesquisa.
SELECT * FROM co2_emissions_pc;

SELECT country AS "País" , 
	   ref_year AS "Ano",
	   co2_pc AS "Emissão"
FROM co2_emissions_pc
WHERE country IN ('Brazil', 'China', 'USA') AND (ref_year BETWEEN 2019 AND 2021);
-----------------------------------------------------------------------------------------------------------------------

-- Utilizando a tabela country, selecione os países do continente asiático segundo a classificação de oito regiões
-- (coluna eight_regions). Além da coluna country, traga as colunas eight_regions e wb_regions para comparação.
SELECT * FROM country;

SELECT country, four_regions, eight_regions, wb_regions
FROM country
WHERE four_regions LIKE('%sia')


SELECT country, eight_regions, wb_regions
FROM country
WHERE eight_regions IN ('europe_central_asia', 'east_asia_pacific', 'south_asia');
-----------------------------------------------------------------------------------------------------------------------

-- Pesquise os países das Américas, segundo a classificação do Banco Mundial (coluna wb_regions), utilizando o 
-- operador LIKE.
SELECT country, four_regions, 
 	   eight_regions, wb_regions
FROM country
WHERE four_regions LIKE '%merica%';

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-------------------------------------- UNIDADE 3 - ORDENAÇÃO, LIMITAÇÃO E UNICIDADE
-- ORDER BY - ordena os dados em ordem crescente: números do menor para o maior,
-- caracteres em ordem alfabética do A para o Z, datas da mais antiga para a mais nova, booleano do
-- falso para o verdadeiro
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

SELECT * FROM population;

SELECT country, tot_pop, ref_year
FROM population 
WHERE ref_year = 2000
ORDER BY tot_pop;

-- DESC - inverte
SELECT country, tot_pop, ref_year
FROM population 
WHERE ref_year = 2000
ORDER BY tot_pop DESC;

--  Quais os países que atingiram população superior a 1 bilhão de habitantes e em que ano isso aconteceu? 
SELECT country, tot_pop, ref_year
FROM population 
WHERE tot_pop > 1e9
ORDER BY country, ref_year;

SELECT country, tot_pop, ref_year
FROM population 
WHERE tot_pop > 1e9
ORDER BY country DESC, ref_year;

SELECT country, ref_year, tot_pop
FROM population
WHERE tot_pop > 1000000000
ORDER BY country DESC, ref_year DESC;

-- LIMIT - Limitando os resultados -> se quisermos trazer apenas os 20 países mais populosos no ano 2000
SELECT country, tot_pop
FROM population
WHERE ref_year = 2000
ORDER BY tot_pop DESC
LIMIT 10;

-- Utilizando a tabela gdp_pc, selecione os países com menor PIB per capita em 2009.
	SELECT * FROM gdp_pc;

SELECT country AS "País", 
	   gdp_pc AS "PIB",
	   ref_year AS "Ano"
FROM gdp_pc
WHERE ref_year = 2009
ORDER BY gdp_pc;

-- Utilizando a tabela avg_income, selecione os países com menor renda per capita em 2009.
SELECT * FROM avg_income;

SELECT country AS "País", 
	   mean_usd AS "Média",
	   ref_year AS "Ano"
FROM avg_income
WHERE ref_year = 2009
ORDER BY mean_usd;

-- Utilizando a tabela fertility, encontre os países com maior taxa de natalidade em 2009.
SELECT * FROM fertility;

SELECT country AS "País", 
	   mean_babies AS "Média",
	   ref_year AS "Ano"
FROM fertility
WHERE ref_year = 2009
ORDER BY mean_babies DESC;

-- Utilizando a tabela child_mortality, indique os países com a maior taxa de mortalidade infantil em 2009.
SELECT * FROM child_mortality;

SELECT country AS "País", 
	   tot_deaths AS "Total Mortes",
	   ref_year AS "Ano"
FROM child_mortality
WHERE ref_year = 2009
ORDER BY tot_deaths DESC;

-- Utilizando a tabela womem_years_at_school, selecione os países com menor tempo médio na escola das mulheres de 25 anos em 2009.
SELECT * FROM women_years_at_school;

SELECT country AS "País", 
	   mean_years AS "Tempo Médio",
	   ref_year AS "Ano"
FROM women_years_at_school
WHERE ref_year = 2009
ORDER BY mean_years
LIMIT 10;

-- Utilizando a tabela gdp_pc, selecione os 6 países com menor PIB per capita em 2009.
SELECT country AS "País", 
	   gdp_pc AS "PIB",
	   ref_year AS "Ano"
FROM gdp_pc
WHERE ref_year = 2009
ORDER BY gdp_pc
LIMIT 6;

-- Utilizando a tabela life_expectancy, encontre os seis países com a menor expectativa de vida em 2009.
SELECT * FROM life_expectancy;

SELECT country AS "País", 
	   tot_years AS "Total de Anos",
	   ref_year AS "Ano"
FROM life_expectancy
WHERE ref_year = 2009
ORDER BY life_expectancy
LIMIT 6;

-- Sem apresentar linhas nulas, indique quais são as categorias do campo wb4income da tabela country.
SELECT * FROM country;

SELECT DISTINCT wb4income
FROM country
WHERE wb4income IS NOT NULL;

-- Selecione os cinco últimos países distintos, na ordem alfabética, da tabela population.
SELECT * FROM population;

SELECT DISTINCT country AS "País"
FROM population
ORDER BY country DESC
LIMIT 5;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
------------------------------------------ NOTAS
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- A Base dos Dados (datasets no Big Query) é uma ONG que mantém a maior plataforma pública de dados do Brasil e oferece serviços especializados 
-- em engenharia, análise e capacitação de dados: https://basedosdados.org/