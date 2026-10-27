-- ============================================================
-- PROJETO: GESTÃO DO TROFÉU ALEXANDRE AZAMBUJA PUSSIELDI
-- EDIÇÃO: 29ª edição - 2025
-- BANCO DE DADOS: POSTGRESQL
-- ============================================================


-- ============================================================
-- 0. LIMPEZA PRÉVIA DAS TABELAS
-- ATENÇÃO: APAGA AS TABELAS E OS DADOS EXISTENTES!
-- ============================================================

DROP TABLE IF EXISTS RESULTADO CASCADE;
DROP TABLE IF EXISTS INSCRICAO CASCADE;
DROP TABLE IF EXISTS PROVA CASCADE;
DROP TABLE IF EXISTS ATLETA CASCADE;
DROP TABLE IF EXISTS CATEGORIA CASCADE;
DROP TABLE IF EXISTS CLUBE CASCADE;
DROP TABLE IF EXISTS ETAPA CASCADE;
DROP TABLE IF EXISTS EVENTO CASCADE;


-- ============================================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================


-- ------------------------------------------------------------
-- 1.1. TABELA: EVENTO
-- ------------------------------------------------------------

CREATE TABLE EVENTO (
    id_evento SERIAL PRIMARY KEY,
    nome_evento VARCHAR(150) NOT NULL,
    edicao INT NOT NULL,
    local_evento VARCHAR(150),
    tipo_piscina VARCHAR(10),
    data_inicio DATE,
    data_fim DATE,
    taxa_individual DECIMAL(10, 2),
    taxa_revezamento DECIMAL(10, 2),

    CONSTRAINT uk_evento_edicao
        UNIQUE (nome_evento, edicao)
);


-- ------------------------------------------------------------
-- 1.2. TABELA: ETAPA
-- ------------------------------------------------------------

CREATE TABLE ETAPA (
    id_etapa SERIAL PRIMARY KEY,
    id_evento INT NOT NULL,
    numero_etapa INT NOT NULL,
    data_etapa DATE,
    horario_aquecimento TIME,
    horario_inicio TIME,

    CONSTRAINT fk_etapa_evento
        FOREIGN KEY (id_evento)
        REFERENCES EVENTO(id_evento)
        ON DELETE CASCADE,

    CONSTRAINT uk_etapa_numero
        UNIQUE (id_evento, numero_etapa)
);


-- ------------------------------------------------------------
-- 1.3. TABELA: CLUBE
-- ------------------------------------------------------------

CREATE TABLE CLUBE (
    id_clube SERIAL PRIMARY KEY,
    sigla_clube VARCHAR(20) NOT NULL UNIQUE,
    nome_clube VARCHAR(150),
    uf VARCHAR(2)
);


-- ------------------------------------------------------------
-- 1.4. TABELA: CATEGORIA
-- ------------------------------------------------------------

CREATE TABLE CATEGORIA (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL,
    sigla_categoria VARCHAR(10) NOT NULL UNIQUE,
    ano_nascimento INT
);


-- ------------------------------------------------------------
-- 1.5. TABELA: ATLETA
-- ------------------------------------------------------------

CREATE TABLE ATLETA (
    id_atleta SERIAL PRIMARY KEY,
    registro_cbda INT NOT NULL UNIQUE,
    nome_atleta VARCHAR(150) NOT NULL,
    ano_nascimento INT NOT NULL,

    -- Idade calculada para o ano de 2025
    idade INT,

    genero VARCHAR(20),
    id_clube INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT fk_atleta_clube
        FOREIGN KEY (id_clube)
        REFERENCES CLUBE(id_clube)
        ON DELETE RESTRICT,

    CONSTRAINT fk_atleta_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria)
        ON DELETE RESTRICT
);


-- ------------------------------------------------------------
-- 1.6. TABELA: PROVA
-- ------------------------------------------------------------

