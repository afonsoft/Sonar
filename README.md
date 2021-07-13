# Docker

Instalação do Docker [Download Docker for Desktop](https://www.docker.com/products/docker-desktop)
Apos a instalação do docker, iremos instalar SonarQube e/ou PostgresSQL.
Abre o PowerShell ou command prompt 'CMD'

### Instalação com Banco de Dados
Fazendo a configuração da rede interna do docker
```powershell
PS C:\>docker network create mynet
```

Fazendo o download do container do **postgres**.
```powershell
PS C:\>docker pull postgres
PS C:\>docker run --restart always --name sonar-postgres -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar -d -p 5432:5432 --net mynet postgres
```

Fazendo o download do **SonarQube**
```powershell 
PS C:\>docker pull sonarqube
PS C:\>docker run --restart always --name sonarqube -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-postgres:5432/sonar -d --net mynet sonarqube
```

### Istalação sem Banco de Dados
Fazendo o download do **SonarQube**
```powershell
PS C:\>docker pull sonarqube
PS C:\>docker run --restart always --name sonarqube -p 9000:9000 sonarqube
```

## Comandos do Docker
Listar os container
``docker ps -a``

Reinicar os container caso necessário ou se não iniciar junto ao windows
``docker container restart [Container Id]``

## SONNAR SCANNER
Primeiro temos de verificar se está instalado os runtimes.
1) Make sure the .NET Framework v4.7+ is installed - [Download](https://dotnet.microsoft.com/download/dotnet-framework/net472)
2) Make sure the Java Runtime Environment 8 is installed - [Download](https://www.oracle.com/br/java/technologies/javase/javase-jdk8-downloads.html)
3) Make sure the Java Runtime Environment 11 is installed - [Download](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)

Instalação do SonarScanner, efetue o download do [SonarScanner.zip]()
Extrair o SonarScanner.zip no C:\SonarScanner

1) Adicione o diretório do executável à variável de ambiente %PATH%
   ``PATH -> C:\SonarScanner;C:\SonarScanner\FW;``

O diretório tem de ficar ASSIM
>
> C:\SonarScanner>\
> -> FW\
> -> netcore\
> -> sonar-scanner-4.1.0.1829\
> -> .wslconfig\
> -> docker.Sonar.Install.txt\
> -> nuget.config\
> -> nuget.exe\
> -> Sonar.bat

Edit o arquivo **nuget.config** para colocar as suas credenciais de rede. ``<packageSourceCredentials>``
Tem de colocar as credencias de rede para cada url de **packageSources**.

```xml
  <packageSourceCredentials>
    <GolFeed>
      <add key="Username" value="adfilho@voegol.com.br" />
      <add key="ClearTextPassword" value="********" />
    </GolFeed>
    <EAF>
      <add key="Username" value="adfilho@voegol.com.br" />
      <add key="ClearTextPassword" value="********" />
    </EAF>
    <MMS>
      <add key="Username" value="adfilho@voegol.com.br" />
      <add key="ClearTextPassword" value="********" />
    </MMS>
    <Aggregate_Feeds>
      <add key="Username" value="adfilho@voegol.com.br" />
      <add key="ClearTextPassword" value="********" />
    </Aggregate_Feeds>
  </packageSourceCredentials>
```

Edit o arquivo **Sonar.bat** para efetuar as configurações: PathMSBuild, SonarLogin, SonarPassword, SonarHost caso necessário

```bat
SET PathSonar=C:\SonarScanner
SET PathMSBuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin
SET PathNuget=C:\SonarScanner\
SET SonarLogin=admin
SET SonarPassword=admin
SET SonarHost=http://localhost:9000
```

### Configurações do WSL2 junto do Docker
A ultima versão do Docker roda junto com o WSL2 para utilizar o container linux.
Porem em alguns casos ele consome muita mémoria da maquina. Existe uma configuração global para o WSL2.

É possível definir uma configuração global para WSL2 no arquivo que deve existir na pasta do usuário **%UserProfile%** ex: **C:\Usuários\adfilho**, este arquivo nos permite definir a RAM máxima que o WSL2 deve consumir, se utlizar o docker somente para o SonarQube pode deixar o limite em 512MB se utilizar o WSL2 para o ubuntu e docker deixar em 1G, se for utilizar o docker para outras finalidades deixe com pelo menos 2G de momoria.

O nome do arquivo é **.wslconfig**

```config
[wsl2]
memory=1GB
processors=2
swap=8GB
localhostForwarding=true
```

Reinicie o computador e, a partir de agora, você não terá problemas com alto consumo de memória.

[Mais informações](https://dev.to/kada/getting-started-with-wsl-2-part-2-4bpj)

### Executando o SonarScanner
Abra o command prompt 'CMD' para executar o **sonar.bat**
```bat
C:\>cd SonarScanner
C:\SonarScanner>
```

**Command Args**
>Path - Caminho completo de onde está o projeto.
>ProjectName - Nome da solution (.sln) ou o nome do projeto se for java/php
>Type - Tipo do scanner que será executado.
>Version - INC/CRD/MASTER

**Type**
* **core** - NetCore 2.0 to 3.1
* **fw** - framework 4.0 to 4.8
* **php** - PHP5 to PHP7
* **Angular** - AngularV4 to AngularV10
* **React** - React Native with NodeJS 

Você pode executar passando parametros para o bat ou somente rodar o bat e depois especificar cada parametro.

**Passando os parametros na execução**
``Sonar.bat "Path" "Solution/ProjectName" "Type" "Version"``
```bat
C:\SonarScanner>Sonar.bat C:\Users\mazza\source\repos\SkySales SkySales3.4.sln fw ft#21753
```

**Executando somente o bat**
``Sonar.bat``
```bat
C:\SonarScanner>Sonar.bat 
```
Ao executar-lo ele irá pedir as informações dos argumentos.
```bat
*********************************************************
Analise de Projeto (SonarScanner)

Command Args
Sonar.bat "Path" "Solution/ProjectName" "Type" "Version"

Type
core    -- NetCore 2.0 to 3.1
fw      -- framework 4.0 to 4.8
php     -- PHP5 to PHP7
Angular -- AngularV4 to AngularV10
React   -- React Native with NodeJS
*********************************************************

Solution (.sln)

Path of Solution: C:\Users\mazza\source\repos\SkySales
Solution Name (Project Name): SkySales3.4.sln
Type of Solution (Core/FW/PHP/Angular/React): fw
Version (INC/CRD/MASTER): MASTER
```

### Creditos
Documentação e arquivos de bath criado por [Afonso Dutra Nogueira Filho](mailto:adfilho@voegol.com.br)

| Versão | Data | Informações | Autor |
| ------ | ------ | ------ | ------ |
| 1.0 | 23/10/2020 | Criação do Documento Markdwon | Afonso |
| 1.1 | 26/10/2020 | Configuração WSL2 | Afonso |
| 1.2 | 27/10/2020 | Links downloads | Afonso |
| 1.3 | 16/02/2021 | Correção do textos | Afonso |
| 1.4 | 13/07/2021 | Correção do textos | Afonso |


