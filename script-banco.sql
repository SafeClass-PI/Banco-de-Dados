DROP DATABASE IF EXISTS safeclass;
CREATE DATABASE safeclass;
USE safeclass;

CREATE TABLE Endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(45),
    numero VARCHAR(45),
    cidade VARCHAR(45),
    bairro VARCHAR(45),
    uf CHAR(2)
);

CREATE TABLE Escola (
	idEscola INT PRIMARY KEY AUTO_INCREMENT,
    idSlack VARCHAR(45),
    fkEndereco INT,
    nome VARCHAR(45),
    email VARCHAR(45),
	telefone CHAR(11),
    codigoInep VARCHAR(45),
    FOREIGN KEY (fkEndereco)
    REFERENCES Endereco(idEndereco)
);

CREATE TABLE CodigoAtivacao (
	idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkEscola INT,
    codigo VARCHAR(45),
    validade DATE,
    qtdUsos INT,
    FOREIGN KEY (fkEscola)
    REFERENCES Escola(idEscola)
);

CREATE TABLE Sala (
	idSala INT PRIMARY KEY AUTO_INCREMENT,
    fkEscola INT,
    nome VARCHAR(45),
    localizacao VARCHAR(45),
    FOREIGN KEY (fkEscola)
    REFERENCES Escola(idEscola)
);

CREATE TABLE Cargo (
	idCargo INT PRIMARY KEY AUTO_INCREMENT, 
	nome VARCHAR(45),
    permissao VARCHAR(100)
);

CREATE TABLE Usuario (
	idUsuario INT AUTO_INCREMENT,
    fkCargo INT,
    fkEscola INT,
    fkGestor INT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    senhaTemporaria DATETIME NULL,
    dtCadastro DATE,
    status VARCHAR(45),
    imagemPerfil VARCHAR(255),
    PRIMARY KEY (idUsuario),
    FOREIGN KEY (fkCargo)
    REFERENCES Cargo(idCargo),
    FOREIGN KEY (fkEscola)
    REFERENCES Escola(idEscola),
    FOREIGN KEY (fkGestor) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Maquina (
	idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    fkSala INT,
    ip VARCHAR(45),
    username VARCHAR(45),
    senha VARCHAR(45),
    sistemaOperacional VARCHAR(45),
    marca VARCHAR(45),
    macaddress VARCHAR(45),
    status VARCHAR(45),
    FOREIGN KEY (fkSala)
    REFERENCES Sala(idSala)
);

CREATE TABLE DesligamentoRemoto (
	idDesligamento INT,
    fkMaquina INT,
    fkUsuario INT,
    dtDesligamento DATETIME,
    PRIMARY KEY (idDesligamento, fkMaquina),
    FOREIGN KEY (fkMaquina)
    REFERENCES Maquina(idMaquina),
    FOREIGN KEY (fkUsuario)
    REFERENCES Usuario(idUsuario)
);

CREATE TABLE Componente (
	idComponente INT auto_increment,
    fkMaquina INT,
    nome VARCHAR(45),
    formatacao VARCHAR(45),
    capacidade VARCHAR(45),
    PRIMARY KEY (idComponente, fkMaquina),
    FOREIGN KEY (fkMaquina)
    REFERENCES Maquina(idMaquina)
);

CREATE TABLE Captura (
    idCaptura INT AUTO_INCREMENT,
	fkComponente INT,
    registro FLOAT,
    dtCaptura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idCaptura, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente)
);

CREATE TABLE Parametro (
	idParametro INT AUTO_INCREMENT,
    fkComponente INT, 
    nivel VARCHAR(45),
    minimo VARCHAR(45),
    maximo VARCHAR(45),
    PRIMARY KEY (idParametro, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente)
);

