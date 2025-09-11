use safeClass;

-- Todos os Inserts foram mockados por IA dados fictíticios

-- Escola 1: ID 1000
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('Escola Estadual Prof. João Batista', '35001234', 'Estadual', '11222333000144');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1000, 'SP', 'São Paulo', 'Cambuci', 'Av. Lacerda Franco', '105', '01536000');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1000, 'A1B2-C3D4-E5F6', '2025-12-31 23:59:59');

-- Escola 2: ID 1001
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('Colégio Municipal Monteiro Lobato', '35005678', 'Municipal', '22333444000155');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1001, 'SP', 'Diadema', 'Centro', 'R. Castro Alves', '56', '09911180');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1001, 'G7H8-I9J0-K1L2', '2025-12-31 23:59:59');

-- Escola 3: ID 1002
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('Instituto Federal de São Paulo - Campus Diadema', '35009012', 'Federal', '33444555000166');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1002, 'SP', 'Diadema', 'Conceição', 'Rua Dr. Carlos de Campos', '120', '09911040');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1002, 'M3N4-O5P6-Q7R8', '2025-12-31 23:59:59');

-- Escola 4: ID 1003
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('EMEB Vinicius de Moraes', '29001122', 'Municipal', '44555666000177');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1003, 'BA', 'Salvador', 'Sé', 'Praça da Sé', '1', '40020010');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1003, 'S9T0-U1V2-W3X4', '2025-12-31 23:59:59');

-- Escola 5: ID 1004
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('ETEC Juscelino Kubitschek', '35003344', 'Estadual', '55666777000188');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1004, 'SP', 'Praia Grande', 'Vila Caiçara', 'Av. Presidente Kennedy', '7000', '11703200');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1004, 'Y5Z6-A7B8-C9D0', '2025-12-31 23:59:59');

-- Escola 6: ID 1005
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('Colégio Pedro II - Campus Realengo', '33008899', 'Federal', '66777888000199');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1005, 'RJ', 'Rio de Janeiro', 'Realengo', 'Rua Limites', '1349', '21715231');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1005, 'E1F2-G3H4-I5J6', '2025-12-31 23:59:59');

-- Escola 7: ID 1006
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('UME Profª Maria da Conceição', '35007788', 'Municipal', '77888999000100');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1006, 'SP', 'Santos', 'Ponta da Praia', 'Rua dos Pescadores', '75', '11030010');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1006, 'K7L8-M9N0-O1P2', '2025-12-31 23:59:59');

-- Escola 8: ID 1007
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('EE Deputado Freitas Nobre', '35002468', 'Estadual', '88999000000111');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, complemento, cep) VALUES (1007, 'SP', 'São Paulo', 'Vila Prudente', 'Rua Cananéia', '299', 'Bloco B', '03131030');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1007, 'Q3R4-S5T6-U7V8', '2025-12-31 23:59:59');

-- Escola 9: ID 1008
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('Colégio de Aplicação da UFRJ', '33001234', 'Federal', '99000111000122');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1008, 'RJ', 'Rio de Janeiro', 'Lagoa', 'Rua Capistrano de Abreu', '22', '22471010');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1008, 'W9X0-Y1Z2-A3B4', '2025-12-31 23:59:59');

-- Escola 10: ID 1009
INSERT INTO escola (nomeDaEscola, codigoInep, esferaAdministrativa, cnpj) VALUES ('EMEF General Osório', '43005566', 'Municipal', '10111222000133');
INSERT INTO endereco (fkEscola, uf, cidade, bairro, logradouro, numero, cep) VALUES (1009, 'RS', 'Porto Alegre', 'Partenon', 'Av. Ipiranga', '6681', '90619900');
INSERT INTO codigoConfiguracao (fkEscola, chaveConfiguracao, dataExpiracao) VALUES (1009, 'C5D6-E7F8-G9H0', '2025-12-31 23:59:59');


INSERT INTO safeclass.componentesAMonitorar (nomeMonitoramento,unidadeMedida) VALUES
('Porcentagem de uso da CPU','%'),
('Frequência de uso da CPU','GHz'),
('Uso da Memória RAM','%'),
('Memória RAM Total','GB'),
('Uso do disco','GB'),
('Espaço restante do disco','GB'),
('Espaço do Disco','GB');

