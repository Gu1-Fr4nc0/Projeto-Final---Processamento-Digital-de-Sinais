# Análise de Corrente de Motor para Diagnóstico de Falhas (MCSA)

Este projeto implementa a técnica **Motor Current Signature Analysis (MCSA)** para detecção de falhas em rolamentos de motores elétricos através do processamento de sinais de corrente.

## 📋 Autores
* **Felipe Ferrer Sorrilha**
* **Guilherme Pança Franco**

## 📁 Estrutura do Projeto
- `final.mlx`: Script principal em MATLAB Live Script
- `N09_M07_F10_K001_1.mat`: Dados do motor em condição normal
- `N09_M07_F10_KA04_1.mat`: Dados do motor com falha no anel externo
- `Artigo.pdf`: Artigo técnico completo com metodologia e resultados

**Fonte dos dados:** Paderborn University Bearing Dataset

## ⚙️ Execução
1. Clone ou baixe o repositório
2. Abra o MATLAB na pasta do projeto
3. Execute `final.mlx`
4. Os resultados serão exibidos automaticamente

### Pré-requisitos
- MATLAB (sem toolboxes adicionais necessárias)
- Os arquivos `.mat` devem estar na mesma pasta do script

## 📈 Resultados
O script gera:
1. Gráfico comparativo dos espectros PSD das condições normal e com falha
2. Gráfico de energia por faixa espectral
3. Métricas quantitativas no console:
   - RMSE entre espectros
   - Aumento de energia na banda 0-100Hz
   - Índice de modulação

## 🔍 Metodologia
- Pré-processamento e filtragem dos sinais de corrente
- Análise espectral (PSD)
- Demodulação por envelope
- Cálculo de métricas de diagnóstico

## 📄 Referência
Para detalhes completos da metodologia, análise e discussão dos resultados, consulte o arquivo `Artigo_Final.pdf`.
