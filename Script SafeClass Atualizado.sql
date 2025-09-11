DROP DATABASE IF EXISTS safeClass; 

CREATE DATABASE safeClass;

USE safeClass;

CREATE TABLE escola (

idEscola INT PRIMARY KEY AUTO_INCREMENT,

nomeDaEscola VARCHAR(45)          NOT NULL,

codigoInep VARCHAR(45)            NOT NULL UNIQUE,

esferaAdministrativa VARCHAR(45)  NOT NULL,

CONSTRAINT chkEsferaAdministrativa CHECK (esferaAdministrativa in('Municipal','Estadual','Federal')),

cnpj CHAR(14)                     NOT NULL

) AUTO_INCREMENT = 1000;

CREATE TABLE endereco (

idEndereco INT AUTO_INCREMENT,

fkEscola INT,

CONSTRAINT pkCompostaEndereco PRIMARY KEY (idEndereco, fkEscola),

uf CHAR(2)                NOT NULL,

cidade VARCHAR(45)        NOT NULL,

bairro VARCHAR(45)        NOT NULL,

logradouro VARCHAR(45)    NOT NULL,

numero VARCHAR(45)        NOT NULL,

complemento VARCHAR(45)   DEFAULT NULL,

cep CHAR(8)               NOT NULL,

CONSTRAINT fkEnderecoEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola)

);

CREATE TABLE codigoConfiguracao (

idCodigoConfiguracao INT AUTO_INCREMENT,

fkEscola INT,

CONSTRAINT pkCompostaCodigoConfiguracao PRIMARY KEY (idCodigoConfiguracao, fkEscola),

chaveConfiguracao VARCHAR(45) NOT NULL,

dataCriacao DATETIME          DEFAULT CURRENT_TIMESTAMP,

dataExpiracao DATETIME        NOT NULL,

usos INT                      DEFAULT 0,

status VARCHAR(45)            NOT NULL DEFAULT 'Ativo',

CONSTRAINT chkStatusCodigoConfiguracao CHECK (status IN('Ativo','Expirado')),

CONSTRAINT fkCodigoConfiguracaoEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola)

);

CREATE TABLE usuario (

idUsuario INT PRIMARY KEY AUTO_INCREMENT,

nome VARCHAR(45)     NOT NULL,

email VARCHAR(45)    NOT NULL,

senha VARCHAR(256)   NOT NULL,

cpf CHAR(11)         NOT NULL,

cargo VARCHAR(45)    DEFAULT NULL

);
 
 CREATE TABLE permissoes (
 
 idPermissoes INT PRIMARY KEY AUTO_INCREMENT,
 
 nome VARCHAR(45)        NOT NULL,
 
 descricao VARCHAR(500)  NOT NULL
 
 );
 
 CREATE TABLE usuarioEscola (
 
 idUsuarioEscola INT AUTO_INCREMENT,
 
 fkEscola INT,
 
 fkUsuario INT,
 
 fkPermissoes INT,
 
 CONSTRAINT pkCompostaUsuarioEscola PRIMARY KEY (idUsuarioEscola, fkEscola, fkUsuario, fkPermissoes),
 
 dataAdmissao DATETIME DEFAULT CURRENT_TIMESTAMP,
 
 status VARCHAR(45) DEFAULT 'Inativo',
 
 CONSTRAINT chkStatusUsuarioEscola CHECK (status in('Ativo','Inativo')),
 
 CONSTRAINT fkUsuarioEscolaEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola),
 CONSTRAINT fkUsuarioEscolaUsuario FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario),
 CONSTRAINT fkUsarioEscolaPermissoes FOREIGN KEY (fkPermissoes) REFERENCES permissoes(idPermissoes)
 );
 
 CREATE TABLE convite (
 
 idConvite INT AUTO_INCREMENT,
 
 fkEscola INT,
 
 fkPermissoes INT,
 
 CONSTRAINT pkComposta PRIMARY KEY(idConvite, fkEscola, fkPermissoes),
 
 dataConvite DATETIME     DEFAULT CURRENT_TIMESTAMP,
 
 dataExpiracao DATETIME   NOT NULL,
 
 status VARCHAR(45)       DEFAULT 'Expirado',
 
 CONSTRAINT chkStatusConvite CHECK (status in('Pendente','Aceito','Expirado','Cancelado')),
 
 CONSTRAINT fkConviteEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola),
 CONSTRAINT fkConvitePermissoes FOREIGN KEY (fkPermissoes) REFERENCES permissoes(idPermissoes)
 );
 
 CREATE TABLE maquina (
 
 idMaquina INT AUTO_INCREMENT,
 
 fkEscola INT,
 
 CONSTRAINT pkCompostaMaquina PRIMARY KEY (idMaquina, fkEscola),
 
 uuid VARCHAR(45)                     NOT NULL,
 
 serialNumberBios VARCHAR(45)         NOT NULL,
 
 serialNumberMotherboard VARCHAR(45)  NOT NULL,
 
 nomeIndentificacao VARCHAR(45)       NOT NULL,
 
 CONSTRAINT fkMaquinaEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola)
 
 );
 
 CREATE TABLE componentesAMonitorar (
 
 idComponentesAMonitorar INT PRIMARY KEY AUTO_INCREMENT,
 
 nomeMonitoramento VARCHAR(45)  NOT NULL,
 
 unidadeMedida VARCHAR(45)      NOT NULL
 
 );
 
 CREATE TABLE maquinaMonitoramento (
 
 fkEscola INT,
 
 fkMaquina INT,
 
 fkComponentesAMonitorar INT,
 
 CONSTRAINT pkMaquinaMonitoramento PRIMARY KEY (fkEscola, fkMaquina, fkComponentesAMonitorar),
 
 dataConfiguracao DATETIME DEFAULT CURRENT_TIMESTAMP,
 
 CONSTRAINT fkMaquinaMonitoramentoEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola),
 CONSTRAINT fkMaquinaMonitoramentoMaquina FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
 CONSTRAINT fkMaquinaMonitoramentoComponentesAMonitorar FOREIGN KEY (fkComponentesAMonitorar) REFERENCES componentesAMonitorar(idComponentesAMonitorar)
 
 );
 
 CREATE TABLE leitura (
 
 idLeitura INT AUTO_INCREMENT,
 
 fkEscola INT,
 
 fkMaquina INT,
 
 fkComponentesAMonitorar INT,
 
 CONSTRAINT pkLeitura PRIMARY KEY (idLeitura, fkEscola, fkMaquina, fkComponentesAMonitorar),
 
 medida VARCHAR(45) NOT NULL,
 
 dataCaptura DATETIME DEFAULT CURRENT_TIMESTAMP,
 
 CONSTRAINT fkLeituraEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola),
 CONSTRAINT fkLeituraMaquina FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
 CONSTRAINT fkLeituraComponentesAMonitorar FOREIGN KEY (fkComponentesAMonitorar) REFERENCES componentesAMonitorar(idComponentesAMonitorar)
 );
 
 -- Crição do User INSERT e SELECT
 
DROP USER IF EXISTS logpython;
CREATE USER 'logpython'@'%' IDENTIFIED BY 'L@gpyThon!.04';
GRANT INSERT,SELECT ON safeClass.* TO 'logpython'@'%';
FLUSH PRIVILEGES;

/*
Nome do Usuário: "logpython"
Senha Usuário: "L@gpyThon!.04"
*/