CREATE TABLE Alerta (
	idAlerta INT AUTO_INCREMENT,
    fkParametro INT,
    fkCaptura INT,
    mensagem VARCHAR(80),
    enviado TINYINT(1),
    PRIMARY KEY (idAlerta, fkParametro),
    FOREIGN KEY (fkParametro)
    REFERENCES Parametro(idParametro),
    FOREIGN KEY (fkCaptura)
    REFERENCES Captura(idCaptura)
);

-- -----------------------INSERTS TABELAS -----------------------------------------------------------------------
INSERT INTO Endereco (logradouro, numero, cidade, bairro, uf) values
("Avenida Paulista", 290, "São Paulo", "Bela vista", "SP");

INSERT INTO Escola (idEscola, idSlack, fkEndereco, nome, email, telefone, codigoInep) VALUES
(default, "C09TJE2LB4P", 1, 'Escola Joaquim 3°', 'joaquimterceiro@gmail.com', '11910877887', 'ebsdiw');

INSERT INTO CodigoAtivacao (fkEscola, codigo, validade, qtdUsos) VALUES 
(1, "00j12", "2025-09-11", 10);

INSERT INTO Sala (nome, fkEscola, localizacao) VALUES
("Sala 1", 1, "2° andar, lado esquerdo"),
("Sala 2", 1, "1° andar, lado direito"),
("Sala 3", 1, "2° andar, lado direito"),
("Sala 4", 1, "1° andar, lado esquerdo"),
("Sala 5", 1, "2° andar, lado direito"),
("Sala 6", 1, "1° andar, lado esquerdo");

INSERT INTO Cargo (nome, permissao) VALUES
("Gestor", "Visualizar métricas, visualizar/editar/remover/inserir usuários e máquinas"),
("Técnico de T.I", "Visualizar métricas, visualizar/editar/remover/inserir máquinas"),
("Professor", "Visualizar métricas");

INSERT INTO Usuario (fkCargo, fkEscola, nome, email, senha, dtCadastro, status) VALUES 
(1, 1, "Ryan Patric", "ryanpina@gmail.com", "urubu100", "2025-09-10", "ativo"),
(1, 1, "Felipe Ferraz", "felipegmail.com", "urubu100", "2025-09-10", "pendente");

