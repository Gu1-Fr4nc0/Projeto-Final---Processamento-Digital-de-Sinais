# Projeto Final PDS - Tema 6: Corrente de Motores sob Falha (MCSA)

Este repositório contém o projeto final da disciplina de Processamento Digital de Sinais (2025/2). O trabalho implementa a técnica **MCSA (Motor Current Signature Analysis)** para diagnosticar falhas em rolamentos de motores elétricos, utilizando análise espectral e demodulação por envelope.

## 👥 Autores
* **Felipe Ferrer Sorrilha**
* **Guilherme Pança Franco**

## 📂 Conteúdo do Repositório
Todos os arquivos necessários para a execução estão incluídos neste repositório:

* `final.mlx`: Script principal em MATLAB (contém todo o processamento, filtros e geração de gráficos).
* `N09_M07_F10_K001_1.mat`: Dados do motor em condição **Saudável** (Baseline).
* `N09_M07_F10_KA04_1.mat`: Dados do motor com **Falha no Anel Externo**.
* `Artigo_Final.pdf`: Relatório técnico completo com a fundamentação teórica e discussão dos resultados.

> **Fonte dos Dados:** Os sinais de corrente foram obtidos do *Paderborn University Bearing Dataset*.

## 🚀 Como Executar (Reprodução)
O código foi desenvolvido para rodar nativamente, **sem necessidade de toolboxes adicionais** (como Signal Processing Toolbox).

1.  **Clone ou Baixe** este repositório completo.
2.  Abra o MATLAB e navegue até a pasta do projeto.
3.  Abra o arquivo `final.mlx`.
4.  Clique em **Run**.

### O que o código fará:
1.  Carregará automaticamente os arquivos `.mat` inclusos na pasta.
2.  Realizará o pré-processamento e filtragem dos sinais.
3.  Gerará uma figura com dois gráficos:
    * **Espectro MCSA (Superior):** Comparação das correntes na frequência fundamental.
    * **Espectro de Envelope (Inferior):** Evidência da falha mecânica.
4.  Exibirá no **Command Window** as métricas quantitativas (RMSE e Aumento de Energia).

## 📊 Resultados Esperados
Ao executar o script, você observará que o sinal com falha (Vermelho) apresenta um aumento significativo de energia nas baixas frequências do envelope em comparação ao sinal saudável (Azul), confirmando o diagnóstico da falha no rolamento.
