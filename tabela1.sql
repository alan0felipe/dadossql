-- Tabela Cliente
CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(255),
    cpf VARCHAR(14) UNIQUE, -- NOT NULL para PF, mas vamos permitir NULL e validar via aplicação
    data_nascimento DATE, -- Apenas para PF, pode ser NULL
    cnpj VARCHAR(18) UNIQUE, -- NOT NULL para PJ, mas vamos permitir NULL e validar via aplicação
    razao_social VARCHAR(255) -- Apenas para PJ, pode ser NULL
);

-- Tabela FormaPagamentoCliente (para múltiplas formas de pagamento por cliente)
CREATE TABLE FormaPagamentoCliente (
    forma_pagamento_cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    tipo_pagamento VARCHAR(50) NOT NULL, -- Ex: 'Cartão de Crédito', 'Boleto', 'Pix'
    detalhes_pagamento TEXT, -- JSON ou VARCHAR para detalhes específicos
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

-- Tabela Produto
CREATE TABLE Produto (
    produto_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    fornecedor_id INT, -- FK para Fornecedor (pode ser NULL inicialmente, se fornecedor não for obrigatório no cadastro do produto)
    estoque_id INT -- FK para Estoque (relação 1-1 com estoque ou pode ser controlado diretamente na tabela Produto)
    -- Podemos optar por controlar estoque em outra tabela para mais detalhes (movimentação, etc)
);

-- Tabela Estoque (opcional - se precisar de controle de estoque mais detalhado)
CREATE TABLE Estoque (
    estoque_id INT PRIMARY KEY AUTO_INCREMENT,
    produto_id INT UNIQUE NOT NULL, -- Relação 1-1 com Produto
    quantidade_estoque INT NOT NULL DEFAULT 0,
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);
-- Altera a tabela Produto para adicionar a FK para Estoque (se a tabela Estoque for criada)
ALTER TABLE Produto ADD CONSTRAINT fk_produto_estoque FOREIGN KEY (estoque_id) REFERENCES Estoque(estoque_id);
-- Altera a tabela Produto para adicionar a FK para Fornecedor
ALTER TABLE Produto ADD CONSTRAINT fk_produto_fornecedor FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(fornecedor_id);


-- Tabela Pedido
CREATE TABLE Pedido (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    endereco_entrega VARCHAR(255), -- Pode ser normalizado em tabela Endereco se precisar de mais detalhes
    entrega_id INT UNIQUE, -- FK para Entrega (relação 1-1 com entrega)
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
    -- FK para Entrega será adicionada após a criação da tabela Entrega
);

-- Tabela ItemPedido (tabela de junção para relação N-N entre Pedido e Produto)
CREATE TABLE ItemPedido (
    item_pedido_id INT PRIMARY KEY AUTO_INCREMENT, -- ou PK composta (pedido_id, produto_id)
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- Tabela Entrega
CREATE TABLE Entrega (
    entrega_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE NOT NULL, -- Relação 1-1 com Pedido
    status_entrega VARCHAR(50) NOT NULL,
    codigo_rastreio VARCHAR(100),
    data_envio DATETIME,
    data_prevista_entrega DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id)
);
-- Altera a tabela Pedido para adicionar a FK para Entrega
ALTER TABLE Pedido ADD CONSTRAINT fk_pedido_entrega FOREIGN KEY (entrega_id) REFERENCES Entrega(entrega_id);


-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    fornecedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_fornecedor VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    endereco VARCHAR(255),
    vendedor_id INT -- FK para Vendedor (se vendedores forem relevantes e relacionados a fornecedores)
    -- Pode ter mais detalhes de contato, etc.
);
-- Se houver tabela Vendedor, adicione a FK aqui
-- ALTER TABLE Fornecedor ADD CONSTRAINT fk_fornecedor_vendedor FOREIGN KEY (vendedor_id) REFERENCES Vendedor(vendedor_id);


-- Para cenário de "Vendedor que também é Fornecedor" (se necessário e mais complexo):
-- Pode criar uma tabela Vendedor separada e fazer relação N-N entre Vendedor e Fornecedor
-- ou usar a FK 'vendedor_id' na tabela Fornecedor para indicar um vendedor responsável pelo fornecedor.