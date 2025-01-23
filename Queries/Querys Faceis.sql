-- Quantidade de pessoas que frequentam a escola
SELECT COUNT(DISTINCT id_pessoa) 
FROM TB_ESC 
WHERE ind_frequenta_escola_memb = 1;

-- Quantidade de famílias com e sem saneamento básico
SELECT 
    COUNT(DISTINCT id_familia) AS total,
    COUNT(CASE WHEN cod_escoa_sanitario_domic_fam IN (1, 2) THEN 1 END) AS saneamento_basico,
    COUNT(CASE WHEN cod_escoa_sanitario_domic_fam IN (3, 4, 5, 6) THEN 1 END) AS sem_saneamento_basico
FROM TB_DOMICILIO;

-- Estado com mais municípios
SELECT UF, COUNT(DISTINCT nome_municipio) AS Contagem FROM TB_MUN GROUP BY UF ORDER BY Contagem DESC;

-- Quantidade de famílias com domicílio próprio
SELECT COUNT(DISTINCT id_familia) 
FROM TB_DOMICILIO 
WHERE cod_especie_domic_fam = 1;

-- Quantidade de famílias com e sem água encanada
SELECT 
    COUNT(DISTINCT id_familia) AS total,
    COUNT(CASE WHEN cod_agua_canalizada_fam = 1 THEN 1 END) AS agua_encanada,
    COUNT(CASE WHEN cod_agua_canalizada_fam = 2 THEN 1 END) AS sem_agua_encanada
FROM TB_DOMICILIO;