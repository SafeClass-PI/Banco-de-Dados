
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
CNPJ char(11)
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

create table Contato (
IdContato int,
FkEscola int,
constraint pkCompostaContato primary key (FkEscola, IdContato),
NomeResponsavel varchar(45),
EmailResponsavel varchar(45),
TelefoneResponsavel varchar(45),
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
constraint FkConviteEscola foreign key (FkEscola) references Escola(IdEscola),
constraint FkConviteUsuario foreign key (FkUsuario) references Usuario(IdUsuario),
constraint FkConvitePermissoes foreign key (FkPermissao) references Permissoes(IdPermissao)
);

create table Maquina (
IdMaquina int auto_increment,
FkEscola int,
constraint pkCompostaMaquina primary key(IdMaquina, FkEscola),
Nome_indetificao varchar(45),
Serial_number varchar(45),
constraint FkMaquinaEscola foreign key (FkEscola) references Escola(IdEscola)
);

create table Componentes_a_monitorar (
IdComponente int primary key auto_increment,
Metrica varchar(45),
Unidade_de_medida varchar(45)
);

create table Maquina_monitoramento (
FkMaquina int,
FkComponente int,
constraint pkCompostaMaquina_monitoramento primary key(FkMaquina,FkComponente),
Data_config datetime default current_timestamp,
constraint FkMaquina_monitoramentoMaquina foreign key (FkMaquina) references Maquina(IdMaquina),
constraint FkMaquina_monitoramentoComponentes_a_monitorar foreign key (FkComponente) references Componentes_a_monitorar(IdComponente)
);

create table Leitura (
IdLeitura int auto_increment,
FkMaquina int,
FkComponente int,
constraint pkCompostaLeitura primary key(IdLeitura, FkMaquina, FkComponente),
Medida varchar(45),
constraint fkLeituraMaquina foreign key (FkMaquina) references Maquina_monitoramento(FkMaquina),
constraint fkLeituraComponente foreign key (FkComponente) references Maquina_monitoramento(FkMaquina)
);



DROP USER IF EXISTS logpython;
CREATE USER 'logpython'@'%' IDENTIFIED BY 'L@gpyThon!.04';
GRANT INSERT,SELECT ON safeClass.* TO 'logpython'@'%';
FLUSH PRIVILEGES;
