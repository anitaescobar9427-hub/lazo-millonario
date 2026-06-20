-- ════════════════════════════════════════
-- DATOS DE ANA ISABEL — migración desde localStorage
-- Ejecutar DESPUÉS de supabase_schema.sql
-- ════════════════════════════════════════

-- Asistencias
update competencias set asistencia = 'si' where id = 'c01';
update competencias set asistencia = 'no' where id = 'c02';
update competencias set asistencia = 'tal' where id = 'c04';
update competencias set asistencia = 'tal' where id = 'c08';
update competencias set asistencia = 'tal' where id = 'c10';
update competencias set asistencia = 'tal' where id = 'c14';
update competencias set asistencia = 'tal' where id = 'c18';
update competencias set asistencia = 'tal' where id = 'c20';
update competencias set asistencia = 'no' where id = 'c06';
update competencias set asistencia = 'no' where id = 'c07';
update competencias set asistencia = 'no' where id = 'c09';
update competencias set asistencia = 'no' where id = 'c11';
update competencias set asistencia = 'tal' where id = 'c12';
update competencias set asistencia = 'no' where id = 'c13';
update competencias set asistencia = 'no' where id = 'c16';
update competencias set asistencia = 'no' where id = 'c17';
update competencias set asistencia = 'no' where id = 'c19';

-- Resultados de competencia
insert into resultados_competencia (competencia_id, lazos, notas_generales, fecha)
values ('c01', '[{"status": "ef", "cats": [], "notes": "Buen lazo, de lejos, conciso"}, {"status": "fa", "cats": [], "notes": "Muy lejos, tire mal"}, {"status": "fa", "cats": [], "notes": "Se pasó "}, {"status": "ef", "cats": [], "notes": ""}, {"status": "fa", "cats": [], "notes": "Brazalete"}, {"status": "ef", "cats": [], "notes": ""}, {"status": "fa", "cats": [], "notes": "Se pasó"}, {"status": "ef", "cats": [], "notes": "Ajusté el cabo"}, {"status": "ef", "cats": [], "notes": "Faltó ajustar"}, {"status": null, "cats": [], "notes": ""}]'::jsonb, 'Dia 1: muy malo, dos salidas robadas, 1 pasada, 1 brazalete y un aburrimiento el hijueputa. Pero no me voy a rendir, yo puedo, yo quiero, yo lo merezco y voy a trabajar por eso. 

Día 2: Tranquila, sin presión. Me di cuenta de dos errores grandes:
- Cabo muy largo
- Faltaba cobertura a la derecha

Trabajar partidor del caballo para q aprenda a salir con la novilla

', '2026-06-07')
on conflict (competencia_id) do update set lazos = excluded.lazos, notas_generales = excluded.notas_generales, fecha = excluded.fecha, updated_at = now();

-- Finanzas
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('otro_g', 250000, 'c01', '2026-06-07', 'Parafrenero');
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('otro_g', 200000, 'c01', '2026-06-07', 'Bonificación Rubén');
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('comida', 150000, 'c01', '2026-06-07', 'Alimentación Rubén');
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('otro_g', 1700000, 'c01', '2026-06-06', 'Palco');
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('caballo', 150000, 'c01', '2026-06-06', 'Comida Ruben');
insert into finanzas (tipo, monto, competencia_id, fecha, nota) values ('inscripcion', 1500000, 'c01', '2026-06-06', 'Inscripción');

-- Cuaderno
insert into cuaderno_entradas (fecha, texto) values ('2026-06-07', 'Estoy aburrida, frustrada, con el ánimo y el autoestima por el piso, pero con la determinación de seguir entrenando, de perseverar y de ser la mejor vaquera del país. A partir de mañana empieza mi entreno para el lazo millonario 2027');
