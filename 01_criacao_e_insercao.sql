-- =====================================================================
-- Projecto de Base de Dados: Sistema de Aluguer de Casas e Quartos
-- Disciplina: Tecnologias de Base de Dados (2.º ano, Licenciatura em Informática)
-- SGBD: MySQL 8.x
-- Ficheiro: 01_criacao_e_insercao.sql (executa de raiz, sem erros)
-- =====================================================================

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS aluguer_imoveis;
CREATE DATABASE aluguer_imoveis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aluguer_imoveis;

-- ---------------------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS (ordem imposta pelas chaves estrangeiras)
-- ---------------------------------------------------------------------

CREATE TABLE utilizador (
  id_utilizador INT AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(100) NOT NULL UNIQUE,
  senha         VARCHAR(255) NOT NULL,
  perfil        ENUM('Proprietario','Inquilino') NOT NULL,
  data_criacao  DATE NOT NULL
);

CREATE TABLE proprietario (
  id_proprietario INT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(100) NOT NULL,
  bi              VARCHAR(20)  NOT NULL UNIQUE,
  telefone        VARCHAR(15)  NOT NULL,
  id_utilizador   INT NOT NULL UNIQUE,
  FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador)
);

CREATE TABLE inquilino (
  id_inquilino  INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(100) NOT NULL,
  bi            VARCHAR(20)  NOT NULL UNIQUE,
  telefone      VARCHAR(15)  NOT NULL,
  profissao     VARCHAR(60),
  id_utilizador INT NOT NULL UNIQUE,
  FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador)
);

CREATE TABLE imovel (
  id_imovel       INT AUTO_INCREMENT PRIMARY KEY,
  tipo            ENUM('Casa','Apartamento') NOT NULL,
  endereco        VARCHAR(150) NOT NULL,
  bairro          VARCHAR(60)  NOT NULL,
  cidade          VARCHAR(60)  NOT NULL,
  renda_base      DECIMAL(10,2) NOT NULL CHECK (renda_base > 0),
  estado          ENUM('Disponivel','Arrendado','Manutencao') NOT NULL DEFAULT 'Disponivel',
  id_proprietario INT NOT NULL,
  FOREIGN KEY (id_proprietario) REFERENCES proprietario(id_proprietario)
);

-- Entidade fraca: o quarto só existe dentro de um imóvel
CREATE TABLE quarto (
  id_imovel     INT NOT NULL,
  numero_quarto INT NOT NULL,
  descricao     VARCHAR(150),
  renda         DECIMAL(10,2) NOT NULL CHECK (renda > 0),
  estado        ENUM('Disponivel','Ocupado','Manutencao') NOT NULL DEFAULT 'Disponivel',
  PRIMARY KEY (id_imovel, numero_quarto),
  FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel) ON DELETE CASCADE
);

-- numero_quarto fica NULL quando o contrato é da casa inteira
CREATE TABLE contrato (
  id_contrato   INT AUTO_INCREMENT PRIMARY KEY,
  data_inicio   DATE NOT NULL,
  data_fim      DATE NOT NULL,
  renda_mensal  DECIMAL(10,2) NOT NULL CHECK (renda_mensal > 0),
  estado        ENUM('Activo','Terminado','Cancelado') NOT NULL DEFAULT 'Activo',
  id_inquilino  INT NOT NULL,
  id_imovel     INT NOT NULL,
  numero_quarto INT NULL,
  CHECK (data_fim > data_inicio),
  FOREIGN KEY (id_inquilino) REFERENCES inquilino(id_inquilino),
  FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel),
  FOREIGN KEY (id_imovel, numero_quarto) REFERENCES quarto(id_imovel, numero_quarto)
);

