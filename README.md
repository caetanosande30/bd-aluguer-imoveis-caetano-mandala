# Sistema de Aluguer de Casas e Quartos

**Autor:** Caetano Sande Domingos Mandala
**Curso:** Licenciatura em Informática, 2.º ano — Universidade Licungo
**Disciplina:** Tecnologias de Base de Dados
**Tema:** Aluguer de casas e quartos
**Vídeo de apresentação:** _(colocar aqui o link do YouTube)_

## Descrição do problema

O sistema destina-se à gestão do aluguer de casas e quartos feito directamente entre proprietários e inquilinos. Cada proprietário regista os seus imóveis (casas ou apartamentos) e, quando o imóvel é arrendado por partes, os respectivos quartos. O inquilino interessado consulta os imóveis e quartos disponíveis e, havendo acordo, é celebrado um contrato com data de início, duração e valor da renda mensal. Durante a vigência do contrato, o inquilino efectua pagamentos mensais, que ficam registados com data, valor e método de pagamento. O sistema permite ao proprietário acompanhar os contratos activos, os pagamentos recebidos e as rendas em atraso, e ao inquilino consultar o seu contrato e histórico de pagamentos. O acesso é feito por utilizadores com perfis distintos (proprietário e inquilino).

## Regras de negócio

1. Um proprietário pode ter vários imóveis; cada imóvel pertence a um só proprietário.
2. Um imóvel pode ser arrendado inteiro ou por quartos.
3. Um quarto pertence a um só imóvel e só existe dentro dele (entidade fraca).
4. Um imóvel ou quarto só pode ter um contrato activo de cada vez.
5. Um contrato é celebrado entre um inquilino e um imóvel ou um quarto.
6. Um inquilino pode ter vários contratos ao longo do tempo.
7. Cada contrato tem data de início, data de fim e valor da renda mensal.
8. Cada pagamento pertence a um único contrato e regista data, valor e método (M-Pesa, e-Mola, numerário, transferência).
9. Um contrato pode ter vários pagamentos (um por cada mês).
10. Cada proprietário e cada inquilino tem uma conta de utilizador com perfil próprio.
11. Um imóvel tem estado: disponível, arrendado ou em manutenção.

## Sistema web previsto

No projecto de Programação Web será desenvolvido um portal de aluguer de imóveis, onde:

- **Proprietários** registam e gerem os seus imóveis e quartos, os contratos e os pagamentos recebidos;
- **Inquilinos** pesquisam imóveis e quartos disponíveis, consultam o seu contrato e o histórico de pagamentos;
- Ambos acedem através de conta de utilizador, com operações de registar, listar, pesquisar, alterar e eliminar dados.

## Estrutura do repositório

```
bd-aluguer-imoveis-caetano-mandala/
  README.md
  diagrama_er.png
  modelo_relacional.md
  01_criacao_e_insercao.sql
  02_manipulacao.sql
```

## Como executar

1. Iniciar o Apache e o MySQL no XAMPP.
2. Abrir o phpMyAdmin (`http://localhost/phpmyadmin`) e importar `01_criacao_e_insercao.sql`.
3. Seleccionar a base de dados `aluguer_imoveis`, abrir o separador SQL e executar os comandos de `02_manipulacao.sql`, um de cada vez.
