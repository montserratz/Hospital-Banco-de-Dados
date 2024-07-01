CREATE DATABASE hospital;
USE hospital;

DROP DATABASE hospital;

CREATE TABLE IF NOT EXISTS pacientes (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255),
    data_nascimento DATE,
    endereco VARCHAR(255),
	telefone VARCHAR(15),
    email VARCHAR(255),
    cpf VARCHAR(15) UNIQUE,
    rg VARCHAR(10) UNIQUE,
	convenio_id VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS medicos (
	id INTEGER PRIMARY KEY AUTO_INCREMENT, 
	cpf VARCHAR(15) UNIQUE,
	nome VARCHAR(255),
	telefone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS especialidades (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	especialidade VARCHAR(255)
);

CREATE TABLE  IF NOT EXISTS  receita_medica (
	id INTEGER PRIMARY KEY AUTO_INCREMENT, 
	medico VARCHAR(15), 
	medicamentos VARCHAR(255), 
	quantidade VARCHAR(255), 
	instrucoes TEXT,
     FOREIGN KEY (medico) REFERENCES medicos(cpf)
);

CREATE TABLE  IF NOT EXISTS  consultas (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	data DATE,
	medico INTEGER,
	paciente INTEGER,
	valor DECIMAL,
	convenio VARCHAR(255),
	especialidade INTEGER,
     receita_id INTEGER,
    FOREIGN KEY (medico) REFERENCES medicos(id),
    FOREIGN KEY (paciente) REFERENCES pacientes(id),
    FOREIGN KEY (convenio) REFERENCES pacientes(convenio_id),
    FOREIGN KEY (especialidade) REFERENCES especialidades(id),
	FOREIGN KEY (receita_id) REFERENCES receita_medica(id)
);


 
CREATE TABLE IF NOT EXISTS  tipo_quarto (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR(255),
	valor_diaria DECIMAL
);

CREATE TABLE IF NOT EXISTS quartos (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	tipo INTEGER,
    numero VARCHAR(255),
	FOREIGN KEY (tipo) REFERENCES tipo_quarto(id),
    INDEX (numero)
);


CREATE TABLE IF NOT EXISTS internacao (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	paciente INTEGER,
	medico INTEGER,
    quarto VARCHAR(255),
	data_entrada DATE,
	data_prev_alta DATE,
	data_alta DATE,
	procedimento TEXT,
    FOREIGN KEY (paciente) REFERENCES pacientes(id),
    FOREIGN KEY (medico) REFERENCES medicos(id),
    FOREIGN KEY (quarto) REFERENCES quartos(numero)
);



CREATE TABLE IF NOT EXISTS enfermeiro (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(255),
	cpf VARCHAR(15) UNIQUE,
	cre VARCHAR(255) UNIQUE
);


-- TABELA PARA MUITOS
CREATE TABLE IF NOT EXISTS enfermeiro_internacao (
	enfermeiro_id INTEGER,
    internacao_id INTEGER,
    FOREIGN KEY (enfermeiro_id) REFERENCES enfermeiro(id),
    FOREIGN KEY (internacao_id) REFERENCES internacao(id)
);

CREATE TABLE IF NOT EXISTS medico_especialidade (
	medico_id INTEGER,
    especialidade_id INTEGER,
    FOREIGN KEY (medico_id) REFERENCES medicos(id),
    FOREIGN KEY (especialidade_id) REFERENCES especialidades(id)
);


-- Trigger para validar se o convenio da consulta é o mesmo convenio atrelado no cadastro do paciente.
DELIMITER //

CREATE TRIGGER check_convenio BEFORE INSERT ON consultas
FOR EACH ROW
BEGIN
    DECLARE v_convenio_id VARCHAR(255);

    SELECT convenio_id INTO v_convenio_id
    FROM pacientes
    WHERE id = NEW.paciente;

    IF NEW.convenio != v_convenio_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Convenio diferente do cadastro. paciente especificado.';
    END IF;
END //

DELIMITER ;

-- ALTERAÇÕES:
-- Adicionei campo em_atividade na tabela medicos | Alterar DER do Workbench

-- FAZER:
-- CRIAR UMA TABELA DE CONVENIO:
-- Para cada convênio, são registrados nome, CNPJ e tempo de carência.
-- E na tabela consultas: valor da consulta ou nome do convênio, com o número da carteira


SELECT enfermeiro.id AS id_enfermeiro,internacao.id AS internacao_id
FROM enfermeiro
INNER JOIN enfermeiro_internacao ON enfermeiro.id = enfermeiro_internacao.enfermeiro_id
INNER JOIN internacao ON enfermeiro_internacao.internacao_id = internacao.id
WHERE enfermeiro.id = '1';

SELECT * FROM medico_especialidade;
SELECT * FROM especialidades;
SELECT * FROM enfermeiro;
SELECT * FROM internacao;
SELECT * FROM internacao WHERE paciente = '1';
SELECT * FROM pacientes;
SELECT * FROM receita_medica;
SELECT * FROM medicos;
SELECT * FROM consultas;
SELECT * FROM medicos WHERE cpf = 52911072343;

INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072350','Medico1','11989915350');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072351','Medico2','11989915351');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072352','Medico3','11989915352');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072353','Medico4','11989915353');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072354','Gabriel','11989915354');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072355','Medico6','11989915355');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072356','Medico7','11989915356');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072357','Medico8','11989915357');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072358','Medico9','11989915358');
INSERT INTO medicos (cpf,nome,telefone) VALUES ('52911072359','Medico10','11989915359');

