# Modelo Relacional — Sistema de Aluguer de Casas e Quartos

**Legenda:** PK = chave primária · FK = chave estrangeira · UNIQUE = valor único

## Tabelas

```
UTILIZADOR (id_utilizador PK, email UNIQUE, senha, perfil, data_criacao)

PROPRIETARIO (id_proprietario PK, nome, bi UNIQUE, telefone,
              id_utilizador FK -> UTILIZADOR, UNIQUE)

INQUILINO (id_inquilino PK, nome, bi UNIQUE, telefone, profissao,
           id_utilizador FK -> UTILIZADOR, UNIQUE)

IMOVEL (id_imovel PK, tipo, endereco, bairro, cidade, renda_base, estado,
        id_proprietario FK -> PROPRIETARIO)

QUARTO (id_imovel PK/FK -> IMOVEL, numero_quarto PK, descricao, renda, estado)
        -- entidade fraca: chave primária composta (id_imovel, numero_quarto)

CONTRATO (id_contrato PK, data_inicio, data_fim, renda_mensal, estado,
          id_inquilino FK -> INQUILINO,
          id_imovel FK -> IMOVEL,
          numero_quarto (NULL),
          FK (id_imovel, numero_quarto) -> QUARTO)
        -- numero_quarto é NULL quando o contrato é da casa inteira

PAGAMENTO (id_pagamento PK, data_pagamento, valor, metodo, mes_referente,
           id_contrato FK -> CONTRATO)
```

## Chaves estrangeiras

| Tabela filha | Chave estrangeira | Tabela pai |
|---|---|---|
| PROPRIETARIO | id_utilizador | UTILIZADOR |
| INQUILINO | id_utilizador | UTILIZADOR |
| IMOVEL | id_proprietario | PROPRIETARIO |
| QUARTO | id_imovel | IMOVEL |
| CONTRATO | id_inquilino | INQUILINO |
| CONTRATO | id_imovel | IMOVEL |
| CONTRATO | (id_imovel, numero_quarto) | QUARTO |
| PAGAMENTO | id_contrato | CONTRATO |

## Ordem de criação das tabelas

Utilizador → Proprietário e Inquilino → Imóvel → Quarto → Contrato → Pagamento