INSERT INTO Maquina (fkSala, ip, username, senha, sistemaOperacional, marca, macaddress, status) VALUES
(1, '192.168.1.10', 'user01', 'pass01', 'Windows', 'Dell', 'A1:B2:C3:D4:E5:01', 'Estável'),
(1, '192.168.1.11', 'user02', 'pass02', 'Linux',   'HP',   'A1:B2:C3:D4:E5:02', 'Estável'),
(1, '192.168.1.12', 'user03', 'pass03', 'Windows', 'Lenovo','A1:B2:C3:D4:E5:03', 'Estável'),
(1, '192.168.1.13', 'user04', 'pass04', 'Linux',   'Acer',  'A1:B2:C3:D4:E5:04', 'Estável'),
(1, '192.168.1.14', 'user05', 'pass05', 'Windows', 'Asus',  'A1:B2:C3:D4:E5:05', 'Estável'),
(1, '192.168.1.15', 'user06', 'pass06', 'Linux',   'Dell',  'A1:B2:C3:D4:E5:06', 'Estável'),
(1, '192.168.1.16', 'user07', 'pass07', 'Windows', 'HP',    'A1:B2:C3:D4:E5:07', 'Estável'),
(1, '192.168.1.17', 'user08', 'pass08', 'Linux',   'Lenovo','A1:B2:C3:D4:E5:08', 'Estável'),
(2, '192.168.2.10', 'user09',  'pass09',  'Windows', 'Dell',   'A2:B3:C4:D5:E6:01', 'Estável'),
(2, '192.168.2.11', 'user10',  'pass10',  'Linux',   'HP',     'A2:B3:C4:D5:E6:02', 'Estável'),
(2, '192.168.2.12', 'user11',  'pass11',  'Windows', 'Lenovo', 'A2:B3:C4:D5:E6:03', 'Estável'),
(2, '192.168.2.13', 'user12',  'pass12',  'Linux',   'Acer',   'A2:B3:C4:D5:E6:04', 'Estável'),
(2, '192.168.2.14', 'user13',  'pass13',  'Windows', 'Asus',   'A2:B3:C4:D5:E6:05', 'Estável'),
(2, '192.168.2.15', 'user14',  'pass14',  'Linux',   'Dell',   'A2:B3:C4:D5:E6:06', 'Estável'),
(2, '192.168.2.16', 'user15',  'pass15',  'Windows', 'HP',     'A2:B3:C4:D5:E6:07', 'Estável'),
(2, '192.168.2.17', 'user16',  'pass16',  'Linux',   'Lenovo', 'A2:B3:C4:D5:E6:08', 'Estável'),
(3, '192.168.3.10', 'user17', 'pass17', 'Windows', 'Acer',   'A3:B4:C5:D6:E7:01', 'Estável'),
(3, '192.168.3.11', 'user18', 'pass18', 'Linux',   'Asus',   'A3:B4:C5:D6:E7:02', 'Estável'),
(3, '192.168.3.12', 'user19', 'pass19', 'Windows', 'Dell',   'A3:B4:C5:D6:E7:03', 'Estável'),
(3, '192.168.3.13', 'user20', 'pass20', 'Linux',   'HP',     'A3:B4:C5:D6:E7:04', 'Estável'),
(3, '192.168.3.14', 'user21', 'pass21', 'Windows', 'Lenovo', 'A3:B4:C5:D6:E7:05', 'Estável'),
(3, '192.168.3.15', 'user22', 'pass22', 'Linux',   'Acer',   'A3:B4:C5:D6:E7:06', 'Estável'),
(3, '192.168.3.16', 'user23', 'pass23', 'Windows', 'Asus',   'A3:B4:C5:D6:E7:07', 'Estável'),
(3, '192.168.3.17', 'user24', 'pass24', 'Linux',   'Dell',   'A3:B4:C5:D6:E7:08', 'Estável'),
(4, '192.168.4.10', 'user25', 'pass25', 'Windows', 'HP',     'A4:B5:C6:D7:E8:01', 'Estável'),
(4, '192.168.4.11', 'user26', 'pass26', 'Linux',   'Lenovo', 'A4:B5:C6:D7:E8:02', 'Estável'),
(4, '192.168.4.12', 'user27', 'pass27', 'Windows', 'Acer',   'A4:B5:C6:D7:E8:03', 'Estável'),
(4, '192.168.4.13', 'user28', 'pass28', 'Linux',   'Asus',   'A4:B5:C6:D7:E8:04', 'Estável'),
(4, '192.168.4.14', 'user29', 'pass29', 'Windows', 'Dell',   'A4:B5:C6:D7:E8:05', 'Estável'),
(4, '192.168.4.15', 'user30', 'pass30', 'Linux',   'HP',     'A4:B5:C6:D7:E8:06', 'Estável'),
(4, '192.168.4.16', 'user31', 'pass31', 'Windows', 'Lenovo', 'A4:B5:C6:D7:E8:07', 'Estável'),
(4, '192.168.4.17', 'user32', 'pass32', 'Linux',   'Acer',   'A4:B5:C6:D7:E8:08', 'Estável'),
(5, '192.168.5.10', 'user33', 'pass33', 'Windows', 'Dell',   'A5:B6:C7:D8:E9:01', 'Estável'),
(5, '192.168.5.11', 'user34', 'pass34', 'Linux',   'HP',     'A5:B6:C7:D8:E9:02', 'Estável'),
(5, '192.168.5.12', 'user35', 'pass35', 'Windows', 'Lenovo', 'A5:B6:C7:D8:E9:03', 'Estável'),
(5, '192.168.5.13', 'user36', 'pass36', 'Linux',   'Acer',   'A5:B6:C7:D8:E9:04', 'Estável'),
(5, '192.168.5.14', 'user37', 'pass37', 'Windows', 'Asus',   'A5:B6:C7:D8:E9:05', 'Estável'),
(5, '192.168.5.15', 'user38', 'pass38', 'Linux',   'Dell',   'A5:B6:C7:D8:E9:06', 'Estável'),
(5, '192.168.5.16', 'user39', 'pass39', 'Windows', 'HP',     'A5:B6:C7:D8:E9:07', 'Estável'),
(5, '192.168.5.17', 'user40', 'pass40', 'Linux',   'Lenovo', 'A5:B6:C7:D8:E9:08', 'Estável'),
(6, '192.168.6.10', 'user41', 'pass41', 'Windows', 'Acer',   'A6:B7:C8:D9:E0:01', 'Estável'),
(6, '192.168.6.11', 'user42', 'pass42', 'Linux',   'Asus',   'A6:B7:C8:D9:E0:02', 'Estável'),
(6, '192.168.6.12', 'user43', 'pass43', 'Windows', 'Dell',   'A6:B7:C8:D9:E0:03', 'Estável'),
(6, '192.168.6.13', 'user44', 'pass44', 'Linux',   'HP',     'A6:B7:C8:D9:E0:04', 'Estável'),
(6, '192.168.6.14', 'user45', 'pass45', 'Windows', 'Lenovo', 'A6:B7:C8:D9:E0:05', 'Estável'),
(6, '192.168.6.15', 'user46', 'pass46', 'Linux',   'Acer',   'A6:B7:C8:D9:E0:06', 'Estável'),
(6, '192.168.6.16', 'user47', 'pass47', 'Windows', 'Asus',   'A6:B7:C8:D9:E0:07', 'Estável'),
(6, '192.168.6.17', 'user48', 'pass48', 'Linux',   'Dell',   'A6:B7:C8:D9:E0:08', 'Estável');

