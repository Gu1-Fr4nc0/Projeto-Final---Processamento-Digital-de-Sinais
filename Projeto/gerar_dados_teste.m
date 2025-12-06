% NOME DO ARQUIVO: gerar_dados_teste.m
clc; clear; close all;

% Configurações de Simulação
fs = 64000;             % Taxa de amostragem (alta resolução conforme Paderborn) [cite: 115]
T = 2;                  % Duração em segundos
t = 0:1/fs:T-1/fs;      % Vetor de tempo

% --- 1. Criar Sinal "SAUDÁVEL" ---
% Apenas frequência fundamental da rede (60Hz) + ruído branco
f_rede = 60;
ruido = 0.05 * randn(size(t));
corrente_normal = 10 * sin(2*pi*f_rede*t) + ruido;

% --- 2. Criar Sinal com "FALHA" ---
% Adiciona modulação de amplitude (AM) típica de falhas mecânicas/rolamento
% A falha gera bandas laterais em f_rede +/- f_falha
f_falha = 7; % Frequência característica do defeito (ex: 7 Hz)
modulacao = 0.2 * cos(2*pi*f_falha*t); % Sinal modulante
corrente_falha = (10 + modulacao) .* sin(2*pi*f_rede*t) + ruido;

% --- 3. Salvar como .mat ---
% Estrutura simulando o formato que vamos ler depois
dados.fs = fs;
dados.normal = corrente_normal;
dados.falha = corrente_falha;

save('dados_motor_teste.mat', 'dados');

fprintf('Arquivo "dados_motor_teste.mat" gerado com sucesso!\n');
fprintf('Sinais criados: Normal (60Hz) e Falha (60Hz com bandas laterais em +/- %dHz)\n', f_falha);