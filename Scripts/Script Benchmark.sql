DO $$
DECLARE
    i INTEGER;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN
    FOR i IN 1..10 LOOP
        start_time := clock_timestamp();
        EXECUTE '
        
        SELECT COUNT(DISTINCT id_pessoa)
        FROM TB_ESC
        WHERE ind_frequenta_escola_memb = 1;

        SELECT
            COUNT(DISTINCT id_familia) AS total,
            COUNT(CASE WHEN cod_escoa_sanitario_domic_fam IN (1, 2) THEN 1 END) AS saneamento_basico,
            COUNT(CASE WHEN cod_escoa_sanitario_domic_fam IN (3, 4, 5, 6) THEN 1 END) AS sem_saneamento_basico
        FROM TB_DOMICILIO;

        SELECT UF, COUNT(DISTINCT nome_municipio) AS Contagem
        FROM TB_MUN
        GROUP BY UF
        ORDER BY Contagem DESC;

        SELECT COUNT(DISTINCT id_familia)
        FROM TB_DOMICILIO
        WHERE cod_especie_domic_fam = 1;

        SELECT
            COUNT(DISTINCT id_familia) AS total,
            COUNT(CASE WHEN cod_agua_canalizada_fam = 1 THEN 1 END) AS agua_encanada,
            COUNT(CASE WHEN cod_agua_canalizada_fam = 2 THEN 1 END) AS sem_agua_encanada
        FROM TB_DOMICILIO;

        SELECT COUNT(DISTINCT FAM.id_familia) AS qtd_familias
        FROM TB_FAMILIA FAM
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        WHERE MUN.uf = ''BA'';

        SELECT MUN.nome_municipio, COUNT(ESC.id_pessoa) AS qtd_pessoas_escola
        FROM TB_ESC ESC
        INNER JOIN TB_FAMILIA FAM ON ESC.id_familia = FAM.id_familia
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        WHERE ESC.ind_frequenta_escola_memb = 1
        GROUP BY MUN.nome_municipio
        ORDER BY qtd_pessoas_escola DESC;

        SELECT MUN.nome_municipio, AVG(PSA.idade) AS idade_media
        FROM TB_PESSOA PSA
        INNER JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio;

        SELECT MUN.nome_municipio,
               AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, '','', ''.'') AS DECIMAL(10, 2))) AS renda_media
        FROM TB_FAMILIA FAM
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio;

        SELECT MUN.nome_municipio,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 1 THEN 1 END) AS branca,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 2 THEN 1 END) AS preta,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 3 THEN 1 END) AS amarela,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 4 THEN 1 END) AS parda,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 5 THEN 1 END) AS indigena
        FROM TB_PESSOA PSA
        INNER JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio
        ORDER BY MUN.nome_municipio;

        SELECT MUN.nome_municipio,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 1 THEN 1 END) AS branca,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 2 THEN 1 END) AS preta,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 3 THEN 1 END) AS amarela,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 4 THEN 1 END) AS parda,
               COUNT(CASE WHEN PSA.cod_raca_cor_pessoa = 5 THEN 1 END) AS indigena,
               (SELECT AVG(CAST(REPLACE(FAM2.vlr_renda_media_fam, '','', ''.'') AS DECIMAL(10, 2)))
                FROM TB_FAMILIA FAM2
                WHERE FAM2.cd_ibge = MUN.cd_ibge) AS renda_media
        FROM TB_PESSOA PSA
        INNER JOIN TB_FAMILIA FAM ON PSA.id_familia = FAM.id_familia
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        INNER JOIN TB_TRAB TRAB ON PSA.id_pessoa = TRAB.id_pessoa
        WHERE TRAB.cod_principal_trab_memb IN (4, 6, 8, 9, 10, 11)
        GROUP BY MUN.nome_municipio, MUN.cd_ibge
        ORDER BY MUN.nome_municipio;

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

        SELECT MUN.nome_municipio,
               AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, '','', ''.'') AS DECIMAL(10, 2))) AS renda_media,
               (SELECT AVG(PSA.idade)
                FROM TB_PESSOA PSA
                JOIN TB_FAMILIA FAM2 ON PSA.id_familia = FAM2.id_familia
                WHERE FAM2.cd_ibge = MUN.cd_ibge) AS idade_media
        FROM TB_FAMILIA FAM
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio, MUN.cd_ibge
        ORDER BY renda_media DESC;

        SELECT MUN.nome_municipio,
               AVG(CAST(REPLACE(FAM.vlr_renda_media_fam, '','', ''.'') AS DECIMAL(10, 2))) AS renda_media,
               (SELECT COUNT(ESC.id_pessoa)
                FROM TB_ESC ESC
                JOIN TB_FAMILIA FAM2 ON ESC.id_familia = FAM2.id_familia
                WHERE FAM2.cd_ibge = MUN.cd_ibge AND ESC.ind_frequenta_escola_memb IN (1,2) ) AS qtd_pessoas_escola
        FROM TB_FAMILIA FAM
        INNER JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio, MUN.cd_ibge
        ORDER BY renda_media DESC;

        SELECT MUN.nome_municipio,
            COUNT(CASE WHEN DOM.cod_agua_canalizada_fam = 1 THEN 1 END) AS agua_encanada,
            COUNT(CASE WHEN DOM.cod_agua_canalizada_fam = 2 THEN 1 END) AS sem_agua_encanada,
               (SELECT AVG(CAST(REPLACE(FAM2.vlr_renda_media_fam, '','', ''.'') AS DECIMAL(10, 2)))
                FROM TB_FAMILIA FAM2
                WHERE FAM2.cd_ibge = MUN.cd_ibge) AS renda_media
        FROM TB_DOMICILIO DOM
        LEFT JOIN TB_FAMILIA FAM ON DOM.id_familia = FAM.id_familia
        LEFT JOIN TB_MUN MUN ON FAM.cd_ibge = MUN.cd_ibge
        GROUP BY MUN.nome_municipio, MUN.cd_ibge
        ORDER BY agua_encanada DESC;

        end_time := clock_timestamp();
        RAISE NOTICE 'Query Index 2, Iteração %: Tempo de execução = %', i, end_time - start_time;
    END LOOP;
END $$;