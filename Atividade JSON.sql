create database ecommerce;
use ecommerce;

CREATE TABLE eventos(
id int auto_increment primary key,
nome_evento varchar(255),
visitante varchar(255),
propriedades json,
navegador json
);

INSERT INTO eventos(nome_evento, visitante,propriedades,navegador)
VALUES ('pageview', '1','{ "page": "/" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'),
('pageview', '2','{ "page": "/contact" }','{ "name": "Firefox", "os": "Windows", "resolution": { "x": 2560, "y": 1600 } }'),
('pageview', '1','{ "page": "/products" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'),
('purchase', '3','{ "amount": 200 }','{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1600, "y": 900 } }'),
('purchase','4','{ "amount": 150 }','{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1280, "y": 800 } }'),
('purchase','4','{ "amount": 500 }','{ "name": "Chrome", "os": "Windows", "resolution": { "x": 1680, "y": 1050 } }'),
('purchase', '1','{ "amount": "200" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'),
('purchase', '1','{ "amount": "300" }','{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }');


/* 2 -
a) Selecionar o nome dos navegadores (name) e sistemas operacionais (os) utilizados pelos visitantes, 
ordenando pelo nome do sistema operacional. Elimine as repetições.*/
select distinct JSON_EXTRACT(navegador, '$.name' ) nome_navegador, JSON_EXTRACT(navegador, '$.os' ) OS
from eventos
order by 1;

/*b. Selecionar a quantidade de acessos por nome de navegador.*/
select JSON_EXTRACT(navegador, '$.name') nome_navegador, count(JSON_EXTRACT(navegador, '$.name')) quantidade_acessos
 from eventos
 group by 1;
 
/* c. Selecionar o total pago para cada um dos visitantes que efetuaram compras.*/
select visitante, sum(JSON_EXTRACT(propriedades, '$.amount')) total_pago 
from eventos
where nome_evento = 'purchase'
group by visitante;

/* d. Selecionar o nome do navegador e a resolução no formato x X y. Elimine as repetições.
		i. Crie uma função para formatar a resolução no format x X y (ex. 1920 X 1080)
				1. Entrada: valor de x e valor de y
				2. Saída: string com a formatação x X y*/
                
select distinct JSON_EXTRACT(navegador, '$.name') nome_navegador, JSON_EXTRACT(navegador, '$.resolution') resolucao
from eventos;

delimiter $
create function formatar(x varchar(4), y varchar(4))
returns varchar(10)
begin
return concat(x, " X ", y);
end $
delimiter ;

select distinct JSON_EXTRACT(navegador, '$.name') nome_navegador, 
formatar(JSON_EXTRACT(navegador, '$.resolution.x'), JSON_EXTRACT(navegador, '$.resolution.y')) resolucao
from eventos;            

/* e. Selecionar a maior e a menor resolução dos visitantes que acessaram o site.*/
select max(formatar(JSON_EXTRACT(navegador, '$.resolution.x'), JSON_EXTRACT(navegador, '$.resolution.y'))) maior_resolucao, 
min(formatar(JSON_EXTRACT(navegador, '$.resolution.x'), JSON_EXTRACT(navegador, '$.resolution.y'))) menor_maior_resolucao
from eventos;

/* f. Selecionar os dados de navegação dos visitantes que fizeram alguma compra com o
valor igual ou superior à 400.*/
select navegador, JSON_EXTRACT(propriedades, '$.amount') compra
from eventos
where JSON_EXTRACT(propriedades, '$.amount') >= 400;