CREATE TABLE PROVA (
    id_prova SERIAL PRIMARY KEY,
    numero_prova INT NOT NULL,
    distancia INT NOT NULL,
    estilo VARCHAR(30) NOT NULL,
    genero VARCHAR(20) NOT NULL,
    tipo_prova VARCHAR(30) NOT NULL,
    id_etapa INT NOT NULL,
    id_categoria INT NOT NULL,

    CONSTRAINT fk_prova_etapa
        FOREIGN KEY (id_etapa)
        REFERENCES ETAPA(id_etapa)
        ON DELETE CASCADE,

    CONSTRAINT fk_prova_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIA(id_categoria)
        ON DELETE RESTRICT,

    CONSTRAINT uk_prova_etapa
        UNIQUE (id_etapa, numero_prova)
);


-- ------------------------------------------------------------
-- 1.7. TABELA: INSCRICAO
-- ------------------------------------------------------------

CREATE TABLE INSCRICAO (
    id_inscricao SERIAL PRIMARY KEY,
    id_atleta INT NOT NULL,
    id_prova INT NOT NULL,
    tempo_inscricao VARCHAR(10),
    data_inscricao DATE,

    CONSTRAINT fk_inscricao_atleta
        FOREIGN KEY (id_atleta)
        REFERENCES ATLETA(id_atleta)
        ON DELETE CASCADE,

    CONSTRAINT fk_inscricao_prova
        FOREIGN KEY (id_prova)
        REFERENCES PROVA(id_prova)
        ON DELETE CASCADE,

    CONSTRAINT uk_inscricao_atleta_prova
        UNIQUE (id_atleta, id_prova)
);


-- ------------------------------------------------------------
-- 1.8. TABELA: RESULTADO
-- ------------------------------------------------------------

CREATE TABLE RESULTADO (
    id_resultado SERIAL PRIMARY KEY,
    id_inscricao INT NOT NULL UNIQUE,
    colocacao INT,
    tempo_obtido VARCHAR(10),
    pontuacao DECIMAL(5, 2),

    CONSTRAINT fk_resultado_inscricao
        FOREIGN KEY (id_inscricao)
        REFERENCES INSCRICAO(id_inscricao)
        ON DELETE CASCADE
);


-- ============================================================
-- 2. INSERÇÃO DE DADOS (DML)
-- ============================================================


-- ------------------------------------------------------------
-- 2.1. EVENTO
-- ------------------------------------------------------------

INSERT INTO EVENTO (
    nome_evento,
    edicao,
    local_evento,
    tipo_piscina,
    data_inicio,
    data_fim,
    taxa_individual,
    taxa_revezamento
)
VALUES (
    'Troféu Alexandre Azambuja Pussieldi',
    29,
    'UFAL - Maceió/AL',
    '25M',
    '2025-03-27',
    '2025-03-29',
    40.00,
    160.00
);


-- ------------------------------------------------------------
-- 2.2. ETAPAS
-- ------------------------------------------------------------

INSERT INTO ETAPA (
    id_evento,
    numero_etapa,
    data_etapa,
    horario_aquecimento,
    horario_inicio
)
VALUES
    (1, 1, '2025-03-27', '07:30:00', '09:00:00'),
    (1, 2, '2025-03-28', '07:45:00', '09:00:00'),
    (1, 3, '2025-03-29', '07:45:00', '09:00:00');


-- ------------------------------------------------------------
-- 2.3. CLUBES
-- ------------------------------------------------------------

INSERT INTO CLUBE (
    sigla_clube,
    nome_clube,
    uf
)
VALUES
    ('AABB-REC', 'ASS ATL BANCO DO BRASIL-RECIFE', 'PE'),
    ('CEPE/BA', 'CLUBE DOS EMPREGADOS DA PETROBRÁS', 'BA'),
    ('FENIX/NADART', 'FENIX/NADART/AL', 'AL'),
    ('AADC/AL', 'AADC - ASSOCIAÇÃO ATLETICA DIEGO CALADO', 'AL'),
    ('MASSAYO', 'ESPORTE CLUBE MASSAYO', 'AL');


-- ------------------------------------------------------------
-- 2.4. CATEGORIAS
-- ------------------------------------------------------------

