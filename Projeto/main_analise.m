% NOME DO ARQUIVO: main_analise.m
% VERSÃO FINAL LIMPA (Sem erros de texto ou tags)
clc; clear; close all;

%% 1. Carregamento dos Dados
% Definição dos arquivos baseada na sua pasta
arq_normal = 'N09_M07_F10_K001_1.mat'; % Saudável
arq_falha  = 'N09_M07_F10_KA04_1.mat'; % Falha Anel Externo

fs = 64000; % Taxa de amostragem padrão do Paderborn

fprintf('--- INICIANDO ANÁLISE ---\n');

% --- CARREGAR MOTOR NORMAL ---
if exist(arq_normal, 'file')
    dados = load(arq_normal);
    nome_var = fieldnames(dados); 
    struct_normal = dados.(nome_var{1});
    sinal_normal = double(struct_normal.Y(1).Data);
else
    error('ERRO: Arquivo %s não encontrado. Verifique a pasta.', arq_normal);
end

% --- CARREGAR MOTOR COM FALHA ---
if exist(arq_falha, 'file')
    dados = load(arq_falha);
    nome_var = fieldnames(dados);
    struct_falha = dados.(nome_var{1});
    sinal_falha = double(struct_falha.Y(1).Data);
else
    error('ERRO: Arquivo %s não encontrado. Verifique a pasta.', arq_falha);
end

%% 2. Ajuste de Tamanho (Corta para o menor tamanho)
% Isso evita o erro "Arrays have incompatible sizes"
L_min = min(length(sinal_normal), length(sinal_falha));
sinal_normal = sinal_normal(1:L_min);
sinal_falha  = sinal_falha(1:L_min);

% Diagnóstico de Amplitude (Confirmação que leu certo)
fprintf('Dados ajustados para %d pontos.\n', L_min);
fprintf('Amp Normal: %.2f | Amp Falha: %.2f\n', max(abs(sinal_normal)), max(abs(sinal_falha)));

%% 3. Pré-processamento (Filtro Manual via FFT)
% Substituimos a toolbox paga por matemática básica via FFT
fc_sinal = 2000; % Corte em 2kHz

% Remove nível DC
sinal_normal = detrend(sinal_normal);
sinal_falha  = detrend(sinal_falha);

% Aplica filtro ideal customizado
sinal_normal_filt = filtro_ideal_fft(sinal_normal, fs, fc_sinal);
sinal_falha_filt  = filtro_ideal_fft(sinal_falha, fs, fc_sinal);

%% 4. Análise Espectral Clássica (MCSA)
[f_norm, P_norm] = calcular_fft(sinal_normal_filt, fs);
[f_falha, P_falha] = calcular_fft(sinal_falha_filt, fs);

figure('Name', 'Analise MCSA - Corrente', 'Color', 'w', 'Position', [100, 100, 1000, 600]);

subplot(2,1,1);
plot(f_norm, P_norm, 'b', 'LineWidth', 1.0); hold on;
plot(f_falha, P_falha, 'r--', 'LineWidth', 1.2);
xlim([40 80]); % Zoom na rede (60Hz)
grid on;
title('Espectro MCSA (Zoom na Fundamental 60Hz)');
ylabel('Amplitude (A)'); xlabel('Frequência (Hz)');
legend('Saudável (K001)', 'Falha Anel Ext. (KA04)');

%% 5. Demodulação por Envelope
% A. Retificação
rect_normal = abs(sinal_normal_filt);
rect_falha  = abs(sinal_falha_filt);

% B. Filtro do Envelope (Passa-baixa agressivo < 100Hz)
fc_env = 100; 

% Remove nível DC do envelope
rect_normal = detrend(rect_normal, 'constant');
rect_falha  = detrend(rect_falha, 'constant');

env_normal = filtro_ideal_fft(rect_normal, fs, fc_env);
env_falha  = filtro_ideal_fft(rect_falha, fs, fc_env);

% C. FFT do Envelope
[f_env_n, P_env_n] = calcular_fft(env_normal, fs);
[f_env_f, P_env_f] = calcular_fft(env_falha, fs);

subplot(2,1,2);
plot(f_env_n, P_env_n, 'b', 'LineWidth', 1.0); hold on;
plot(f_env_f, P_env_f, 'r', 'LineWidth', 1.5);
xlim([0 100]); 
grid on;
title('Espectro do Envelope (Busca por Assinatura de Falha)');
ylabel('Amplitude'); xlabel('Frequência (Hz)');
legend('Envelope Normal', 'Envelope Falha');

%% 6. Cálculo de Métricas
% RMSE entre os espectros
erro_espectro = P_norm - P_falha;
rmse = sqrt(mean(erro_espectro.^2));

% Energia na banda de falha (0-100Hz)
idx_100 = find(f_env_f > 100, 1);
energia_normal = sum(P_env_n(1:idx_100).^2);
energia_falha  = sum(P_env_f(1:idx_100).^2);
aumento_energia = ((energia_falha - energia_normal) / energia_normal) * 100;

fprintf('--- RESULTADOS QUANTITATIVOS ---\n');
fprintf('RMSE Espectral: %.5f\n', rmse);
fprintf('AUMENTO DE ENERGIA (Falha vs Normal): %.2f%%\n', aumento_energia);
fprintf('-----------------------------------\n');

%% --- FUNÇÕES AUXILIARES ---
function s_out = filtro_ideal_fft(s_in, fs, fc)
    L = length(s_in);
    S_f = fft(s_in);
    freqs = (0:L-1)*(fs/L);
    mask = (freqs <= fc) | (freqs >= fs - fc);
    S_filt = S_f .* mask(:); 
    s_out = real(ifft(S_filt));
end

function [f, P1] = calcular_fft(sinal, fs)
    L = length(sinal);
    Y = fft(sinal);
    P2 = abs(Y/L);
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(floor(L/2)))/L;
end