INSERT INTO especialidades (especialidade) VALUES ('Pediatria');
INSERT INTO especialidades (especialidade) VALUES ('Clínica geral');
INSERT INTO especialidades (especialidade) VALUES ('Gastrenterologia');
INSERT INTO especialidades (especialidade) VALUES ('Dermatologia');
INSERT INTO especialidades (especialidade) VALUES ('Neurologia');
INSERT INTO especialidades (especialidade) VALUES ('Otorrinolaringologia');
INSERT INTO especialidades (especialidade) VALUES ('Psiquiatria');
INSERT INTO especialidades (especialidade) VALUES('Ortopedia');

INSERT INTO medico_especialidade (medico_id,especialidade_id) VALUES (2,2);
INSERT INTO medico_especialidade (medico_id,especialidade_id) VALUES (2,3);
INSERT INTO medico_especialidade (medico_id,especialidade_id) VALUES (2,4);


INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente1','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072850','574839150','100');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente2','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072851','574838151','110');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente3','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072852','574837152','120');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente4','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072853','574837153','130');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente5','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072854','574837114','140');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente6','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072855','574839155','150');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente7','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072856','574838156','160');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente8','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072857','574837157','170');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente9','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072858','574837158','180');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg,convenio_id) VALUES ('Paciente10','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072859','574837111','190');
-- SEM CONVENIO
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg) VALUES ('Paciente11','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072860','574839160');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg) VALUES ('Paciente12','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072861','574838161');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg) VALUES ('Paciente13','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072862','574837162');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg) VALUES ('Paciente14','20040122','rua dos bobos','11989915357','email.sql@gmail.com','52311072863','574837163');
INSERT INTO pacientes (nome,data_nascimento,endereco,telefone,email,cpf,rg) VALUES ('Paciente15','20080122','rua dos bobos','11989915357','email.sql@gmail.com','52311072864','574837164');

-- Tipos de quarto padrão
INSERT INTO tipo_quarto(descricao,valor_diaria) VALUES ("Quarto Apartamento","100");
INSERT INTO tipo_quarto(descricao,valor_diaria) VALUES ("Quarto duplo","50");
INSERT INTO tipo_quarto (descricao,valor_diaria) VALUES ("Enfermaria","10");

