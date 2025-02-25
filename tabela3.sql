-- Recuperações Simples com SELECT
-- Listar todos os nomes e emails de clientes PF
SELECT nome, email FROM Cliente WHERE tipo_cliente = 'PF';

-- Listar todos os produtos e seus preços
SELECT nome_produto, preco FROM Produto;


-- Filtros com WHERE
-- Listar produtos com preço acima de 25.00
SELECT nome_produto, preco FROM Produto WHERE preco > 25.00;

-- Listar pedidos feitos pelo cliente com cliente_id = 1
SELECT pedido_id, data_pedido, valor_total FROM Pedido WHERE cliente_id = 1;


-- Atributos Derivados (Expressões)
-- Listar nome do produto e preço com desconto de 10% (preço_com_desconto)
SELECT nome_produto, preco, preco * 0.90 AS preco_com_desconto FROM Produto;

-- Calcular o valor total de cada item do pedido (quantidade * preco_unitario)
SELECT item_pedido_id, quantidade, preco_unitario, quantidade * preco_unitario AS valor_item FROM ItemPedido;


-- Ordenação com ORDER BY
-- Listar produtos em ordem decrescente de preço
SELECT nome_produto, preco FROM Produto ORDER BY preco DESC;

-- Listar clientes PJ em ordem alfabética por razão social
SELECT nome, razao_social FROM Cliente WHERE tipo_cliente = 'PJ' ORDER BY razao_social ASC;


-- Filtros em Grupos com HAVING (Necessário GROUP BY para usar HAVING)
-- Contar quantos pedidos cada cliente fez (e mostrar apenas clientes com mais de 1 pedido - Exemplo Ilustrativo, com dados atuais nenhum terá mais de 1)
SELECT c.nome, COUNT(p.pedido_id) AS quantidade_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
HAVING COUNT(p.pedido_id) > 0; -- Alterar para > 0 se inserir mais dados para um cliente ter mais de um pedido

-- Calcular o valor médio dos pedidos por cliente (e mostrar apenas clientes com média acima de 30.00 - Exemplo Ilustrativo)
SELECT c.nome, AVG(p.valor_total) AS media_valor_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
HAVING AVG(p.valor_total) > 30.00; -- Ajustar o valor para testar com seus dados


-- Junções (JOIN)
-- Listar nome do cliente e número do pedido para todos os pedidos
SELECT c.nome AS nome_cliente, p.pedido_id
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id;

-- Listar nome do produto e nome do fornecedor para todos os produtos
SELECT prod.nome_produto, forn.nome_fornecedor
FROM Produto prod
JOIN Fornecedor forn ON prod.fornecedor_id = forn.fornecedor_id;

-- Consulta Mais Complexa: Listar nome do cliente, número do pedido, data do pedido, status da entrega e código de rastreio para todos os pedidos, ordenado por data do pedido
SELECT
    c.nome AS nome_cliente,
    p.pedido_id,
    p.data_pedido,
    e.status_entrega,
    e.codigo_rastreio
FROM Cliente c
JOIN Pedido p ON c.cliente_id = p.cliente_id
JOIN Entrega e ON p.entrega_id = e.entrega_id
ORDER BY p.data_pedido DESC;

-- Consulta para responder uma das perguntas sugeridas: "Quantos pedidos foram feitos por cada cliente?"
SELECT c.nome AS nome_cliente, COUNT(p.pedido_id) AS quantidade_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.nome
ORDER BY quantidade_pedidos DESC;

-- Consulta para responder: "Relação de nomes dos fornecedores e nomes dos produtos"
SELECT forn.nome_fornecedor, prod.nome_produto
FROM Fornecedor forn
JOIN Produto prod ON forn.fornecedor_id = prod.fornecedor_id
ORDER BY forn.nome_fornecedor, prod.nome_produto;


--  **Crie MAIS queries!**  Explore outras combinações de cláusulas, responda às outras perguntas sugeridas ("Algum vendedor também é fornecedor?", "Relação de produtos fornecedores e estoques;"),  e formule novas perguntas que você possa responder com seus dados.