INSERT INTO CATEGORIA (
    nome_categoria,
    sigla_categoria,
    ano_nascimento
)
VALUES
    ('Pré-Mirim', 'PM', 2017),
    ('Mirim I', 'M1', 2016),
    ('Mirim II', 'M2', 2015);


-- ------------------------------------------------------------
-- 2.5. ATLETAS
-- ------------------------------------------------------------

INSERT INTO ATLETA (
    registro_cbda,
    nome_atleta,
    ano_nascimento,
    idade,
    genero,
    id_clube,
    id_categoria
)
VALUES
    (395721, 'FRANCISCO CLEMENTE DUARTE', 2017, 8,
     'Masculino', 4, 1),

    (410678, 'ESTER MANUELA GOMES', 2015, 10,
     'Feminino', 5, 3),

    (376510, 'DIEGO GAMA RODRIGUES', 2015, 10,
     'Masculino', 3, 3),

    (381020, 'MARIA ISIS BARBOSA', 2015, 10,
     'Feminino', 5, 3);


-- ------------------------------------------------------------
-- 2.6. PROVAS
-- ------------------------------------------------------------

INSERT INTO PROVA (
    numero_prova,
    distancia,
    estilo,
    genero,
    tipo_prova,
    id_etapa,
    id_categoria
)
VALUES
    (5,  50, 'Livre',     'Feminino',  'Individual', 1, 1),
    (6,  50, 'Livre',     'Masculino', 'Individual', 1, 1),
    (9,  50, 'Costas',    'Feminino',  'Individual', 1, 3),
    (12, 50, 'Borboleta', 'Masculino', 'Individual', 1, 1),
    (27, 50, 'Livre',     'Feminino',  'Individual', 2, 3),
    (28, 50, 'Livre',     'Masculino', 'Individual', 2, 3);


-- ------------------------------------------------------------
-- 2.7. INSCRIÇÕES
-- ------------------------------------------------------------

INSERT INTO INSCRICAO (
    id_atleta,
    id_prova,
    tempo_inscricao,
    data_inscricao
)
VALUES
    (1, 2, '99:99.99', '2025-03-15'),
    (1, 4, '99:99.99', '2025-03-15'),
    (2, 3, '01:03.23', '2025-03-15'),
    (2, 5, '00:46.08', '2025-03-15'),
    (3, 6, '00:35.87', '2025-03-15');


-- ------------------------------------------------------------
-- 2.8. RESULTADOS
-- ------------------------------------------------------------

INSERT INTO RESULTADO (
    id_inscricao,
    colocacao,
    tempo_obtido,
    pontuacao
)
VALUES
    (5, 1, '00:34.40', 25.00),
    (4, 2, '00:45.10', 22.00);


-- ============================================================
-- 3. CONSULTA DE TESTE
-- RELATÓRIO DE INSCRIÇÕES E RESULTADOS DOS ATLETAS
-- ============================================================

SELECT
    a.nome_atleta AS "Atleta",
    a.idade AS "Idade",
    a.ano_nascimento AS "Ano Nasc.",
    c.sigla_clube AS "Clube",
    cat.nome_categoria AS "Categoria",
    p.numero_prova AS "Nº Prova",

    CONCAT(p.distancia, 'm ', p.estilo) AS "Prova",

    i.tempo_inscricao AS "Tempo Insc.",
    r.colocacao AS "Posição",
    r.tempo_obtido AS "Tempo Final",
    r.pontuacao AS "Pontos"

FROM INSCRICAO AS i

INNER JOIN ATLETA AS a
    ON i.id_atleta = a.id_atleta

INNER JOIN CLUBE AS c
    ON a.id_clube = c.id_clube

INNER JOIN CATEGORIA AS cat
    ON a.id_categoria = cat.id_categoria

INNER JOIN PROVA AS p
    ON i.id_prova = p.id_prova

LEFT JOIN RESULTADO AS r
    ON r.id_inscricao = i.id_inscricao

ORDER BY
    a.nome_atleta,
    p.numero_prova;

