
# Banco de Dados

Essa repositório é destinado para os scripts e modelagem de Banco de dados


## 🛠Como usar:




 - 1º - Clone esse repositório:
 ```bash
  git clone https://github.com/SafeClass-PI/Banco-de-Dados.git
```


## ✍ Regras de sintaxe

Para edição do script de banco de dados ultilizar o Camelcase:
 ```bash
    nomeTabela 
    //Primeira letra minúscula caso haja quebra de texto usar a proxima letra maiúscula
```
Para criação de tabelas seguir o modelo:
 ```bash
    CREATE TABLE codigoConfiguracao (

    idCodigoConfiguracao INT AUTO_INCREMENT,

    fkEscola INT,

    CONSTRAINT pkCompostaCodigoConfiguracao PRIMARY KEY (idCodigoConfiguracao, fkEscola),

    dataCriacao DATETIME          DEFAULT CURRENT_TIMESTAMP,

    dataExpiracao DATETIME        NOT NULL,

    status VARCHAR(45)            NOT NULL DEFAULT 'Ativo',

    CONSTRAINT chkStatusCodigoConfiguracao CHECK (status IN('Ativo','Expirado')),

    CONSTRAINT fkCodigoConfiguracaoEscola FOREIGN KEY (fkEscola) REFERENCES escola(idEscola)

);
```