INSERT INTO Componente (idComponente, fkMaquina, nome, formatacao, capacidade) VALUES 
(default, 1, 'Memória RAM', 'gb', '16GB DDR4'), 
(default, 1, 'Disco Rígido', '%', '1TB'),
(default, 1, 'CPU', '%', 'Intel i7'),
(default, 1, 'Upload', 'Mbps', '1000 Mbps'),
(default, 1, 'Download', 'Mbps', '1000 Mbps'),
(default, 2, 'Memória RAM', 'gb', '16GB DDR4'), 
(default, 2, 'Disco Rígido', '%', '1TB'),
(default, 2, 'CPU', '%', 'Intel i7'),
(default, 2, 'Upload', 'Mbps', '1000 Mbps'),
(default, 2, 'Download', 'Mbps', '1000 Mbps'),
(default, 3, 'Memória RAM', 'gb', '16GB DDR4'), 
(default, 3, 'Disco Rígido', '%', '1TB'),
(default, 3, 'CPU', '%', 'Intel i7'),
(default, 3, 'Upload', 'Mbps', '1000 Mbps'),
(default, 3, 'Download', 'Mbps', '1000 Mbps');

INSERT INTO Parametro VALUES
(default, 1, "Crítico", 85.5, 100),
(default, 1, "Atenção", 73.9, 85.49),
(default, 2, "Crítico", 92.4, 100),
(default, 2, "Atenção", 87.9, 92.39),
(default, 3, "Crítico", 60.3, 100),
(default, 3, "Atenção", 52.7, 60.29),
(default, 4, "Crítico", 10.0, 0.0),
(default, 4, "Atenção", 20.0, 10.01),
(default, 5, "Crítico", 30.0, 0.0),
(default, 5, "Atenção", 65.0, 30.01);

-- --------------- SELECT´S PÁGINA: PÁGINA GERAL ----------------------------------------------------------------
-- Contar quantas máquinas estão ligadas  
SELECT 
    COUNT(DISTINCT CASE 
        WHEN ultCaptura.ultima >= NOW() - INTERVAL 2 SECOND THEN M.idMaquina
    END) AS maquinasLigadas,
    COUNT(DISTINCT M.idMaquina) AS totalMaquinas