-- Quartos do Hospital
INSERT INTO quartos (tipo,numero) VALUES ('1','2');
INSERT INTO quartos (tipo,numero) VALUES ('2','3');
INSERT INTO quartos (tipo,numero) VALUES ('3','4');
INSERT INTO quartos (tipo,numero) VALUES ('1','5');



INSERT INTO tipo_quarto(descricao,valor_diaria) VALUES ("Quarto Apartamento","100");
INSERT INTO tipo_quarto(descricao,valor_diaria) VALUES ("Quarto duplo","50");
INSERT INTO tipo_quarto (descricao,valor_diaria) VALUES ("Enfermaria","10");

INSERT INTO internacao (paciente,medico,quarto,data_entrada,data_prev_alta,data_alta,procedimento) VALUES ('1','1','2','20031023','20031123','20031201','procedimento da internacao');
INSERT INTO internacao (paciente,medico,quarto,data_entrada,data_prev_alta,data_alta,procedimento) VALUES ('2','2','2','20031023','20031123','20031201','procedimento da internacao');

-- Enfermeiros
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Ana Clara', '52911072756', 'CRE123');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Bruno Souza', '48976523291', 'CRE124');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Carla Silva', '37852165948', 'CRE125');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Daniel Costa', '21458963214', 'CRE126');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Eduarda Pereira', '34715968247', 'CRE127');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Fabio Almeida', '56987412536', 'CRE128');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Gabriela Ramos', '78456391245', 'CRE129');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Henrique Oliveira', '45896213784', 'CRE130');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('Isabela Santos', '21456389742', 'CRE131');
INSERT INTO enfermeiro (nome, cpf, cre) VALUES ('João Fernandes', '36587415924', 'CRE132');


INSERT INTO internacao (paciente, medico, quarto, data_entrada, data_prev_alta, data_alta, procedimento)VALUES
    (1, 3, '5', '2015-03-15', '2015-03-20', '2015-03-19', 'Cirurgia de apendicite'),
    (2, 5, '2', '2016-05-10', '2016-05-15', '2016-05-14', 'Tratamento de pneumonia'),
    (3, 7, '3', '2017-08-22', '2017-08-27', '2017-08-26', 'Cirurgia de joelho'),
    (1, 2, '4', '2018-01-10', '2018-01-20', '2018-01-19', 'Tratamento de infecção urinária'),
    (4, 9, '5', '2019-11-11', '2019-11-20', '2019-11-19', 'Tratamento de fratura de braço'),
    (5, 8, '2', '2020-02-01', '2020-02-10', '2020-02-09', 'Cirurgia de hérnia'),
    (2, 4, '3', '2021-04-05', '2021-04-15', '2021-04-14', 'Tratamento de asma');


-- Associando cada internação a pelo menos dois enfermeiros
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (1, 1);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (2, 1);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (3, 2);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (4, 2);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (5, 3);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (6, 3);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (7, 4);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (8, 4);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (9, 5);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (10, 5);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (1, 6);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (3, 6);

INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (2, 7);
INSERT INTO enfermeiro_internacao (enfermeiro_id, internacao_id) VALUES (4, 7);

INSERT INTO receita_medica (medico, medicamentos, quantidade, instrucoes) VALUES
('52911072350', 'Dipirona, Oxandrolona', '2 doses de 100 mg', 'Usar de vez em quando'),
('52911072351', 'Paracetamol, Amoxicilina', '3 doses de 500 mg', 'Tomar após as refeições'),
('52911072352', 'Ibuprofeno, Azitromicina', '1 dose de 200 mg, 1 dose de 500 mg', 'Tomar antes de dormir'),
('52911072353', 'Metformina, Insulina', '2 doses de 850 mg, 2 doses de 10 unidades', 'Usar diariamente'),
('52911072354', 'Losartana, Hidroclorotiazida', '1 dose de 50 mg, 1 dose de 25 mg', 'Tomar pela manhã'),
('52911072355', 'Omeprazol, Claritromicina', '2 doses de 20 mg, 2 doses de 500 mg', 'Tomar antes das refeições'),
('52911072356', 'Atenolol, Simvastatina', '1 dose de 50 mg, 1 dose de 20 mg', 'Usar à noite'),
('52911072357', 'Aspirina, Clopidogrel', '1 dose de 100 mg, 1 dose de 75 mg', 'Usar diariamente'),
('52911072358', 'Levotiroxina, Prednisona', '1 dose de 100 mcg, 2 doses de 20 mg', 'Tomar pela manhã'),
('52911072359', 'Cefalexina, Ibuprofeno', '2 doses de 500 mg, 3 doses de 200 mg', 'Tomar de 8 em 8 horas');


