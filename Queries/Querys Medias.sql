-- Quantidade de famílias distintas na Bahia
SELECT COUNT(DISTINCT FAM.id_familia) AS qtd_familias
FROM TB_FAMILIA FAM
INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
WHERE MUN.uf = 'BA';

-- Quantidade de pessoas que frequentam a escola por município
SELECT MUN.nome_municipio, COUNT(ESC.id_pessoa) AS qtd_pessoas_escola
FROM TB_ESC ESC
JOIN TB_FAMILIA FAM ON ESC.id_familia = FAM.id_familia
JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
WHERE ESC.ind_frequenta_escola_memb = 1
GROUP BY MUN.nome_municipio
ORDER BY qtd_pessoas_escola DESC;

-- Média de idade das pessoas por município
SELECT mun.nome_municipio, AVG(pessoa.idade) AS idade_media
FROM TB_PESSOA pessoa
JOIN TB_FAMILIA fam ON pessoa.id_familia = fam.id_familia
JOIN TB_MUNICIPIOS mun ON fam.cd_ibge = mun.cd_ibge
GROUP BY mun.nome_municipio;

-- Renda média das famílias por município
SELECT MUN.nome_municipio, 
       AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, ',', '.') AS DECIMAL(10, 2))) AS renda_media
FROM TB_FAMILIA FAM
JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
GROUP BY MUN.nome_municipio;

-- Quantidade de pessoas por raça/cor em cada município
SELECT MUN.nome_municipio, 
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 1 THEN 1 END) AS branca,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 2 THEN 1 END) AS preta,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 3 THEN 1 END) AS amarela,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 4 THEN 1 END) AS parda,
       COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 5 THEN 1 END) AS indigena
FROM TB_PESSOA PSA
JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
GROUP BY MUN.nome_municipio
ORDER BY MUN.nome_municipio;