FROM Maquina M
LEFT JOIN Componente C
    ON M.idMaquina = C.fkMaquina
LEFT JOIN (
    SELECT fkComponente, MAX(dtCaptura) AS ultima
    FROM Captura
    GROUP BY fkComponente
) AS ultCaptura
    ON C.idComponente = ultCaptura.fkComponente;

-- CRIACAO DE USUARIO
CREATE USER 'bia'@'%' identified WITH mysql_native_password BY 'urubu100';
GRANT ALL PRIVILEGES ON safeclass.* TO 'bia'@'%'; 
FLUSH PRIVILEGES;

-- Taxa de Uptime do sistema diário
SELECT COUNT(c.idCaptura) AS totalCapturas, COUNT(a.idAlerta) AS totalAlertas,
    ROUND(
        (1-(COUNT(a.idAlerta) / COUNT(c.idCaptura))) * 100,2) AS uptime_percentual
FROM captura AS c
LEFT JOIN alerta AS a
ON a.fkCaptura = c.idCaptura
WHERE DATE(c.dtCaptura) = CURDATE();

-- Select máquina crítica
SELECT CONCAT("Máquina", " ", m.idMaquina) AS maquina, COUNT(a.idAlerta) AS TotalAlertas, CONCAT("Sala", " ", m.fkSala) AS localizacao, CONCAT("Mac Address:", " ", m.macaddress) AS macaddress
FROM Maquina AS m
JOIN Componente AS c ON c.fkMaquina = m.idMaquina
JOIN Captura AS ca ON ca.fkComponente = c.idComponente 
JOIN Alerta AS a ON a.fkCaptura = ca.idCaptura
WHERE DATE(ca.dtCaptura) = CURDATE()
GROUP BY m.idMaquina
ORDER BY TotalAlertas DESC
LIMIT 1;
	
-- Contar quantidade de alerta do dia
SELECT COUNT(a.idAlerta) AS qtdAlertas
FROM alerta AS a
JOIN captura AS c ON c.idCaptura = a.fkCaptura
WHERE DATE(c.dtCaptura) = CURDATE();

-- Select salas e máquinas 
WITH maquina_status AS (
  SELECT 
    m.fkSala,
    CASE 
      WHEN m.status = 'Crítico' THEN 3
      WHEN m.status = 'Atenção' THEN 2
      WHEN m.status = 'Estável' THEN 1
    END AS valorStatus
  FROM maquina AS m
),
ordered AS (
  SELECT 
    fkSala,
    valorStatus,
    ROW_NUMBER() OVER (PARTITION BY fkSala ORDER BY valorStatus) AS rn,
    COUNT(*) OVER (PARTITION BY fkSala) AS total
  FROM maquina_status
)
SELECT 
  s.idSala,
  s.nome,
  o.total AS qtdMaquinas,
  CASE o.valorStatus
    WHEN 3 THEN 'Crítico'
    WHEN 2 THEN 'Atenção'
    WHEN 1 THEN 'Estável'
  END AS mediana
FROM sala AS s
JOIN ordered AS o 
  ON o.fkSala = s.idSala
WHERE o.rn IN (
  FLOOR((o.total + 1) / 2),
  CEIL((o.total + 1) / 2)
)
GROUP BY s.idSala, s.nome, o.valorStatus, o.total
ORDER BY o.valorStatus DESC;
    
-- Select máquinas da Sala
SELECT CONCAT('Máquina ', m.idMaquina) AS identificacao, m.status, 
	CASE 
    WHEN m.status = 'Estável' THEN 'Funcionamento regular'
    ELSE ult.mensagem 
	END AS descricao
