--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
------------------------------------------ MODULO 2 - JUNTANDO DADOS
----------------------------------- UNIDADE 1 - JUNÇÕES INTERNAS E JUNÇÕES NATURAIS
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- As linhas carregadas na consulta são aquelas que dão match entre a chave primária de uma tabela com a chave 
-- estrangeira da outra (img1-inner_join)

--

SELECT *
FROM gdp_pc;

SELECT *
FROM fertility;

-- Cruza os dados de PIB per capita e fertilidade combinando país e ano de referência,
-- retornando apenas os registros completos que existem em ambas as tabelas.
SELECT *
FROM gdp_pc AS gp
INNER JOIN fertility AS f 
	ON gp.country = f.country
	AND gp.ref_year = f.ref_year;

-- Seleciona o país, o PIB per capita e a média de filhos por mulher (fertilidade) em 2019, 
-- cruzando as tabelas por país e ano, ordenando dos maiores para os menores PIBs (Top 10).
SELECT gp.country,
	   gp.gdp_pc,
	   f.mean_babies
FROM gdp_pc AS gp
INNER JOIN fertility AS f
	ON gp.country = f.country
	AND gp.ref_year = f.ref_year
WHERE gp.ref_year = 2019
ORDER BY gp.gdp_pc DESC
LIMIT 10;

-- Seleciona o país, PIB per capita, taxa de fertilidade e média de anos de escolaridade feminina em 2008,
-- cruzando três tabelas por país e ano, ordenando pelos 10 maiores PIBs per capita (Top 10).
SELECT gp.country,
SELECT gp.country,
	   gp.gdp_pc,
	   f.mean_babies,
	   ws.mean_years
FROM gdp_pc AS gp
INNER JOIN fertility AS f
	ON gp.country = f.country
	AND gp.ref_year = f.ref_year
INNER JOIN women_years_at_school AS ws
	ON gp.country = ws.country
	AND gp.ref_year = ws.ref_year 
WHERE gp.ref_year = 2008
ORDER BY gp.gdp_pc DESC
LIMIT 10;

-- pode-se aplicar a junção diretamente na cláusula WHERE:
SELECT gp.country,
	   gp.gdp_pc,
	   f.mean_babies,
	   ws.mean_years
FROM gdp_pc AS gp,
	 fertility AS f,
	 women_years_at_school AS ws
WHERE gp.country = f.country AND gp.ref_year = f.ref_year 
	  AND gp.country = ws.country AND gp.ref_year = ws.ref_year 
	  AND gp.ref_year = 2008
ORDER BY gp.gdp_pc DESC
LIMIT 10;

------------------------------------------ EXERCÍCIOS------------------------------------------------------------------

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
------------------------------------------ NOTAS
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

/*
===================================================================================
                   CONCEITO DE JUNÇÃO EM BANCOS DE DADOS RELACIONAIS
===================================================================================

       TABELA-PAI (Contém a Chave Primária - PK)
       +------------------------------------+
       | PK: id_pai (Único) |  nome_pai     |
       +--------------------+---------------+
       |        101         |  Tabela A     | <---+
       |        102         |  Tabela B     |     |
       +--------------------+---------------+     |
                                                  |
                                                  | (Relação 1 para N)
                                                  | Cada PK se liga a N linhas
                                                  |
       TABELA-FILHA (Contém a Chave Estrangeira - FK)
       +-------------------------------------------------+
       |  id_filho  | FK: id_pai (Pode repetir) |  dado  |
       +------------+---------------------------+--------+
       |     1      |            101            |  Item1 | ---> Aponta para o pai 101
       |     2      |            101            |  Item2 | ---> Aponta para o pai 101
       |     3      |            102            |  Item3 | ---> Aponta para o pai 102
       +------------+---------------------------+--------+

                                    │
                                    │ (INNER JOIN / ON PK = FK)
                                    ▼

       RESULTADO DA JUNÇÃO (Colunas lado a lado)
       +------------------+---------------+------------+--------+
       |   gp.id_pai      |    nome_pai   |  id_filho  |  dado  |
       +------------------+---------------+------------+--------+
       |       101        |   Tabela A    |     1      | Item1  |
       |       101        |   Tabela A    |     2      | Item2  |
       |       102        |   Tabela B    |     3      | Item3  |
       +------------------+---------------+------------+--------+

-----------------------------------------------------------------------------------
 ⚠️ EVITANDO O PRODUTO CARTESIANO:
    - Se a junção NÃO for feita pelas chaves (PK = FK), o banco combina TODAS as 
      linhas do Pai com TODAS as linhas do Filho (linhas do Pai x linhas do Filho).
    - A junção correta preserva a relação 1:N unindo as colunas LADO A LADO!
===================================================================================
*/