-- SELECT * FROM consultas;

INSERT INTO consultas (data, medico, paciente, valor, convenio, especialidade, receita_id) VALUES
('2015-01-14', 2, 1, 150.00, NULL, 2, 2),
('2015-02-20', 3, 1, 200.00, '100', 3, 1),
('2015-03-15', 4, 2, 180.00, '110', 4, 3),
('2015-06-05', 5, 3, 220.00, null, 5, NULL),
('2015-08-23', 6, 4, 250.00, '130', 6, 5),
('2015-10-30', 7, 5, 190.00, null, 7, NULL),
('2015-11-14', 8, 6, 160.00, '150', 5, 6),
('2016-01-10', 9, 7, 210.00, '160', 2, 7),
('2016-05-19', 10, 8, 230.00, '170', 3, NULL),
('2016-09-25', 2, 9, 175.00, '180', 1, 8),
('2017-01-11', 2, 10, 150.00, '190', 1, 9),
('2017-05-06', 3, 11, 200.00, NULL, 3, NULL),
('2017-09-24', 4, 12, 180.00, NULL, 1, 10),
('2018-01-18', 5, 13, 220.00,NULL, 5, NULL),
('2018-12-14', 6, 14, 250.00, null, 4, 1),
('2019-03-09', 7, 1, 190.00, '100', 5, NULL),
('2020-04-20', 8, 4, 160.00, '130', 6, 1),
('2020-07-25', 9, 2, 210.00, '110', 7, NULL),
('2020-11-30', 10, 3, 230.00, '120', 4, 2),
('2021-01-01', 4, 4, 175.00, '130', 3, 3);

-- Updates de tabela EX4

ALTER TABLE medicos
ADD COLUMN em_atividade BOOLEAN DEFAULT 1;

UPDATE medicos
SET em_atividade = 0
WHERE id IN (1, 2);

UPDATE medicos
SET em_atividade = 1
WHERE id NOT IN (1, 2);

-- Formulário 5 As Relíquias dos Dados

-- Todos os dados e o valor médio das consultas do ano de 2020 e das que foram feitas sob convênio.
-- Consultas de 2020
SELECT * FROM consultas
WHERE YEAR(data) = 2020;

-- Valor médio das consultas de 2020
SELECT AVG(valor) AS valor_medio_2020 FROM consultas
WHERE YEAR(data) = 2020;

-- Consultas feitas sob convênio
SELECT * FROM consultas
WHERE convenio IS NOT NULL;

-- Valor médio das consultas feitas sob convênio
SELECT AVG(valor) AS valor_medio_convenio FROM consultas
WHERE convenio IS NOT NULL;

-- Todos os dados das internações que tiveram data de alta maior que a data prevista para a alta.
-- Internações com data de alta maior que a data prevista para alta
SELECT * FROM internacao
WHERE data_alta > data_prev_alta;

-- Receituário completo da primeira consulta registrada com receituário associado.


SELECT consultas.*, receita_medica.*
FROM consultas
JOIN receita_medica ON consultas.receita_id = receita_medica.id
WHERE consultas.receita_id IS NOT NULL
ORDER BY consultas.id ASC
LIMIT 1;


-- Selecionar consulta de maior valor não realizada sob convênio
SELECT *
FROM consultas
WHERE convenio IS NULL
ORDER BY valor DESC
LIMIT 1;

-- Selecionar consulta de menor valor não realizada sob convênio
SELECT *
FROM consultas
WHERE convenio IS NULL
ORDER BY valor ASC
LIMIT 1;