FROM maquina AS m
LEFT JOIN (
    SELECT 
        co2.fkMaquina,
        a2.mensagem
    FROM alerta a2
    JOIN captura c2 ON c2.idCaptura = a2.fkCaptura
    JOIN componente co2 ON co2.idComponente = c2.fkComponente
    JOIN (
        SELECT co3.fkMaquina, MAX(c3.dtCaptura) AS ultData
        FROM alerta a3
        JOIN captura c3 ON c3.idCaptura = a3.fkCaptura
        JOIN componente co3 ON co3.idComponente = c3.fkComponente
        GROUP BY co3.fkMaquina
    ) AS sub ON sub.fkMaquina = co2.fkMaquina AND sub.ultData = c2.dtCaptura
) AS ult ON ult.fkMaquina = m.idMaquina
WHERE m.fkSala = 1
ORDER BY 
    CASE 
        WHEN m.status = 'Crítico' THEN 1
        WHEN m.status = 'Atenção' THEN 2
        WHEN m.status = 'Estável' THEN 3
        ELSE 4
    END;
    
-- Select últimos alertas
		SELECT CONCAT("Máquina"," ", m.idMaquina) AS identificacao, a.mensagem AS mensagem, p.nivel AS parametro, CONCAT("Sala"," ", m.fkSala) AS localizacao,  c.dtCaptura AS hora
        FROM maquina AS m
        JOIN componente AS co
        ON m.idMaquina = co.fkMaquina
        JOIN captura AS c
        ON c.fkComponente = co.idComponente
        JOIN alerta AS a
        ON a.fkCaptura = c.idCaptura
        JOIN parametro AS p
        ON p.idParametro = a.fkParametro
        ORDER BY c.dtCaptura DESC;

-- --------------- SELECT´S PÁGINA: ANÁLISE ESPECÍFICA ----------------------------------------------------------------
-- Select estado da máquina
SELECT
    CASE
        WHEN MAX(
            CASE
                WHEN ca.registro BETWEEN pcrit.minimo AND pcrit.maximo THEN 3
                WHEN ca.registro BETWEEN pate.minimo AND pate.maximo THEN 2
                ELSE 1
            END
        ) = 3 THEN 'Crítico'
        WHEN MAX(
            CASE
                WHEN ca.registro BETWEEN pate.minimo AND pate.maximo THEN 2
                ELSE 1
            END
        ) = 2 THEN 'Atenção'
        ELSE 'Estável'
    END AS estado_maquina
FROM Componente c
JOIN Captura ca 
ON ca.idCaptura = (
        SELECT MAX(ca2.idCaptura)
        FROM Captura ca2
        WHERE ca2.fkComponente = c.idComponente
    )
LEFT JOIN Parametro pcrit ON pcrit.fkComponente = c.idComponente AND pcrit.nivel = 'Crítico'
LEFT JOIN Parametro pate ON pate.fkComponente = c.idComponente AND pate.nivel = 'Atenção'
WHERE c.fkMaquina = 1;

-- Select taxa de uptime da máquina
SELECT COUNT(c.idCaptura) AS totalCapturas, COUNT(a.idAlerta) AS totalAlertas,
    ROUND(
        (1-(COUNT(a.idAlerta) / COUNT(c.idCaptura))) * 100,2) AS uptime
FROM captura AS c
LEFT JOIN alerta AS a
ON a.fkCaptura = c.idCaptura
JOIN componente AS co
ON co.idComponente = c.fkComponente
JOIN maquina AS m
ON m.idMaquina = co.fkMaquina
WHERE m.idMaquina = 1 AND DATE(c.dtCaptura) = CURDATE();

-- Select taxa mais crítica do dia
SELECT co.nome AS componente, MAX(ca.registro) AS registro, co.formatacao as formatacao, DATE_FORMAT(MAX(ca.dtCaptura), '%H:%i') AS hora
FROM Captura AS ca
JOIN Alerta AS a ON a.fkCaptura = ca.idCaptura
JOIN Componente AS co ON co.idComponente = ca.fkComponente
JOIN Maquina AS m ON m.idMaquina = co.fkMaquina
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE()
GROUP BY co.nome, co.formatacao
LIMIT 1;

