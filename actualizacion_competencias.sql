-- Guarda las inscripciones (categoría + caballo) y el total de lazos de cada competencia
alter table resultados_competencia add column if not exists total_lazos int;
alter table resultados_competencia add column if not exists inscripciones jsonb;