-- Combinar os resultados das duas consultas
(SELECT *
FROM consultas
WHERE convenio IS NULL
ORDER BY valor DESC
LIMIT 1)
UNION
(SELECT *
FROM consultas
WHERE convenio IS NULL
ORDER BY valor ASC
LIMIT 1);

-- Todos os dados das internações em seus respectivos quartos, calculando o total da internação a partir do valor de diária do quarto e o número de dias entre a entrada e a alta.
SELECT 
    i.*,
    q.numero AS numero_quarto, 
    tq.descricao AS tipo_quarto, 
    tq.valor_diaria,
    DATEDIFF(i.data_alta, i.data_entrada) AS dias_internacao,
    DATEDIFF(i.data_alta, i.data_entrada) * tq.valor_diaria AS total_internacao
FROM 
    internacao i
JOIN 
    quartos q ON i.quarto = q.numero
JOIN 
    tipo_quarto tq ON q.tipo = tq.id
ORDER BY 
    i.id;

-- Data, procedimento e número de quarto de internações em quartos do tipo “apartamento”

SELECT data_alta,procedimento,quarto FROM internacao 

JOIN 
    quartos q ON internacao.quarto = q.numero
JOIN 
    tipo_quarto tq ON q.tipo = tq.id

WHERE tq.id = 1;

-- Nome do paciente, data da consulta e especialidade de todas as consultas em que os pacientes eram menores de 18 anos na data da consulta e cuja especialidade não seja “pediatria”, ordenando por data de realização da consulta.
 

SELECT 
    p.nome AS nome_paciente,
    c.data AS data_consulta,
    e.especialidade AS especialidade
FROM 
    consultas c
JOIN 
    pacientes p ON c.paciente = p.id
JOIN 
    especialidades e ON c.especialidade = e.id
WHERE 
    TIMESTAMPDIFF(YEAR, p.data_nascimento, c.data) < 18 
    AND e.especialidade <> 'pediatria'
ORDER BY 
    c.data ASC;
    

-- Nome do paciente, nome do médico, data da internação e procedimentos das internações realizadas por médicos da especialidade “gastroenterologia”, que tenham acontecido em “enfermaria”.

SELECT 
    p.nome AS nome_paciente,
    m.nome AS nome_medico,
    i.data_entrada,
    i.procedimento
FROM 
    internacao i
JOIN 
    pacientes p ON i.paciente = p.id
JOIN 
    medicos m ON i.medico = m.id
JOIN 
    medico_especialidade me ON m.id = me.medico_id
JOIN 
    especialidades e ON me.especialidade_id = e.id
JOIN 
    quartos q ON i.quarto = q.numero
JOIN 
    tipo_quarto tq ON q.tipo = tq.id
WHERE 
    e.especialidade = 'Gastroenterologia'
    AND tq.descricao = 'Enfermaria';

-- Os nomes dos médicos, seus CRMs e a quantidade de consultas que cada um realizou.

SELECT 
    m.nome AS nome_medico,
    m.id AS CRM,
    COUNT(c.id) AS quantidade_consultas
FROM 
    medicos m
LEFT JOIN 
    consultas c ON m.id = c.medico
GROUP BY 
    m.id, m.nome
ORDER BY 
    quantidade_consultas DESC;
    
-- Todos os médicos que tenham "Gabriel" no nome. 

SELECT * FROM medicos WHERE nome="Gabriel";

-- Os nomes, CREs e número de internações de enfermeiros que participaram de mais de uma internação.

SELECT 
    e.nome AS nome_enfermeiro,
    e.cre AS CRE,
    COUNT(ei.internacao_id) AS numero_internacoes
FROM 
    enfermeiro e
JOIN 
    enfermeiro_internacao ei ON e.id = ei.enfermeiro_id
GROUP BY 
    e.id
HAVING 
    COUNT(ei.internacao_id) > 1
ORDER BY 
    numero_internacoes DESC;