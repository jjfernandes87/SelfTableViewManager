Documentação Fastlane 
================

# Instalação

Certifique-se de ter a versão mais recente das ferramentas de linha de comando do Xcode instaladas:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```

# Processo de desenvolvimento

A ideia é mostrar todo o processo de desenvolvimento ate a publicação da lib no cocoapods

### 1) Crie uma nova branch a partir da master

### 2) Faça a implementação do novo recurso e atualize seus seus testes unitários.

### 3) Testando sua lib
```
fastlane test
```

### 4) Atualizando versão do projeto

Quando você finalizou a implementação de um novo recurso, atualize a versão do projeto usando um dos nossos métodos pré-construídos do Fastlane:

```
fastlane patch
fastlane minor
fastlane major
```

### 5) Crie sua PR manualmente

### 6) Apos realizar o merge, selecione o branch Master e publique sua lib

```
fastlane tag_and_pod
```

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
