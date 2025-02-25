-- Inserir Clientes
INSERT INTO Cliente (tipo_cliente, nome, email, cpf) VALUES
('PF', 'Ana Silva', 'ana.silva@email.com', '123.456.789-01'),
('PJ', 'Empresa XYZ', 'contato@empresaXYZ.com', NULL, NULL, '00.111.222/0001-30', 'XYZ Soluções LTDA');

-- Inserir Formas de Pagamento para Clientes
INSERT INTO FormaPagamentoCliente (cliente_id, tipo_pagamento, detalhes_pagamento) VALUES
(1, 'Cartão de Crédito', '{"bandeira": "Visa", "numero": "**** **** **** 1234"}'),
(1, 'Pix', '{"chave": "anasilva@email.com"}'),
(2, 'Boleto', '{}');

-- Inserir Fornecedores
INSERT INTO Fornecedor (nome_fornecedor, cnpj) VALUES
('Fornecedor A', '11.222.333/0001-40'),
('Fornecedor B', '22.333.444/0001-50');

-- Inserir Produtos
INSERT INTO Produto (nome_produto, descricao, preco, fornecedor_id, estoque_id) VALUES
('Produto 1', 'Descrição do Produto 1', 19.99, 1, 1),
('Produto 2', 'Descrição do Produto 2', 29.99, 2, 2);

-- Inserir Estoque (se tabela Estoque for separada)
INSERT INTO Estoque (produto_id, quantidade_estoque) VALUES
(1, 100),
(2, 50);

-- Inserir Pedidos
INSERT INTO Pedido (cliente_id, valor_total, endereco_entrega) VALUES
(1, 49.98, 'Rua Exemplo, 123'),
(2, 29.99, 'Av. Principal, 456');

-- Inserir Itens de Pedido
INSERT INTO ItemPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 19.99),
(2, 2, 1, 29.99);

-- Inserir Entregas
INSERT INTO Entrega (pedido_id, status_entrega, codigo_rastreio) VALUES
(1, 'Processando', 'BR123456789X'),
(2, 'Enviado', 'BR987654321Y');
-- Atualizar Pedido para referenciar Entrega (após inserir entrega)
UPDATE Pedido SET entrega_id = 1 WHERE pedido_id = 1;
UPDATE Pedido SET entrega_id = 2 WHERE pedido_id = 2;