-- Select quantidade de alertas da máquina
SELECT COUNT(a.idAlerta) AS qtdAlerta
FROM Alerta AS a
JOIN Captura AS ca
ON ca.idCaptura = a.fkCaptura
JOIN Componente AS c
ON c.idComponente = ca.fkComponente
JOIN Maquina AS m
ON m.idMaquina = c.fkMaquina
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE();

-- Select últimos alertas da máquina
SELECT m.idMaquina AS Identificacao, p.nivel, a.mensagem, TIME(ca.dtCaptura) FROM Alerta AS a
JOIN Captura AS ca
ON ca.idCaptura = a.fkCaptura
JOIN Componente AS c
ON c.idComponente = ca.fkComponente
JOIN Maquina AS m
ON m.idMaquina = c.fkMaquina
JOIN Parametro AS p
ON p.idParametro = a.fkParametro
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE(); 

-- Capturas Memória Ram
SELECT co.nome AS componente, ROUND(ca.registro,2) AS registro, TIME(dtcaptura) AS horacaptura 
FROM captura AS ca
JOIN componente AS co
ON co.idcomponente = ca.fkcomponente
WHERE co.idcomponente = 1
ORDER BY dtcaptura DESC
LIMIT 8;

-- Capturas Disco
SELECT co.nome AS componente, ROUND(ca.registro,2) AS registro, TIME(dtcaptura) AS horacaptura 
FROM captura AS ca
JOIN componente AS co
ON co.idcomponente = ca.fkcomponente
WHERE co.idcomponente = 2
ORDER BY dtcaptura DESC
LIMIT 8;

-- Capturas CPU (Processador)
SELECT co.nome AS componente, ROUND(ca.registro,2) AS registro, TIME(dtcaptura) AS horacaptura 
FROM captura AS ca
JOIN componente AS co
ON co.idcomponente = ca.fkcomponente
WHERE co.idcomponente = 3
ORDER BY dtcaptura DESC
LIMIT 8;

-- Capturas Upload
SELECT co.nome AS componente, ROUND(ca.registro,2) AS registro, TIME(dtcaptura) AS horacaptura 
FROM captura AS ca
JOIN componente AS co
ON co.idcomponente = ca.fkcomponente
WHERE co.idcomponente = 4
ORDER BY dtcaptura desc 
LIMIT 6;

-- Capturas Download
SELECT co.nome AS componente, ROUND(ca.registro,2) AS registro, TIME(dtcaptura) AS horacaptura 
FROM captura AS ca
JOIN componente AS co
ON co.idcomponente = ca.fkcomponente
WHERE co.idcomponente = 5
ORDER BY dtcaptura DESC 
LIMIT 6;

-- Gráfico disponibilidade da máquina
SELECT COUNT(a.idAlerta) AS totalAlertas, (COUNT(c.idCaptura) -  COUNT(a.idAlerta)) AS capturasEstaveis
FROM captura AS c
LEFT JOIN alerta AS a
ON a.fkCaptura = c.idCaptura
JOIN componente AS co
ON co.idComponente = c.fkComponente
JOIN maquina AS m
ON m.idMaquina = co.fkMaquina
WHERE m.idMaquina = 1 AND DATE(c.dtCaptura) = CURDATE();

-- Gráfico falhas por componente
SELECT c.nome AS componente, COUNT(a.idAlerta) AS quantidade 
FROM Alerta AS a
RIGHT JOIN Captura AS ca
ON a.fkCaptura = ca.idCaptura
JOIN Componente AS c
ON c.idComponente = ca.fkComponente
JOIN maquina AS m
ON m.idMaquina = c.fkMaquina
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE()
GROUP BY c.nome;

-- --------------- SELECT´S PÁGINA: PÁGINAS USUÁRIOS ----------------------------------------------------------------
-- Quantidade de solicitações de entrada
SELECT count(status) FROM Usuario
WHERE status LIKE 'pendente';
