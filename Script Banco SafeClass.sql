
/*

Usuário: logpython
Senha: L@gpyThon!.04
Possui acesso para Insert e Select em todo o database safeClass

Favor Executar com o root o script




*/

drop database if exists safeClass; 

create database safeClass;

use safeClass;

create table Escola (
IdEscola int primary key auto_increment,
Nome_da_escola varchar(50),
Codigo_INEP varchar(45),
Esfera_administrativa varchar(45),
constraint chkEsferaAdministrativa check (Esfera_Administrativa in("Municipal","Estadual","Federal")),
CNPJ char(14),
Codigo_Config varchar(45)
);

create table Endereco (
IdEndereco int auto_increment,
FkEscola int,
constraint pkCompostaEndereco primary key(idEndereco,fkEscola),
Uf char(2),
Cidade varchar(45),
Bairro varchar(45),
Logradouro varchar(45),
Complemento varchar(45),
CEP char(8),
constraint fkEnderecoEscola foreign key (FkEscola) references Escola(IdEscola)
);

create table Responsavel (
IdResponsavel int AUTO_INCREMENT,
FkEscola int,
constraint pkCompostaResponsavel primary key (IdResponsavel, FkEscola),
Nome varchar(45),
Email varchar(45),
Telefone varchar(45),
Cargo varchar(45),
constraint FkContatoEscola 
foreign key (FkEscola) references Escola(IdEscola)
);

create table Usuario (
IdUsuario int primary key auto_increment,
Nome varchar(45),
Email varchar(60),
Senha varchar(45),
CPF char(11)
);

create table Permissoes (
IdPermissao int primary key auto_increment,
Nome_Permissao varchar(45),
Descricao varchar(500)
);

create table Convite (
IdConvite int auto_increment,
FkEscola int,
FkUsuario int,
FkPermissao int,
constraint pkCompostaConvite primary key(IdConvite,FkEscola,FkUsuario,FkPermissao),
Data_convite datetime default current_timestamp,
Data_expiracao date,
constraint FkConviteEscola foreign key (FkEscola) references Escola(IdEscola),
constraint FkConviteUsuario foreign key (FkUsuario) references Usuario(IdUsuario),
constraint FkConvitePermissoes foreign key (FkPermissao) references Permissoes(IdPermissao)
);

create table Maquina (
IdMaquina int auto_increment,
UUID varchar(45),
Serial_number_bios varchar(45),
Serial_motherboard varchar(45),
FkEscola int,
constraint pkCompostaMaquina primary key(IdMaquina, FkEscola),
Nome_indetificao varchar(45),
constraint FkMaquinaEscola foreign key (FkEscola) references Escola(IdEscola)
);

create table Componentes_a_monitorar (
IdComponente int primary key auto_increment,
Metrica varchar(45),
Unidade_Medida varchar(45)
);

create table Maquina_monitoramento (
IdMaquinaMonitoramento int auto_increment,
FkEscola int,
FkMaquina int,
FkComponente int,
constraint pkCompostaMaquina_monitoramento primary key(IdMaquinaMonitoramento,FkMaquina,FkComponente,FkEscola),
Data_config datetime default current_timestamp,
constraint FkMaquina_monitoramentoEscola foreign key (FkEscola) references Escola(IdEscola),
constraint FkMaquina_monitoramentoMaquina foreign key (FkMaquina) references Maquina(IdMaquina),
constraint FkMaquina_monitoramentoComponentes_a_monitorar foreign key (FkComponente) references Componentes_a_monitorar(IdComponente)
);

create table Leitura (
IdLeitura int auto_increment,
FkEscola int,
FkMaquina int,
FkComponente int,
constraint pkCompostaLeitura primary key(IdLeitura, FkMaquina, FkComponente),
Medida varchar(45),
Data_captura datetime default current_timestamp,
constraint FkLeituraEscola foreign key (FkEscola) references Escola(IdEscola),
constraint fkLeituraMaquina foreign key (FkMaquina) references Maquina(IdMaquina),
constraint fkLeituraComponente foreign key (FkComponente) references Componentes_a_monitorar(IdComponente)
);

INSERT INTO Escola (Nome_da_escola, Codigo_INEP, Esfera_administrativa, CNPJ, Codigo_Config) VALUES
("Escola Municipal Aurora", "INEP001", "Municipal", "12345678001", "CFG001"),
("Colégio Estadual Horizonte", "INEP002", "Estadual", "12345678002", "CFG002"),
("Escola Federal de Tecnologia", "INEP003", "Federal", "12345678003", "CFG003"),
("Escola Municipal das Flores", "INEP004", "Municipal", "12345678004", "CFG004"),
("Colégio Estadual Monte Azul", "INEP005", "Estadual", "12345678005", "CFG005"),
("Instituto Federal do Saber", "INEP006", "Federal", "12345678006", "CFG006"),
("Escola Municipal Caminho Novo", "INEP007", "Municipal", "12345678007", "CFG007"),
("Colégio Estadual Vale Verde", "INEP008", "Estadual", "12345678008", "CFG008"),
("Escola Federal de Ciências", "INEP009", "Federal", "12345678009", "CFG009"),
("Escola Municipal Esperança", "INEP010", "Municipal", "12345678010", "CFG010");

INSERT INTO safeclass.Componentes_a_monitorar (Metrica) VALUES
('Porcentagem de uso da CPU(%)'),
('Frequência de uso da CPU(GHz)'),
('Uso da Memória RAM(%)'),
('Memória RAM Total(GB)'),
('Uso do disco(GB)'),
('Espaço restante do disco(GB)'),
('Espaço do Disco(GB)');

DROP USER IF EXISTS logpython;
CREATE USER 'logpython'@'%' IDENTIFIED BY 'L@gpyThon!.04';
GRANT INSERT,SELECT ON safeClass.* TO 'logpython'@'%';
FLUSH PRIVILEGES;


