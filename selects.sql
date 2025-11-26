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

SELECT COUNT(CASE
WHEN m.estado LIKE 'Ligada' THEN 1 END) AS MaquinasLigadas, COUNT(m.idMaquina) AS totalMaquinas
FROM Maquina AS m;

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
),
mediana AS (
    SELECT 
        fkSala,
        AVG(valorStatus) AS medianaValor, 
        MAX(total) AS total
    FROM ordered
    WHERE rn IN (
        FLOOR((total + 1) / 2),
        CEIL((total + 1) / 2)
    )
    GROUP BY fkSala
)
SELECT 
    s.idSala,
    s.nome,
    m.total AS qtdMaquinas,
    CASE
        WHEN m.medianaValor >= 2.5 THEN 'Crítico'
        WHEN m.medianaValor >= 1.5 THEN 'Atenção'
        ELSE 'Estável'
    END AS mediana
FROM sala AS s
JOIN mediana AS m ON m.fkSala = s.idSala;
    
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
    
SELECT * FROM alerta AS a
JOIN captura AS c
ON c.idCaptura = a.fkCaptura
ORDER BY c.dtCaptura DESC;
  
SELECT a.idAlerta AS idAlerta, m.idMaquina AS idMaquina, CONCAT(ROUND(ca.registro, 1), c.formatacao) AS captura, p.nivel 
FROM Maquina AS m
JOIN Componente AS c
ON c.fkMaquina = m.idMaquina
JOIN Captura AS ca
ON ca.fkComponente = c.idComponente
JOIN Alerta AS a
ON a.fkCaptura = ca.idCaptura
JOIN Parametro AS p
ON p.idParametro = a.fkParametro;  

-- -- OUTRA IDEIA DE SELECT --------------------------------------------	
    SELECT 
    CONCAT('Máquina ', m.idMaquina) AS identificacao,
    estado.estado_maquina AS status,
    CASE 
        WHEN estado.estado_maquina = 'Estável' THEN 'Funcionamento regular'
        ELSE ult.mensagem
    END AS descricao
FROM maquina AS m
-- subquery que calcula o estado da máquina
LEFT JOIN (
    SELECT 
        c.fkMaquina,
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
    GROUP BY c.fkMaquina
) AS estado ON estado.fkMaquina = m.idMaquina
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
        WHEN estado.estado_maquina = 'Crítico' THEN 1
        WHEN estado.estado_maquina = 'Atenção' THEN 2
        WHEN estado.estado_maquina = 'Estável' THEN 3
        ELSE 4
    END;
    
-- Select últimos alertas
SELECT m.idMaquina AS identificacao, c.nome as comp, ROUND(ca.registro, 1) AS registro, c.formatacao, p.nivel, m.fkSala AS sala, ca.dtCaptura AS hora FROM Alerta AS a
JOIN Captura AS ca
ON ca.idCaptura = a.fkCaptura
JOIN Componente AS c
ON c.idComponente = ca.fkComponente
JOIN Maquina AS m
ON m.idMaquina = c.fkMaquina
JOIN Parametro AS p
ON p.idParametro = a.fkParametro
WHERE DATE(ca.dtCaptura) = CURDATE()
ORDER BY ca.dtCaptura DESC; 

-- --------------- SELECT´S PÁGINA: ANÁLISE ESPECÍFICA ----------------------------------------------------------------
-- Selecionar as salas
SELECT idSala AS identificacao
FROM Sala;

-- Selecionar Maquinas daquela Sala
SELECT idMaquina FROM Maquina
WHERE fkSala = 1;

-- Selecionar o componente da máquina
SELECT co.idComponente AS id, co.nome AS nome 
FROM Componente AS co
WHERE co.fkMaquina = 2 AND nome NOT LIKE 'CPU' AND nome NOT LIKE 'RAM' AND nome NOT LIKE 'Disco'
ORDER BY id DESC
LIMIT 2;
            
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
SELECT m.idMaquina AS identificacao, c.nome as comp, ROUND(ca.registro, 1) AS registro, c.formatacao, p.nivel, m.fkSala AS sala, ca.dtCaptura AS hora FROM Alerta AS a
JOIN Captura AS ca
ON ca.idCaptura = a.fkCaptura
JOIN Componente AS c
ON c.idComponente = ca.fkComponente
JOIN Maquina AS m
ON m.idMaquina = c.fkMaquina
JOIN Parametro AS p
ON p.idParametro = a.fkParametro
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE()
ORDER BY ca.dtCaptura DESC; 

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
WHERE m.idMaquina = 1 AND DATE(ca.dtCaptura) = CURDATE() AND c.nome NOT LIKE 'Upload' AND c.nome NOT LIKE 'Download'
GROUP BY c.nome;
-- --------------- SELECT´S PÁGINA: PÁGINAS USUÁRIOS ----------------------------------------------------------------
-- Quantidade de solicitações de entrada
SELECT count(status) FROM Usuario
WHERE status LIKE 'pendente';

SELECT idUsuario, u.nome AS nomeUsuario, u.email, c.nome AS cargo, u.dtCadastro, UPPER(u.status) AS status
FROM usuario AS u
JOIN cargo AS c ON u.fkCargo = c.idCargo
WHERE status NOT LIKE 'PENDENTE'
ORDER BY u.idUsuario DESC;

-- --------------- SELECT´S PÁGINA: MÁQUINAS ----------------------------------------------------------------
-- Listagem das máquinas
	SELECT m.idMaquina AS identificacao, CONCAT('Máquina ', m.idMaquina) AS identificacao, m.estado AS estado,
		CONCAT('Sala ', m.fkSala) AS localizacao, m.sistemaOperacional AS so, m.ip AS ipv4,
		cpu.capacidade AS cpu_capacidade, ram.capacidade AS ram_capacidade, disco.capacidade AS disco_capacidade
	FROM Maquina AS m
	LEFT JOIN Componente AS cpu
		ON cpu.fkMaquina = m.idMaquina AND cpu.nome = 'CPU'
	LEFT JOIN Componente AS ram
		ON ram.fkMaquina = m.idMaquina AND ram.nome = 'RAM'
	LEFT JOIN Componente AS disco
		ON disco.fkMaquina = m.idMaquina AND disco.nome = 'Disco';

-- --------------- SELECT´S PÁGINA: PÁGINA ALERTAS ----------------------------------------------------------------
-- Quantidade de páginas
SELECT CEIL(COUNT(idAlerta) / 8) AS paginas
FROM Alerta;

SELECT CONCAT('Máquina ', m.idMaquina) AS identificacao, CASE WHEN c.nome LIKE 'RAM' THEN 'Memória RAM' ELSE c.nome END AS componente, REPLACE(
    REPLACE( REPLACE( REPLACE(a.mensagem, ' de CPU', ''), ' de Memoria', ''),' de Disco', ''), 'a', 'em') AS mensagem, 
    p.nivel AS nivel, CONCAT('Sala ', m.fkSala) AS localizacao, DATE_FORMAT(ca.dtCaptura, '%d/%m/%Y %H:%i:%s') AS hora
FROM Maquina AS m
JOIN Componente AS c
ON m.idMaquina = c.fkMaquina
JOIN Captura AS ca
ON ca.fkComponente = c.idComponente
JOIN Alerta AS a
ON a.fkCaptura = ca.idCaptura
JOIN Parametro AS p
ON p.fkComponente = c.idComponente
ORDER BY ca.dtCaptura DESC
LIMIT 8;


select * from componente;
