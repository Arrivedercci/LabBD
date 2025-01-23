-- Quantidade de pessoas por raça e cor em cada município e a renda media do municipio 
SELECT MUN.nome_municipio, 
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 1 THEN 1 END) AS branca,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 2 THEN 1 END) AS preta,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 3 THEN 1 END) AS amarela,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 4 THEN 1 END) AS parda,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 5 THEN 1 END) AS indigena,
       (SELECT AVG(CAST(REPLACE(FAM2.vlr_renda_media_fam, ',', '.') AS DECIMAL(10, 2)))
        FROM TB_FAMILIA FAM2
        WHERE FAM2.cd_ibge = MUN.cd_ibge) AS renda_media
FROM TB_PESSOA PSA
INNER JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
INNER JOIN TB_TRAB TRAB ON PSA.id_pessoa = TRAB.id_pessoa
WHERE TRAB.cod_principal_trab_memb IN (4, 6, 8, 9, 10, 11)
GROUP BY MUN.nome_municipio, MUN.cd_ibge
ORDER BY MUN.nome_municipio;

-- quantidade de pessoas por faixa etaria e idade media de inscritos em escola por municipio
SELECT MUN.nome_municipio, 
       COUNT(CASE WHEN PSA.idade < 18 THEN 1 END) AS menor_de_18,
       COUNT(CASE WHEN PSA.idade BETWEEN 18 AND 59 THEN 1 END) AS de_18_a_59,
       COUNT(CASE WHEN PSA.idade >= 60 THEN 1 END) AS sessenta_ou_mais,
       (SELECT AVG(PSA2.idade)
        FROM TB_PESSOA PSA2
        INNER JOIN TB_FAMILIA FAM2 ON PSA2.id_familia = FAM2.id_familia
        INNER JOIN TB_ESC ESC2 ON PSA2.id_pessoa = ESC2.id_pessoa
        WHERE FAM2.cd_ibge = MUN.cd_ibge AND ESC2.ind_frequenta_escola_memb IN (1,2)) AS idade_media
FROM TB_PESSOA PSA
INNER JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
INNER JOIN TB_ESC ESC ON PSA.id_pessoa = ESC.id_pessoa
WHERE ESC.ind_frequenta_escola_memb = 1
GROUP BY MUN.nome_municipio, MUN.cd_ibge
ORDER BY MUN.nome_municipio;

-- renda media e idade media por municipio
SELECT MUN.nome_municipio, 
       AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, ',', '.') AS DECIMAL(10, 2))) AS renda_media,
       (SELECT AVG(PSA.idade)
        FROM TB_PESSOA PSA
        JOIN TB_FAMILIA FAM2 ON PSA.id_familia = FAM2.id_familia
        WHERE FAM2.cd_ibge = MUN.cd_ibge) AS idade_media
FROM TB_FAMILIA FAM
INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
GROUP BY MUN.nome_municipio, MUN.cd_ibge
ORDER BY renda_media DESC;

-- Quantidade de pessoas que frequentam a escola por município e sua renda media
SELECT MUN.nome_municipio, 
       AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, ',', '.') AS DECIMAL(10, 2))) AS renda_media,
       (SELECT COUNT(ESC.id_pessoa)
        FROM TB_ESC ESC
        JOIN TB_FAMILIA FAM2 ON ESC.id_familia = FAM2.id_familia
        WHERE FAM2.cd_ibge = MUN.cd_ibge AND ESC.ind_frequenta_escola_memb IN (1,2) ) AS qtd_pessoas_escola
FROM TB_FAMILIA FAM
INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
GROUP BY MUN.nome_municipio, MUN.cd_ibge
ORDER BY renda_media DESC;

-- Quantidade de famílias com e sem agua encanda por cidade e sua renda media
SELECT MUN.nome_municipio, 
    COUNT(CASE WHEN DOM.cod_agua_canalizada_fam = 1 THEN 1 END) AS agua_encanada,
    COUNT(CASE WHEN DOM.cod_agua_canalizada_fam = 2 THEN 1 END) AS sem_agua_encanada,
       (SELECT AVG(CAST(REPLACE(FAM2.vlr_renda_media_fam, ',', '.') AS DECIMAL(10, 2)))
        FROM TB_FAMILIA FAM2
        WHERE FAM2.cd_ibge = MUN.cd_ibge) AS renda_media
FROM TB_DOMICILIO DOM
LEFT JOIN TB_FAMILIA FAM ON DOM.id_familia = FAM.id_familia
LEFT JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
GROUP BY MUN.nome_municipio, MUN.cd_ibge
ORDER BY agua_encanada DESC;
