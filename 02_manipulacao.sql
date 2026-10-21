-- =====================================================================
-- Projecto de Base de Dados: Sistema de Aluguer de Casas e Quartos
-- Ficheiro: 02_manipulacao.sql (executar depois de 01_criacao_e_insercao.sql)
-- Cada comando indica o RESULTADO ESPERADO antes de ser executado.
-- =====================================================================

USE aluguer_imoveis;

-- ---------------------------------------------------------------------
-- A. SELECT SIMPLES (3)
-- ---------------------------------------------------------------------

-- A1. Inquilinos que são estudantes, por ordem alfabética.
-- ESPERADO: 4 linhas (Abel, Hortência, Katia e Quirino).
SELECT nome, telefone, profissao
FROM inquilino
WHERE profissao = 'Estudante'
ORDER BY nome;

-- A2. Imóveis da Beira com renda base inferior a 20000, do mais caro para o mais barato.
-- ESPERADO: 9 linhas; o primeiro é o de 19000 e o último o de 9000.
SELECT id_imovel, tipo, endereco, bairro, renda_base
FROM imovel
WHERE cidade = 'Beira' AND renda_base < 20000
ORDER BY renda_base DESC;

-- A3. Contratos activos, do maior para o menor valor de renda.
-- ESPERADO: 22 linhas; o primeiro tem renda de 50000.
SELECT id_contrato, data_inicio, data_fim, renda_mensal
FROM contrato
WHERE estado = 'Activo'
ORDER BY renda_mensal DESC;

-- ---------------------------------------------------------------------
-- B. SELECT COM JOIN (2)
-- ---------------------------------------------------------------------

-- B1. Contratos activos com inquilino, imóvel e proprietário (4 tabelas).
-- ESPERADO: 22 linhas, cada uma com os nomes do inquilino e do proprietário.
SELECT c.id_contrato,
       i.nome  AS inquilino,
       im.endereco,
       im.bairro,
       p.nome  AS proprietario,
       c.renda_mensal
FROM contrato c
JOIN inquilino    i  ON c.id_inquilino    = i.id_inquilino
JOIN imovel       im ON c.id_imovel       = im.id_imovel
JOIN proprietario p  ON im.id_proprietario = p.id_proprietario
WHERE c.estado = 'Activo'
ORDER BY c.id_contrato;

-- B2. Contratos de quartos, com a descrição do quarto (usa a chave composta da entidade fraca).
-- ESPERADO: 10 linhas (só os contratos de quartos; os de casa inteira não aparecem).
SELECT c.id_contrato,
       i.nome AS inquilino,
       q.id_imovel,
       q.numero_quarto,
       q.descricao,
       c.renda_mensal
FROM contrato c
JOIN quarto q    ON c.id_imovel = q.id_imovel AND c.numero_quarto = q.numero_quarto
JOIN inquilino i ON c.id_inquilino = i.id_inquilino
ORDER BY c.id_contrato;

-- ---------------------------------------------------------------------
-- C. UPDATE (2)
-- ---------------------------------------------------------------------

-- C1. O imóvel 21 terminou a manutenção e volta a ficar disponível.
-- ESPERADO: 1 linha afectada; o estado passa de 'Manutencao' para 'Disponivel'.
UPDATE imovel
SET estado = 'Disponivel'
WHERE id_imovel = 21;

SELECT id_imovel, endereco, estado FROM imovel WHERE id_imovel = 21;

-- C2. Reajuste de 10% na renda do contrato 11.
-- ESPERADO: 1 linha afectada; a renda passa de 15000.00 para 16500.00.
UPDATE contrato
SET renda_mensal = renda_mensal * 1.10
WHERE id_contrato = 11;

SELECT id_contrato, renda_mensal FROM contrato WHERE id_contrato = 11;

-- ---------------------------------------------------------------------
-- D. DELETE (1) — respeitando as chaves estrangeiras
-- ---------------------------------------------------------------------

-- D1. Eliminar o imóvel 22. Não tem quartos nem contratos associados,
--     logo nenhuma chave estrangeira o impede.
-- ESPERADO: 1 linha afectada; o imóvel deixa de existir.
-- (Já o imóvel 1 não poderia ser eliminado: tem quartos e contratos associados.)
DELETE FROM imovel
WHERE id_imovel = 22;

SELECT COUNT(*) AS imoveis_restantes FROM imovel;   -- ESPERADO: 21

-- ---------------------------------------------------------------------
-- E. TESTE DE INTEGRIDADE (1)
-- ---------------------------------------------------------------------

-- E1. Inserir um imóvel com um proprietário que não existe (id 999).
-- ESPERADO: ERRO. Erro 1452 — "Cannot add or update a child row: a foreign key
-- constraint fails". A chave estrangeira id_proprietario exige que o valor
-- exista na tabela proprietario, e o 999 não existe. O MySQL recusa a inserção
-- e protege a integridade referencial.
INSERT INTO imovel (tipo, endereco, bairro, cidade, renda_base, estado, id_proprietario)
VALUES ('Casa', 'Rua Teste, 1', 'Macuti', 'Beira', 10000, 'Disponivel', 999);
