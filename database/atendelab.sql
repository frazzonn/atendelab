
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `perfil` enum('admin','atendente') NOT NULL DEFAULT 'atendente',
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pessoas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `curso` varchar(100) DEFAULT NULL,
  `periodo` varchar(100) DEFAULT NULL,
  `observacoes` text DEFAULT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  PRIMARY KEY (`id`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `tipos_atendimentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `atendimentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pessoa_id` int(11) NOT NULL,
  `tipo_atendimento_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `descricao` text DEFAULT NULL,
  `status` enum('aberto','em_andamento','concluido','cancelado') NOT NULL DEFAULT 'aberto',
  `data_atendimento` date NOT NULL,
  `horario_atendimento` time NOT NULL,
  `observacao_final` text DEFAULT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `pessoa_id` (`pessoa_id`),
  KEY `tipo_atendimento_id` (`tipo_atendimento_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `atendimentos_ibfk_1` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoas` (`id`),
  CONSTRAINT `atendimentos_ibfk_2` FOREIGN KEY (`tipo_atendimento_id`) REFERENCES `tipos_atendimentos` (`id`),
  CONSTRAINT `atendimentos_ibfk_3` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Usuario administrador padrao
-- E-mail: admin@atendelab.com  |  Senha: 123456
--

--
-- Usuarios (senha de todos: 123456)
--
INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`, `perfil`, `status`) VALUES
(1, 'Administrador', 'admin@atendelab.com', '$2y$10$3IZHNdb/O7p0ce6HDg6QmeF5HFpRZKDaP7ALUhbtT8FNJKrteDRmi', 'admin', 'ativo'),
(2, 'Carla Mendes', 'carla@atendelab.com', '$2y$10$3IZHNdb/O7p0ce6HDg6QmeF5HFpRZKDaP7ALUhbtT8FNJKrteDRmi', 'atendente', 'ativo'),
(3, 'Bruno Souza', 'bruno@atendelab.com', '$2y$10$3IZHNdb/O7p0ce6HDg6QmeF5HFpRZKDaP7ALUhbtT8FNJKrteDRmi', 'atendente', 'ativo');

--
-- Tipos de atendimento
--
INSERT INTO `tipos_atendimentos` (`id`, `nome`, `descricao`, `status`) VALUES
(1, 'Apoio acadêmico geral', 'Suporte e orientação sobre disciplinas, rotina e vida universitária.', 'ativo'),
(2, 'Suporte de sistemas', 'Ajuda com portal do aluno, sistemas internos e acesso a laboratórios.', 'ativo'),
(3, 'Acompanhamento de TCC', 'Orientação e apoio no desenvolvimento do trabalho de conclusão de curso.', 'ativo'),
(4, 'Setor financeiro e bolsas', 'Informações sobre pagamentos, bolsas, descontos e financiamentos.', 'ativo'),
(5, 'Carreira e estágio', 'Encaminhamento e orientação para estágios, empregos e mercado de trabalho.', 'ativo'),
(6, 'Apoio psicológico e pedagógico', 'Atendimento voltado ao bem-estar emocional e suporte educacional.', 'inativo');

--
-- Pessoas atendidas
--
INSERT INTO `pessoas` (`id`, `nome`, `documento`, `telefone`, `email`, `curso`, `periodo`, `observacoes`, `status`) VALUES
(1, 'Camila Ribeiro', '201.302.403-11', '(47) 99111-1010', 'camila.ribeiro@univille.br', 'Engenharia de Software', '5', 'Aluna destaque em projetos.', 'ativo'),
(2, 'Bruno Almeida', '202.303.404-22', '(47) 99222-2020', 'bruno.almeida@univille.br', 'Engenharia de Software', '5', NULL, 'ativo'),
(3, 'Juliana Martins', '203.304.405-33', '(47) 99333-3030', 'juliana.martins@univille.br', 'Direito', '3', 'Solicitou revisão de matrícula.', 'ativo'),
(4, 'Felipe Gonçalves', '204.305.406-44', '(47) 99444-4040', 'felipe.goncalves@univille.br', 'Administração', '7', NULL, 'ativo'),
(5, 'Larissa Souza', '205.306.407-55', '(47) 99555-5050', 'larissa.souza@univille.br', 'Psicologia', '4', 'Acompanhamento pedagógico.', 'ativo'),
(6, 'Mateus Costa', '206.307.408-66', '(47) 99666-6060', 'mateus.costa@univille.br', 'Engenharia Civil', '8', NULL, 'ativo'),
(7, 'Sabrina Lima', '207.308.409-77', '(47) 99777-7070', 'sabrina.lima@univille.br', 'Medicina', '2', 'Bolsista integral.', 'ativo'),
(8, 'Daniel Pereira', '208.309.410-88', '(47) 99888-8080', 'daniel.pereira@univille.br', 'Ciência da Computação', '6', NULL, 'ativo'),
(9, 'Isabela Rocha', '209.310.411-99', '(47) 99999-9090', 'isabela.rocha@univille.br', 'Arquitetura e Urbanismo', '5', NULL, 'ativo'),
(10, 'Gustavo Henrique', '210.311-512-10', '(47) 99771-1112', 'gustavo.henrique@univille.br', 'Engenharia de Software', '5', 'Representante acadêmico.', 'ativo'),
(11, 'Amanda Fernandes', '211.312.613-11', '(47) 99772-2223', 'amanda.fernandes@univille.br', 'Enfermagem', '1', 'Transferência recente.', 'inativo'),
(12, 'Thiago Ramos', '212.313.714-12', '(47) 99773-3334', 'thiago.ramos@univille.br', 'Educação Física', '9', 'Finalizando estágio.', 'inativo');

--
-- Atendimentos
--
INSERT INTO `atendimentos` (`id`, `pessoa_id`, `tipo_atendimento_id`, `usuario_id`, `descricao`, `status`, `data_atendimento`, `horario_atendimento`, `observacao_final`) VALUES
(1, 1, 1, 1, 'Dúvidas sobre a grade curricular do 5º período.', 'concluido', '2026-06-01', '09:00:00', 'Aluna orientada sobre pré-requisitos.'),
(2, 2, 2, 2, 'Sem acesso ao portal do aluno.', 'concluido', '2026-06-02', '10:30:00', 'Senha redefinida e acesso liberado.'),
(3, 3, 1, 1, 'Revisão de matrícula em disciplina optativa.', 'em_andamento', '2026-06-03', '14:00:00', NULL),
(4, 4, 4, 3, 'Negociação de mensalidade em atraso.', 'aberto', '2026-06-05', '11:15:00', NULL),
(5, 5, 6, 2, 'Encaminhamento para apoio psicopedagógico.', 'concluido', '2026-06-06', '16:00:00', 'Aluna encaminhada ao núcleo de apoio.'),
(6, 6, 3, 1, 'Definição do tema de TCC.', 'em_andamento', '2026-06-08', '08:30:00', NULL),
(7, 7, 4, 3, 'Entrega de documentação da bolsa PROUNI.', 'concluido', '2026-06-09', '13:45:00', 'Documentos validados e protocolados.'),
(8, 8, 5, 2, 'Busca por vaga de estágio em TI.', 'aberto', '2026-06-10', '15:20:00', NULL),
(9, 9, 2, 1, 'Erro ao enviar trabalho no AVA.', 'cancelado', '2026-06-11', '09:50:00', 'Aluna resolveu por conta própria antes do atendimento.'),
(10, 10, 1, 2, 'Orientação sobre colação de grau.', 'aberto', '2026-06-12', '10:10:00', NULL),
(11, 1, 3, 1, 'Ajuste do cronograma de entregas do TCC.', 'em_andamento', '2026-06-15', '14:30:00', NULL),
(12, 11, 1, 3, 'Processo de transferência de instituição.', 'concluido', '2026-05-20', '11:00:00', 'Transferência concluída no semestre anterior.'),
(13, 4, 5, 2, 'Orientação de carreira na área de gestão.', 'concluido', '2026-06-18', '16:40:00', 'Indicado programa de trainee parceiro.'),
(14, 6, 2, 1, 'Configuração de software do laboratório.', 'concluido', '2026-06-20', '09:15:00', 'Software instalado e testado.'),
(15, 8, 4, 3, 'Renovação de financiamento estudantil.', 'em_andamento', '2026-06-22', '13:00:00', NULL),
(16, 10, 5, 2, 'Revisão de currículo para vaga de estágio.', 'aberto', '2026-06-25', '17:00:00', NULL);

COMMIT;