CREATE TABLE pagamento (
  id_pagamento   INT AUTO_INCREMENT PRIMARY KEY,
  data_pagamento DATE NOT NULL,
  valor          DECIMAL(10,2) NOT NULL CHECK (valor > 0),
  metodo         ENUM('M-Pesa','e-Mola','Numerario','Transferencia') NOT NULL,
  mes_referente  DATE NOT NULL,
  id_contrato    INT NOT NULL,
  FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

-- ---------------------------------------------------------------------
-- 2. INSERÇÃO DE REGISTOS (respeitando a ordem das chaves estrangeiras)
-- ---------------------------------------------------------------------
-- UTILIZADOR (1-20 proprietários, 21-40 inquilinos)
INSERT INTO utilizador (email, senha, perfil, data_criacao) VALUES
  ('armando.chissano@gmail.com', SHA2('senha101',256), 'Proprietario', '2026-01-02'),
  ('beatriz.macuacua@gmail.com', SHA2('senha102',256), 'Proprietario', '2026-01-03'),
  ('carlos.mondlane@gmail.com', SHA2('senha103',256), 'Proprietario', '2026-01-04'),
  ('dulce.tembe@gmail.com', SHA2('senha104',256), 'Proprietario', '2026-01-05'),
  ('eduardo.sitoe@gmail.com', SHA2('senha105',256), 'Proprietario', '2026-01-06'),
  ('fatima.cossa@gmail.com', SHA2('senha106',256), 'Proprietario', '2026-01-07'),
  ('gaspar.nhantumbo@gmail.com', SHA2('senha107',256), 'Proprietario', '2026-01-08'),
  ('helena.bila@gmail.com', SHA2('senha108',256), 'Proprietario', '2026-01-09'),
  ('ismael.muianga@gmail.com', SHA2('senha109',256), 'Proprietario', '2026-01-10'),
  ('joana.zimba@gmail.com', SHA2('senha110',256), 'Proprietario', '2026-01-11'),
  ('kassamo.abdul@gmail.com', SHA2('senha111',256), 'Proprietario', '2026-01-12'),
  ('lurdes.manjate@gmail.com', SHA2('senha112',256), 'Proprietario', '2026-01-13'),
  ('manuel.guambe@gmail.com', SHA2('senha113',256), 'Proprietario', '2026-01-14'),
  ('nelta.machava@gmail.com', SHA2('senha114',256), 'Proprietario', '2026-01-15'),
  ('orlando.langa@gmail.com', SHA2('senha115',256), 'Proprietario', '2026-01-16'),
  ('paulina.uamusse@gmail.com', SHA2('senha116',256), 'Proprietario', '2026-01-17'),
  ('quiteria.mabunda@gmail.com', SHA2('senha117',256), 'Proprietario', '2026-01-18'),
  ('rui.chongo@gmail.com', SHA2('senha118',256), 'Proprietario', '2026-01-19'),
  ('sonia.matavele@gmail.com', SHA2('senha119',256), 'Proprietario', '2026-01-20'),
  ('tomas.nhamussua@gmail.com', SHA2('senha120',256), 'Proprietario', '2026-01-21'),
  ('abel.jossias@gmail.com', SHA2('senha121',256), 'Inquilino', '2026-01-22'),
  ('benilde.cumbe@gmail.com', SHA2('senha122',256), 'Inquilino', '2026-01-23'),
  ('celso.macamo@gmail.com', SHA2('senha123',256), 'Inquilino', '2026-01-24'),
  ('debora.mutisse@gmail.com', SHA2('senha124',256), 'Inquilino', '2026-01-25'),
  ('elias.sambo@gmail.com', SHA2('senha125',256), 'Inquilino', '2026-01-26'),
  ('filomena.dimande@gmail.com', SHA2('senha126',256), 'Inquilino', '2026-01-27'),
  ('gilberto.mucavele@gmail.com', SHA2('senha127',256), 'Inquilino', '2026-01-01'),
  ('hortencia.banze@gmail.com', SHA2('senha128',256), 'Inquilino', '2026-01-02'),
  ('isaura.ngovene@gmail.com', SHA2('senha129',256), 'Inquilino', '2026-01-03'),
  ('jorge.paulo@gmail.com', SHA2('senha130',256), 'Inquilino', '2026-01-04'),
  ('katia.massinga@gmail.com', SHA2('senha131',256), 'Inquilino', '2026-01-05'),
  ('lazaro.sumbana@gmail.com', SHA2('senha132',256), 'Inquilino', '2026-01-06'),
  ('marcia.tivane@gmail.com', SHA2('senha133',256), 'Inquilino', '2026-01-07'),
  ('nilton.chirrime@gmail.com', SHA2('senha134',256), 'Inquilino', '2026-01-08'),
  ('olivia.baloi@gmail.com', SHA2('senha135',256), 'Inquilino', '2026-01-09'),
  ('pedro.maculuve@gmail.com', SHA2('senha136',256), 'Inquilino', '2026-01-10'),
  ('quirino.chembene@gmail.com', SHA2('senha137',256), 'Inquilino', '2026-01-11'),
  ('rosa.mavie@gmail.com', SHA2('senha138',256), 'Inquilino', '2026-01-12'),
  ('sergio.mulungo@gmail.com', SHA2('senha139',256), 'Inquilino', '2026-01-13'),
  ('telma.zandamela@gmail.com', SHA2('senha140',256), 'Inquilino', '2026-01-14');

-- PROPRIETARIO
INSERT INTO proprietario (nome, bi, telefone, id_utilizador) VALUES
  ('Armando Chissano', '110100234561A', '843210011', 1),
  ('Beatriz Macuácua', '110100345672B', '824560022', 2),
  ('Carlos Mondlane', '110100456783C', '855670033', 3),
  ('Dulce Tembe', '110100567894D', '866780044', 4),
  ('Eduardo Sitoe', '110100678905E', '877890055', 5),
  ('Fátima Cossa', '110100789016F', '848900066', 6),
  ('Gaspar Nhantumbo', '110100890127G', '829010077', 7),
  ('Helena Bila', '110100901238H', '851120088', 8),
  ('Ismael Muianga', '110101012349I', '862230099', 9),
  ('Joana Zimba', '110101123450J', '873340110', 10),
  ('Kassamo Abdul', '110101234561K', '844450121', 11),
  ('Lurdes Manjate', '110101345672L', '825560132', 12),
  ('Manuel Guambe', '110101456783M', '856670143', 13),
  ('Nelta Machava', '110101567894N', '867780154', 14),
  ('Orlando Langa', '110101678905O', '878890165', 15),
  ('Paulina Uamusse', '110101789016P', '849900176', 16),
  ('Quitéria Mabunda', '110101890127Q', '820010187', 17),
  ('Rui Chongo', '110101901238R', '851120198', 18),
  ('Sónia Matavele', '110102012349S', '862230209', 19),
  ('Tomás Nhamussua', '110102123450T', '873340210', 20);

-- INQUILINO
INSERT INTO inquilino (nome, bi, telefone, profissao, id_utilizador) VALUES
  ('Abel Jossias', '110200234561A', '844001001', 'Estudante', 21),
  ('Benilde Cumbe', '110200345672B', '825002002', 'Enfermeira', 22),
  ('Celso Macamo', '110200456783C', '856003003', 'Motorista', 23),
  ('Débora Mutisse', '110200567894D', '867004004', 'Professora', 24),
  ('Elias Sambo', '110200678905E', '878005005', 'Comerciante', 25),
  ('Filomena Dimande', '110200789016F', '849006006', 'Contabilista', 26),
  ('Gilberto Mucavele', '110200890127G', '820007007', 'Técnico de informática', 27),
  ('Hortência Banze', '110200901238H', '851008008', 'Estudante', 28),
  ('Isaura Ngovene', '110201012349I', '862009009', 'Funcionária pública', 29),
  ('Jorge Paulo', '110201123450J', '873010010', 'Electricista', 30),
  ('Katia Massinga', '110201234561K', '844011011', 'Estudante', 31),
  ('Lázaro Sumbana', '110201345672L', '825012012', 'Mecânico', 32),
  ('Márcia Tivane', '110201456783M', '856013013', 'Enfermeira', 33),
  ('Nilton Chirrime', '110201567894N', '867014014', 'Segurança', 34),
  ('Olívia Baloi', '110201678905O', '878015015', 'Professora', 35),
  ('Pedro Maculuve', '110201789016P', '849016016', 'Pedreiro', 36),
  ('Quirino Chembene', '110201890127Q', '820017017', 'Estudante', 37),
  ('Rosa Mavie', '110202012349R', '851018018', 'Comerciante', 38),
  ('Sérgio Mulungo', '110202123450S', '862019019', 'Engenheiro civil', 39),
  ('Telma Zandamela', '110202234561T', '873020020', 'Recepcionista', 40);

-- IMOVEL
INSERT INTO imovel (tipo, endereco, bairro, cidade, renda_base, estado, id_proprietario) VALUES
  ('Casa', 'Rua dos Continuadores, 120', 'Macuti', 'Beira', 18000, 'Arrendado', 1),
  ('Casa', 'Av. Samora Machel, 455', 'Manga', 'Beira', 20000, 'Arrendado', 2),
  ('Casa', 'Rua Correia de Brito, 31', 'Esturro', 'Beira', 16000, 'Arrendado', 3),
  ('Casa', 'Rua Jaime Ferreira, 78', 'Munhava', 'Beira', 14000, 'Arrendado', 4),
  ('Casa', 'Rua Major Serpa Pinto, 210', 'Ponta-Gêa', 'Beira', 22000, 'Arrendado', 5),
  ('Casa', 'Rua do Sol Nascente, 9', 'Ndunda', 'Beira', 12000, 'Arrendado', 6),
  ('Casa', 'Av. 25 de Setembro, 301', 'Chaimite', 'Beira', 15000, 'Arrendado', 7),
  ('Casa', 'Rua dos Mártires, 66', 'Matacuane', 'Beira', 13000, 'Arrendado', 8),
  ('Apartamento', 'Av. Eduardo Mondlane, 1020, 2º andar', 'Palmeiras', 'Beira', 25000, 'Arrendado', 9),
  ('Casa', 'Rua da Liberdade, 14', 'Inhamizua', 'Beira', 9000, 'Arrendado', 10),
  ('Apartamento', 'Av. Julius Nyerere, 580, 1º andar', 'Polana', 'Maputo', 45000, 'Arrendado', 11),
  ('Casa', 'Rua de Mukumbura, 72', 'Malhangalene', 'Maputo', 35000, 'Arrendado', 12),
  ('Casa', 'Av. de Moçambique, 1500', 'Alto-Maé', 'Maputo', 30000, 'Arrendado', 13),
  ('Apartamento', 'Rua Tomás Nduda, 18, 3º andar', 'Sommerschield', 'Maputo', 50000, 'Arrendado', 14),
  ('Casa', 'Rua da Machava, 245', 'Machava', 'Matola', 17000, 'Arrendado', 15),
  ('Casa', 'Av. dos Combatentes, 33', 'Fomento', 'Matola', 14500, 'Arrendado', 16),
  ('Casa', 'Rua 12, Quarteirão 5', 'Tchumene', 'Matola', 11000, 'Arrendado', 17),
  ('Casa', 'Rua do Mercado, 87', 'Muhala', 'Nampula', 10000, 'Arrendado', 18),
  ('Casa', 'Rua dos Heróis, 40', 'Natikiri', 'Nampula', 9500, 'Disponivel', 19),
  ('Apartamento', 'Av. do Trabalho, 220, 4º andar', 'Alto-Maé', 'Maputo', 28000, 'Disponivel', 20),
  ('Casa', 'Rua das Acácias, 15', 'Macuti', 'Beira', 19000, 'Manutencao', 1),
  ('Casa', 'Rua 3, Quarteirão 8', 'Manga', 'Beira', 13500, 'Disponivel', 3);

-- QUARTO (imóveis 1 a 6, 4 quartos cada)
INSERT INTO quarto (id_imovel, numero_quarto, descricao, renda, estado) VALUES
  (1, 1, 'Quarto individual com janela para o quintal', 4000, 'Ocupado'),
  (1, 2, 'Quarto com casa de banho privativa', 5500, 'Ocupado'),
  (1, 3, 'Quarto pequeno, ideal para estudante', 3500, 'Disponivel'),
  (1, 4, 'Quarto amplo com varanda', 5000, 'Disponivel'),
  (2, 1, 'Quarto individual com janela para o quintal', 4500, 'Ocupado'),
  (2, 2, 'Quarto com casa de banho privativa', 6000, 'Disponivel'),
  (2, 3, 'Quarto pequeno, ideal para estudante', 4000, 'Ocupado'),
  (2, 4, 'Quarto amplo com varanda', 5500, 'Disponivel'),
  (3, 1, 'Quarto individual com janela para o quintal', 3500, 'Disponivel'),
  (3, 2, 'Quarto com casa de banho privativa', 5000, 'Ocupado'),
  (3, 3, 'Quarto pequeno, ideal para estudante', 3000, 'Disponivel'),
  (3, 4, 'Quarto amplo com varanda', 4500, 'Disponivel'),
  (4, 1, 'Quarto individual com janela para o quintal', 4000, 'Ocupado'),
  (4, 2, 'Quarto com casa de banho privativa', 5500, 'Disponivel'),
  (4, 3, 'Quarto pequeno, ideal para estudante', 3500, 'Disponivel'),
  (4, 4, 'Quarto amplo com varanda', 5000, 'Ocupado'),
  (5, 1, 'Quarto individual com janela para o quintal', 4500, 'Disponivel'),
  (5, 2, 'Quarto com casa de banho privativa', 6000, 'Ocupado'),
  (5, 3, 'Quarto pequeno, ideal para estudante', 4000, 'Disponivel'),
  (5, 4, 'Quarto amplo com varanda', 5500, 'Manutencao'),
  (6, 1, 'Quarto individual com janela para o quintal', 3500, 'Ocupado'),
  (6, 2, 'Quarto com casa de banho privativa', 5000, 'Disponivel'),
  (6, 3, 'Quarto pequeno, ideal para estudante', 3000, 'Ocupado'),
  (6, 4, 'Quarto amplo com varanda', 4500, 'Disponivel');

-- CONTRATO (1-10: quartos; 11-22: casas inteiras; 23-24: histórico)
INSERT INTO contrato (data_inicio, data_fim, renda_mensal, estado, id_inquilino, id_imovel, numero_quarto) VALUES
  ('2026-01-01', '2027-01-01', 4000, 'Activo', 1, 1, 1),
  ('2026-02-01', '2027-02-01', 5500, 'Activo', 2, 1, 2),
  ('2026-03-01', '2027-03-01', 4500, 'Activo', 3, 2, 1),
  ('2026-03-01', '2027-03-01', 4000, 'Activo', 4, 2, 3),
  ('2026-04-01', '2027-04-01', 5000, 'Activo', 5, 3, 2),
  ('2026-04-01', '2027-04-01', 4000, 'Activo', 6, 4, 1),
  ('2026-05-01', '2027-05-01', 5000, 'Activo', 7, 4, 4),
  ('2026-05-01', '2027-05-01', 6000, 'Activo', 8, 5, 2),
  ('2026-06-01', '2027-06-01', 3500, 'Activo', 9, 6, 1),
  ('2026-06-01', '2027-06-01', 3000, 'Activo', 10, 6, 3),
  ('2026-07-01', '2027-07-01', 15000, 'Activo', 11, 7, NULL),
  ('2026-07-01', '2027-07-01', 13000, 'Activo', 12, 8, NULL),
  ('2026-08-01', '2027-08-01', 25000, 'Activo', 13, 9, NULL),
  ('2026-08-01', '2027-08-01', 9000, 'Activo', 14, 10, NULL),
  ('2026-09-01', '2027-09-01', 45000, 'Activo', 15, 11, NULL),
  ('2026-09-01', '2027-09-01', 35000, 'Activo', 16, 12, NULL),
  ('2026-02-01', '2027-02-01', 30000, 'Activo', 17, 13, NULL),
  ('2026-03-01', '2027-03-01', 50000, 'Activo', 18, 14, NULL),
  ('2026-04-01', '2027-04-01', 17000, 'Activo', 19, 15, NULL),
  ('2026-05-01', '2027-05-01', 14500, 'Activo', 20, 16, NULL),
  ('2026-06-01', '2027-06-01', 11000, 'Activo', 3, 17, NULL),
  ('2026-07-01', '2027-07-01', 10000, 'Activo', 7, 18, NULL),
  ('2025-01-01', '2025-12-31', 9500, 'Terminado', 5, 19, NULL),
  ('2025-06-01', '2025-09-30', 28000, 'Cancelado', 9, 20, NULL);

-- PAGAMENTO
INSERT INTO pagamento (data_pagamento, valor, metodo, mes_referente, id_contrato) VALUES
  ('2026-01-05', 4000, 'M-Pesa', '2026-01-01', 1),
  ('2026-02-05', 4000, 'e-Mola', '2026-02-01', 1),
  ('2026-02-06', 5500, 'e-Mola', '2026-02-01', 2),
  ('2026-03-07', 4500, 'Numerario', '2026-03-01', 3),
  ('2026-04-07', 4500, 'Transferencia', '2026-04-01', 3),
  ('2026-03-08', 4000, 'Transferencia', '2026-03-01', 4),
  ('2026-04-09', 5000, 'M-Pesa', '2026-04-01', 5),
  ('2026-05-09', 5000, 'e-Mola', '2026-05-01', 5),
  ('2026-04-05', 4000, 'e-Mola', '2026-04-01', 6),
  ('2026-05-06', 5000, 'Numerario', '2026-05-01', 7),
  ('2026-06-06', 5000, 'Transferencia', '2026-06-01', 7),
  ('2026-05-07', 6000, 'Transferencia', '2026-05-01', 8),
  ('2026-06-08', 3500, 'M-Pesa', '2026-06-01', 9),
  ('2026-07-08', 3500, 'e-Mola', '2026-07-01', 9),
  ('2026-06-09', 3000, 'e-Mola', '2026-06-01', 10),
  ('2026-07-05', 15000, 'Numerario', '2026-07-01', 11),
  ('2026-08-05', 15000, 'Transferencia', '2026-08-01', 11),
  ('2026-07-06', 13000, 'Transferencia', '2026-07-01', 12),
  ('2026-08-07', 25000, 'M-Pesa', '2026-08-01', 13),
  ('2026-09-07', 25000, 'e-Mola', '2026-09-01', 13),
  ('2026-08-08', 9000, 'e-Mola', '2026-08-01', 14),
  ('2026-09-09', 45000, 'Numerario', '2026-09-01', 15),
  ('2026-10-09', 45000, 'Transferencia', '2026-10-01', 15),
  ('2026-09-05', 35000, 'Transferencia', '2026-09-01', 16),
  ('2026-02-06', 30000, 'M-Pesa', '2026-02-01', 17),
  ('2026-03-06', 30000, 'e-Mola', '2026-03-01', 17),
  ('2026-03-07', 50000, 'e-Mola', '2026-03-01', 18),
  ('2026-04-08', 17000, 'Numerario', '2026-04-01', 19),
  ('2026-05-08', 17000, 'Transferencia', '2026-05-01', 19),
  ('2026-05-09', 14500, 'Transferencia', '2026-05-01', 20),
  ('2026-06-05', 11000, 'M-Pesa', '2026-06-01', 21),
  ('2026-07-05', 11000, 'e-Mola', '2026-07-01', 21),
  ('2026-07-06', 10000, 'e-Mola', '2026-07-01', 22),
  ('2025-12-05', 9500, 'Transferencia', '2025-12-01', 23),
  ('2025-06-06', 28000, 'Numerario', '2025-06-01', 24);

-- Verificação rápida
SELECT 'utilizador' AS tabela, COUNT(*) AS registos FROM utilizador
UNION ALL SELECT 'proprietario', COUNT(*) FROM proprietario
UNION ALL SELECT 'inquilino', COUNT(*) FROM inquilino
UNION ALL SELECT 'imovel', COUNT(*) FROM imovel
UNION ALL SELECT 'quarto', COUNT(*) FROM quarto
UNION ALL SELECT 'contrato', COUNT(*) FROM contrato
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento;
